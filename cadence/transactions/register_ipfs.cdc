import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import IPFSMetadataRegistry from "../contracts/IPFSMetadataRegistry.cdc"
import MetadataViews from "../contracts/MetadataViews.cdc"

transaction(
    cid: String,
    path: String?,
    name: String,
    description: String,
    image_cid: String,
    image_path: String?,
    image_data: String?,
    animation_cid: String?,
    animation_path: String?,
    external_url: String?,
  ) {
    let registor: &IPFSMetadataRegistry.Registor

    prepare(signer: AuthAccount) {
        self.registor = signer.borrow<&IPFSMetadataRegistry.Registor>(from: IPFSMetadataRegistry.RegistorStoragePath)
            ?? panic("Could not borrow a reference to the IPFS registor")
    }

    execute {
      let ipfs = IPFSMetadataRegistry.IPFSMetadata(
        file: MetadataViews.IPFSFile(cid: cid, path: path),
        metadata: IPFSMetadataRegistry.StandardMetadata(
          name: name,
          description: description,
          image: IPFSMetadataRegistry.TypedIPFSFile(
            type: "image",
            file: MetadataViews.IPFSFile(
              cid: image_cid,
              path: image_path
            )
          ),
          image_data: image_data,
          animation: animation_cid
            ? MetadataViews.IPFSFile(
              cid: animation_cid,
              path: animation_path
            )
            : nil,
          external_url: external_url,
          // ignore attributes for now
        )
      )
      self.registor.registerMetadata(ipfs: ipfs)
    }
}