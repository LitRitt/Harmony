//
//  UploadRecordOperation.swift
//  Harmony
//
//  Created by Riley Testut on 10/1/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

import CoreData

class UploadRecordOperation: RecordOperation<RemoteRecord, UploadError>
{
    required init(record: ManagedRecord, service: Service, context: NSManagedObjectContext) throws
    {
        try super.init(record: record, service: service, context: context)
        
        guard let localRecord = self.record.localRecord else {
            throw self.recordError(code: .nilLocalRecord)
        }
        
        guard let recordedObject = localRecord.recordedObject else {
            throw self.recordError(code: .nilRecordedObject)
        }
        
        self.progress.totalUnitCount = Int64(recordedObject.syncableFiles.count) + 1
    }
    
    override func main()
    {
        super.main()
        
        self.uploadFiles() { (result) in
            do
            {
                let remoteFiles = try result.value()
                
                // We're on record's context queue, so we can update attributes.
                self.record.localRecord?.remoteFiles = remoteFiles
                
                self.uploadRecord() { (result) in
                    self.result = result
                    self.finish()
                }
            }
            catch
            {
                self.result = .failure(error)
                self.finish()
            }
        }
    }
    
    private func uploadFiles(completionHandler: @escaping (Result<Set<RemoteFile>>) -> Void)
    {
        guard let localRecord = self.record.localRecord else { return completionHandler(.failure(self.recordError(code: .nilLocalRecord))) }
        guard let recordedObject = localRecord.recordedObject else { return completionHandler(.failure(self.recordError(code: .nilRecordedObject))) }
        
        let files = recordedObject.syncableFiles
        
        let uploadFilesProgress = Progress(totalUnitCount: Int64(files.count), parent: self.progress, pendingUnitCount: Int64(files.count))
        
        var remoteFiles = Set<RemoteFile>()
        var errors = [Error]()
        
        let dispatchGroup = DispatchGroup()
        
        for file in files
        {
            dispatchGroup.enter()
            
            let metadata: [HarmonyMetadataKey: Any] = [.relationshipIdentifier: file.identifier]
            
            let progress = self.service.upload(file, for: localRecord, metadata: metadata) { (result) in
                do
                {
                    let remoteFile = try result.value()
                    remoteFiles.insert(remoteFile)
                }
                catch HarmonyError.Code.cancelled
                {
                    // Ignore
                }
                catch
                {
                    errors.append(error)
                    
                    uploadFilesProgress.cancel()
                }
                
                dispatchGroup.leave()
            }
            
            uploadFilesProgress.addChild(progress, withPendingUnitCount: 1)
        }
        
        dispatchGroup.notify(queue: .global()) {
            self.record.managedObjectContext?.perform {
                if !errors.isEmpty
                {
                    completionHandler(.failure(self.recordError(code: .fileUploadsFailed(errors))))
                }
                else
                {
                    completionHandler(.success(remoteFiles))
                }
            }
        }
    }
    
    private func uploadRecord(completionHandler: @escaping (Result<RemoteRecord>) -> Void)
    {
        guard let localRecord = self.record.localRecord else { return completionHandler(.failure(self.recordError(code: .nilLocalRecord))) }
        
        var metadata: [HarmonyMetadataKey: Any] = [.recordedObjectType: localRecord.recordedObjectType,
                                                   .recordedObjectIdentifier: localRecord.recordedObjectIdentifier]
        
        if self.record.shouldLockWhenUploading
        {
            metadata[.isLocked] = true
        }
        
        // Keep track of the previous non-locked version, so we can restore to it in case record is locked indefinitely.
        if let remoteRecord = self.record.remoteRecord, !remoteRecord.isLocked
        {
            metadata[.previousVersionIdentifier] = remoteRecord.version.identifier
            metadata[.previousVersionDate] = String(remoteRecord.version.date.timeIntervalSinceReferenceDate)
        }
        
        let progress = self.service.upload(localRecord, metadata: metadata, context: self.managedObjectContext) { (result) in
            do
            {
                let remoteRecord = try result.value()
                remoteRecord.status = .normal
                
                let localRecord = localRecord.in(self.managedObjectContext)
                localRecord.version = remoteRecord.version
                localRecord.status = .normal
                
                completionHandler(.success(remoteRecord))
            }
            catch
            {
                completionHandler(.failure(error))
            }
        }
        
        self.progress.addChild(progress, withPendingUnitCount: self.progress.totalUnitCount)
    }
}
