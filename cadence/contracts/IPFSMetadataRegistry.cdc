import MetadataViews from "./MetadataViews.cdc"

pub contract IPFSMetadataRegistry {
    // Events
    //
    pub event ContractInitialized()
    // Event that is emitted when metadata updated
    pub event MetadataUpdated(owner: Address, uri: String)

    // Named Paths
    //
    pub let RegistorStoragePath: StoragePath

    // metadata
    // 
    access(contract) var registeredIpfsMetadata: {String: IPFSMetadata}
    // mapped registors
    //
    access(contract) var mappedRegistorOwners: {String: Address}

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

    // IPFSMetadata contains a metadata json data
    // stored as an json file in IPFS.
    //
    pub struct IPFSMetadata {
        // IPFS File object
        pub let file: MetadataViews.IPFSFile

        // metadata is the detail content of the IPFS file
        pub let metadata: StandardMetadata?

        init(file: MetadataViews.IPFSFile, metadata: StandardMetadata?) {
            self.file = file
            self.metadata = metadata
        }
    }

    pub resource Registor {

      // registerMetadata
      // Register a new metadata
      //
      pub fun registerMetadata(ipfs: IPFSMetadata) {
        pre {
          self.owner != nil: "The owner of metadata registor should be not nil."
          ipfs.metadata != nil: "Register metadata should not be nil."
        }

        let ownerAddress = self.owner!.address // owner address
        let uri = ipfs.file.uri() // ipfs file uri

        if IPFSMetadataRegistry.registeredIpfsMetadata[uri] != nil {
          // if metadata is registered, must be the owner.
          assert(IPFSMetadataRegistry.mappedRegistorOwners.containsKey(uri), message: "The uri should be registered.")
          assert(IPFSMetadataRegistry.mappedRegistorOwners[uri]! == ownerAddress, message: "owner should be same")
        } else {
          // if metadata is empty, create new
          IPFSMetadataRegistry.mappedRegistorOwners[uri] = ownerAddress
        }

        // update metadata
        IPFSMetadataRegistry.registeredIpfsMetadata[uri] = ipfs

        // emit MetadataUpdated 
        emit MetadataUpdated(owner: ownerAddress, uri: uri)
      }
    }

    // fetchMetadata
    // Get metadata from the contract, if available.
    // If does not contain the uri, return nil.
    // If contains the uri, return the metadata struct.
    //
    pub fun fetchMetadata(_ uri: String): IPFSMetadata? {
      return IPFSMetadataRegistry.registeredIpfsMetadata[uri]
    }

    // createNewRegistor
    // public function that anyone can call to create a new registor
    //
    pub fun createNewRegistor(): @Registor {
        return <- create Registor()
    }

    init() {
      // Set named paths
      self.RegistorStoragePath = /storage/IPFSMetadataRegistor

      // contract data
      self.registeredIpfsMetadata = {}
      self.mappedRegistorOwners = {}

      emit ContractInitialized()
    }
}