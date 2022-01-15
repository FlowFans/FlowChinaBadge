import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import FlowChinaBadge from "../contracts/FlowChinaBadge.cdc"

// This transaction configures an account to hold Kitty Items.

transaction {
    prepare(signer: AuthAccount) {
        // if the account doesn't already have a collection
        if signer.borrow<&FlowChinaBadge.Collection>(from: FlowChinaBadge.CollectionStoragePath) == nil {

            // create a new empty collection
            let collection <- FlowChinaBadge.createEmptyCollection()
            
            // save it to the account
            signer.save(<-collection, to: FlowChinaBadge.CollectionStoragePath)

            // create a public capability for the collection
            signer.link<&FlowChinaBadge.Collection{NonFungibleToken.CollectionPublic, FlowChinaBadge.FlowChinaBadgeCollectionPublic}>(FlowChinaBadge.CollectionPublicPath, target: FlowChinaBadge.CollectionStoragePath)
        }
    }
}
