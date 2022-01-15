import FlowChinaBadge from "../../contracts/FlowChinaBadge.cdc"
import NFTQueueDrop from "../../contracts/NFTQueueDrop.cdc"
import FlowToken from "../../contracts/FlowToken.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"

transaction(dropAddress: Address) {

    let payment: @FungibleToken.Vault
    let receiver: &{NonFungibleToken.CollectionPublic}
    let drop: &{NFTQueueDrop.DropPublic}

    prepare(signer: AuthAccount) {
        if signer.borrow<&FlowChinaBadge.Collection>(from: FlowChinaBadge.CollectionStoragePath) == nil {
            // create a new empty collection
            let collection <- FlowChinaBadge.createEmptyCollection()
            
            // save it to the account
            signer.save(<-collection, to: FlowChinaBadge.CollectionStoragePath)

            // create a public capability for the collection
            signer.link<&FlowChinaBadge.Collection{NonFungibleToken.CollectionPublic, FlowChinaBadge.FlowChinaBadgeCollectionPublic}>(FlowChinaBadge.CollectionPublicPath, target: FlowChinaBadge.CollectionStoragePath)
        }

        self.receiver = signer
            .getCapability(FlowChinaBadge.CollectionPublicPath)!
            .borrow<&{NonFungibleToken.CollectionPublic}>()!

        self.drop = getAccount(dropAddress)
            .getCapability(NFTQueueDrop.DropPublicPath)!
            .borrow<&{NFTQueueDrop.DropPublic}>()!

        let vault = signer
            .borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
            ?? panic("Cannot borrow FLOW vault from account storage")

        let price = self.drop.price
   
        self.payment <- vault.withdraw(amount: price)
    }

    execute {
        let token <- self.drop.claim(payment: <- self.payment)
        self.receiver.deposit(token: <- token)
    }
}
