import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import IPFSMetadataRegistry from "../contracts/IPFSMetadataRegistry.cdc"

transaction() {
    prepare(signer: AuthAccount) {
        // if the account doesn't already have a collection
        if signer.borrow<&IPFSMetadataRegistry.Registor>(from: IPFSMetadataRegistry.RegistorStoragePath) == nil {

            // create a new registor
            let registor <- IPFSMetadataRegistry.createNewRegistor()
            
            // save it to the account
            signer.save(<-registor, to: IPFSMetadataRegistry.RegistorStoragePath)
        }
    }
}
