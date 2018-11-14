//
//  Errors.swift
//  Harmony
//
//  Created by Riley Testut on 1/29/18.
//  Copyright © 2018 Riley Testut. All rights reserved.
//

import Foundation
import CoreData

public enum _HarmonyErrorCode: Equatable
{
    case cancelled
    
    case unknown
    case any(Error)
    
    case databaseCorrupted(Error)
    
    case noSavedCredentials
    
    case invalidChangeToken
    case invalidResponse
    case invalidSyncableIdentifier
    
    case invalidMetadata
    
    case nilManagedObjectContext
    case nilLocalRecord
    case nilRemoteRecord
    case nilRecordedObject
    case nilManagedRecord
    case nilRelationshipObject
    
    case recordLocked
    case recordDoesNotExist
    case recordSyncingDisabled
    
    case unknownFile
    case fileDoesNotExist
    
    case fileUploadsFailed([Error])
    case fileDownloadsFailed([Error])
    case fileDeletionsFailed([Error])
    
    case conflicted
        
    case unknownRecordType(String)
    case nonSyncableRecordType(String)
    
    public var failureReason: String? {
        switch self
        {
        case .cancelled: return NSLocalizedString("The operation was cancelled.", comment: "")
        case .unknown: return NSLocalizedString("An unknown error occured.", comment: "")
        case .any(let error as NSError): return error.localizedFailureReason ?? error.localizedDescription
        case .databaseCorrupted: return NSLocalizedString("The syncing database is corrupted.", comment: "")
        case .noSavedCredentials: return NSLocalizedString("There are no saved credentials for the current user.", comment: "")
        case .invalidChangeToken: return NSLocalizedString("The provided change token was invalid.", comment: "")
        case .invalidResponse: return NSLocalizedString("The server returned an invalid response.", comment: "")
        case .invalidSyncableIdentifier: return NSLocalizedString("The recorded object has an invalid syncable identifier.", comment: "")
        case .invalidMetadata: return NSLocalizedString("The file's metadata is invalid.", comment: "")
        case .nilManagedObjectContext: return NSLocalizedString("The record's managed object context is nil.", comment: "")
        case .nilLocalRecord: return NSLocalizedString("The record's local data could not be found.", comment: "")
        case .nilRemoteRecord: return NSLocalizedString("The record's remote data could not be found.", comment: "")
        case .nilRecordedObject: return NSLocalizedString("The recorded object could not be found.", comment: "")
        case .nilManagedRecord: return NSLocalizedString("The record could not be found.", comment: "")
        case .nilRelationshipObject: return NSLocalizedString("The relationship object could not be found.", comment: "")
        case .recordLocked: return NSLocalizedString("The record is locked.", comment: "")
        case .recordDoesNotExist: return NSLocalizedString("The record does not exist.", comment: "")
        case .recordSyncingDisabled: return NSLocalizedString("Syncing is disabled for the record.", comment: "")
        case .unknownFile: return NSLocalizedString("The file is unknown.", comment: "")
        case .fileDoesNotExist: return NSLocalizedString("The file does not exist.", comment: "")
        case .fileUploadsFailed: return NSLocalizedString("The record's files could not be uploaded.", comment: "")
        case .fileDownloadsFailed: return NSLocalizedString("The record's files could not be downloaded.", comment: "")
        case .fileDeletionsFailed: return NSLocalizedString("The record's files could not be deleted.", comment: "")
        case .conflicted: return NSLocalizedString("There is a conflict with the record.", comment: "")
        case .unknownRecordType(let type): return String.localizedStringWithFormat("Unknown record type '%@'.", type)
        case .nonSyncableRecordType(let type): return String.localizedStringWithFormat("Record type '%@' does not support syncing.", type)
        }
    }
}

