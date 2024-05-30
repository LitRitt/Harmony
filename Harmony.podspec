Pod::Spec.new do |spec|
  spec.name         = "Harmony"
  spec.version      = "0.1"
  spec.summary      = "iOS Syncing Framework"
  spec.description  = "iOS framework that automatically syncs Core Data databases across different backends."
  spec.homepage     = "https://github.com/LitRitt/Harmony"
  spec.platform     = :ios, "14.0"
  spec.source       = { :git => "https://github.com/litritt/Harmony.git" }

  spec.author             = { "Chris Rittenhouse" => "dev@litritt.com" }
  spec.social_media_url   = "https://github.com/litritt
  "
  
  spec.source_files  = "Harmony/**/*.{h,m,swift}"
  spec.public_header_files = "Harmony/Harmony.h"
  spec.header_mappings_dir = ""
  spec.resources = "Harmony/**/*.xcdatamodeld", "Harmony/**/*.xcmappingmodel"
  
  spec.dependency 'Roxas'
  
  spec.subspec 'Harmony-Dropbox' do |dropbox|
    dropbox.source_files  = "Backends/Dropbox/Harmony-Dropbox/**/*.swift"
    dropbox.dependency 'SwiftyDropbox', '~> 6.0.0'
  end
  
  # spec.subspec 'Harmony-CloudKit' do |cloudkit|
  #   cloudkit.source_files  = "Backends/CloudKit/Harmony-CloudKit/**/*.swift"
  # end
  
end
