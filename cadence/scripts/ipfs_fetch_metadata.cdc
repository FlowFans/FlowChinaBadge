import IPFSMetadataRegistry from "../contracts/IPFSMetadataRegistry.cdc"
import MetadataViews from "../contracts/MetadataViews.cdc"

pub fun main(cid: String, path: String?): IPFSMetadataRegistry.IPFSMetadata? {
  let file = MetadataViews.IPFSFile(cid: cid, path: path)
  let uri = file.uri()

  return IPFSMetadataRegistry.fetchMetadata(uri)
}