public func ==(lhs: _HarmonyErrorCode, rhs: _HarmonyErrorCode) -> Bool
{
    switch (lhs, rhs)
    {
    case (.cancelled, .cancelled): return true
    case (.unknown, .unknown): return true
    case (.any(let a), .any(let b)): return (a as NSError) == (b as NSError)
    case (.databaseCorrupted(let a), .databaseCorrupted(let b)): return (a as NSError) == (b as NSError)
    case (.noSavedCredentials, .noSavedCredentials): return true
    case (.invalidChangeToken, .invalidChangeToken): return true
    case (.invalidResponse, .invalidResponse): return true
    case (.invalidSyncableIdentifier, .invalidSyncableIdentifier): return true
    case (.invalidMetadata, .invalidMetadata): return true
    case (.nilManagedObjectContext, .nilManagedObjectContext): return true
    case (.nilLocalRecord, .nilLocalRecord): return true
    case (.nilRemoteRecord, .nilRemoteRecord): return true
    case (.nilRecordedObject, .nilRecordedObject): return true
    case (.nilManagedRecord, .nilManagedRecord): return true
    case (.nilRelationshipObject, .nilRelationshipObject): return true
    case (.recordLocked, .recordLocked): return true
    case (.recordDoesNotExist, .recordDoesNotExist): return true
    case (.recordSyncingDisabled, .recordSyncingDisabled): return true
    case (.unknownFile, .unknownFile): return true
    case (.fileDoesNotExist, .fileDoesNotExist): return true
    case (.fileUploadsFailed(let a), .fileUploadsFailed(let b)): return a.map { $0 as NSError } == b.map { $0 as NSError }
    case (.fileDownloadsFailed(let a), .fileDownloadsFailed(let b)): return a.map { $0 as NSError } == b.map { $0 as NSError }
    case (.fileDeletionsFailed(let a), .fileDeletionsFailed(let b)): return a.map { $0 as NSError } == b.map { $0 as NSError }
    case (.conflicted, .conflicted): return true
    case (.unknownRecordType(let a), .unknownRecordType(let b)): return a == b
    case (.nonSyncableRecordType(let a), .nonSyncableRecordType(let b)): return a == b
        
    case (.cancelled, _): return false
    case (.unknown, _): return false
    case (.any, _): return false
    case (.databaseCorrupted, _): return false
    case (.noSavedCredentials, _): return false
    case (.invalidChangeToken, _): return false
    case (.invalidResponse, _): return false
    case (.invalidSyncableIdentifier, _): return false
    case (.invalidMetadata, _): return false
    case (.nilManagedObjectContext, _): return false
    case (.nilLocalRecord, _): return false
    case (.nilRemoteRecord, _): return false
    case (.nilRecordedObject, _): return false
    case (.nilManagedRecord, _): return false
    case (.nilRelationshipObject, _): return false
    case (.recordLocked, _): return false
    case (.recordDoesNotExist, _): return false
    case (.recordSyncingDisabled, _): return false
    case (.unknownFile, _): return false
    case (.fileDoesNotExist, _): return false
    case (.fileUploadsFailed, _): return false
    case (.fileDownloadsFailed, _): return false
    case (.fileDeletionsFailed, _): return false
    case (.conflicted, _): return false
    case (.unknownRecordType, _): return false
    case (.nonSyncableRecordType, _): return false
    }
}

public protocol HarmonyError: LocalizedError, CustomNSError
{
    typealias Code = _HarmonyErrorCode
    
    var code: Code { get }
    var failureDescription: String { get }
}

extension HarmonyError
{
    public var failureReason: String? {
        return self.code.failureReason
    }
    
    public var errorUserInfo: [String : Any] {
        let userInfo = [NSLocalizedFailureErrorKey: self.failureDescription]
        return userInfo
    }
}

public struct AnyError: HarmonyError
{
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("The operation could not be completed.", comment: "")
    }
    
    public init(code: HarmonyError.Code)
    {
        self.code = code
    }
}

public struct SyncError: HarmonyError
{
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to sync.", comment: "")
    }
    
    init(code: HarmonyError.Code)
    {
        self.code = code
    }
}

public struct AuthenticationError: HarmonyError
{
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to authenticate user.", comment: "")
    }
    
    public init(code: HarmonyError.Code)
    {
        self.code = code
    }
}

public struct LocalRecordError: HarmonyError
{
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to create local record.", comment: "")
    }
    
    init(code: HarmonyError.Code)
    {
        self.code = code
    }
}

public struct RemoteRecordError: HarmonyError
{
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to parse remote record.", comment: "")
    }
    
    init(code: HarmonyError.Code)
    {
        self.code = code
    }
}

