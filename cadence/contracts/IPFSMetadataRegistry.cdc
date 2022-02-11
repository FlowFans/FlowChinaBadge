import MetadataViews from "./MetadataViews.cdc"

pub contract IPFSMetadataRegistry {
    // Events
    //
    pub event ContractInitialized()

    // Named Paths
    //
    pub let RegistorStoragePath: StoragePath

    // metadata
    // 
    access(contract) var registeredIpfsMetadata: {String: StandardMetadata}
    // mapped registors
    //
    access(contract) var mappedRegistors: {String: Capability<&{Registor}>}

    // Type Definitions
    // 
    pub struct TypedIPFSFile {
      // mediaType: MIME type of the media
      // - image/png
      // - image/jpeg
      // - video/mp4
      // - audio/mpeg
      pub let type: String

      // IPFS File object
      pub let file: MetadataViews.IPFSFile

      init(type: String, file: MetadataViews.IPFSFile) {
        self.type = type
        self.file = file
      }
    }

    pub struct interface Attribute {
      pub let trait_type: String
    }

    pub struct StringAttribute: Attribute {
      pub let trait_type: String
      pub let value: String

      init(type: String, value: String) {
        self.trait_type = type
        self.value = value
      }
    }

    pub struct NumericFix64Attribute: Attribute {
      pub let trait_type: String
      pub let value: Fix64

      init(type: String, value: Fix64) {
        self.trait_type = type
        self.value = value
      }
    }

    pub struct NumericInt64Attribute: Attribute {
      pub let trait_type: String
      pub let value: Int64

      init(type: String, value: Int64) {
        self.trait_type = type
        self.value = value
      }
    }

    pub struct NumericUInt64Attribute: Attribute {
      pub let trait_type: String
      pub let value: UInt64

      init(type: String, value: UInt64) {
        self.trait_type = type
        self.value = value
      }
    }


    pub struct StandardMetadata {
      // Name of the item.
      pub let name: String
      // A human readable description of the item. Markdown is supported.
      pub let description: String
      // This is the URL that will appear below the asset's image
      pub let external_url: String?
      // This is the URL to the image of the item.
      pub let image: TypedIPFSFile
      // Raw SVG image data
      pub let image_data: String?
      // A URL to a multi-media attachment for the item.
      // The file extensions GLTF, GLB, WEBM, MP4, M4V, OGV, and OGG are supported, along with the audio-only extensions MP3, WAV, and OGA.
      pub let animation: TypedIPFSFile?
      // These are the attributes for the item
      pub let attributes: [AnyStruct{Attribute}]

      init(
        name: String,
        description: String,
        image: TypedIPFSFile,
        image_data: String?,
        animation: TypedIPFSFile?,
        external_url: String?,
        attributes: [AnyStruct{Attribute}]?
      ) {
        self.name = name
        self.description = description
        self.image = image
        self.image_data = image_data
        self.animation = animation
        self.external_url = external_url
        self.attributes = attributes ?? []
      }
    }

    pub resource interface Registor {}




    init() {
      // Set named paths
      self.RegistorStoragePath = /storage/IPFSMetadataRegistor

      // contract data
      self.mappedRegistors = {}
      self.registeredIpfsMetadata = {}

      emit ContractInitialized()
    }
}