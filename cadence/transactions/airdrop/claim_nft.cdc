import FlowChinaBadge from "../../contracts/FlowChinaBadge.cdc"
import NFTAirDrop from "../../contracts/NFTAirDrop.cdc"
import FlowToken from "../../contracts/FlowToken.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"

transaction(dropAddress: Address, id: UInt64, signature: String) {

    let receiver: &{NonFungibleToken.CollectionPublic}
    let drop: &{NFTAirDrop.DropPublic}

    prepare(signer: AuthAccount) {
        if signer.borrow<&FlowChinaBadge.Collection>(from: FlowChinaBadge.CollectionStoragePath) == nil {
            // create a new empty collection
            let collection <- FlowChinaBadge.createEmptyCollection()
            
            // save it to the account
            signer.save(<-collection, to: FlowChinaBadge.CollectionStoragePath)

            // create a public capability for the collection
            signer.link<&FlowChinaBadge.Collection{NonFungibleToken.CollectionPublic, FlowChinaBadge.FlowChinaBadgeCollectionPublic}>(
                FlowChinaBadge.CollectionPublicPath, 
                target: FlowChinaBadge.CollectionStoragePath
            )
        }
           
        self.receiver = signer
            .getCapability(FlowChinaBadge.CollectionPublicPath)!
            .borrow<&{NonFungibleToken.CollectionPublic}>()!

        self.drop = getAccount(dropAddress)
            .getCapability(NFTAirDrop.DropPublicPath)!
            .borrow<&{NFTAirDrop.DropPublic}>()!
    }

    execute {
        self.drop.claim(
            id: id, 
            signature: signature.decodeHex(), 
            receiver: self.receiver,
        )
    }
}