public struct RemoteFileError: HarmonyError
{
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to parse remote file.", comment: "")
    }
    
    init(code: HarmonyError.Code)
    {
        self.code = code
    }
}

public struct FetchError: HarmonyError
{
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to fetch record.", comment: "")
    }
    
    public init(code: HarmonyError.Code)
    {
        self.code = code
    }
}


/* Record Errors */

protocol RecordError: HarmonyError
{
    var record: ManagedRecord { get }
    
    init(record: ManagedRecord, code: HarmonyError.Code)
}

public struct UploadError: RecordError
{
    public var record: ManagedRecord
    public var code: HarmonyError.Code
    
    private var recordContext: NSManagedObjectContext?
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to upload record.", comment: "")
    }
    
    public init(record: ManagedRecord, code: HarmonyError.Code)
    {
        self.record = record
        self.code = code
        
        self.recordContext = self.record.managedObjectContext
    }
}

public struct DownloadError: RecordError
{
    public var record: ManagedRecord
    public var code: HarmonyError.Code
    
    private var recordContext: NSManagedObjectContext?
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to download record.", comment: "")
    }
    
    public init(record: ManagedRecord, code: HarmonyError.Code)
    {
        self.record = record
        self.code = code
        
        self.recordContext = self.record.managedObjectContext
    }
}

public struct DeleteError: RecordError
{
    public var record: ManagedRecord
    public var code: HarmonyError.Code
    
    private var recordContext: NSManagedObjectContext?
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to delete record.", comment: "")
    }
    
    public init(record: ManagedRecord, code: HarmonyError.Code)
    {
        self.record = record
        self.code = code
        
        self.recordContext = self.record.managedObjectContext
    }
}

public struct ConflictError: RecordError
{
    public var record: ManagedRecord
    public var code: HarmonyError.Code
    
    private var recordContext: NSManagedObjectContext?
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to mark record as conflicted.", comment: "")
    }
    
    public init(record: ManagedRecord, code: HarmonyError.Code)
    {
        self.record = record
        self.code = code
        
        self.recordContext = self.record.managedObjectContext
    }
}

/* File Errors */

public struct UploadFileError: HarmonyError
{
    public var file: File
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to upload file.", comment: "")
    }
    
    public init(file: File, code: HarmonyError.Code)
    {
        self.file = file
        self.code = code
    }
}

public struct DownloadFileError: HarmonyError
{
    public var file: RemoteFile
    public var code: HarmonyError.Code
    
    private var fileContext: NSManagedObjectContext?
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to download file.", comment: "")
    }
    
    public init(file: RemoteFile, code: HarmonyError.Code)
    {
        self.file = file
        self.code = code
        
        self.fileContext = file.managedObjectContext
    }
}

public struct DeleteFileError: HarmonyError
{
    public var file: RemoteFile
    public var code: HarmonyError.Code
    
    private var fileContext: NSManagedObjectContext?
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to delete remote file.", comment: "")
    }
    
    public init(file: RemoteFile, code: HarmonyError.Code)
    {
        self.file = file
        self.code = code
        
        self.fileContext = file.managedObjectContext
    }
}

/* Batch Errors */

protocol BatchError: HarmonyError
{
    init(code: HarmonyError.Code)
}

public struct BatchFetchError: BatchError
{
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to fetch records.", comment: "")
    }
    
    init(code: HarmonyError.Code)
    {
        self.code = code
    }
}

public struct BatchUploadError: BatchError
{
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to upload records.", comment: "")
    }
    
    init(code: HarmonyError.Code)
    {
        self.code = code
    }
}

public struct BatchDownloadError: BatchError
{
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to download records.", comment: "")
    }
    
    init(code: HarmonyError.Code)
    {
        self.code = code
    }
}

public struct BatchDeleteError: BatchError
{
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to delete records.", comment: "")
    }
    
    init(code: HarmonyError.Code)
    {
        self.code = code
    }
}

public struct BatchConflictError: BatchError
{
    public var code: HarmonyError.Code
    
    public var failureDescription: String {
        return NSLocalizedString("Failed to mark records as conflicted.", comment: "")
    }
    
    init(code: HarmonyError.Code)
    {
        self.code = code
    }
}

