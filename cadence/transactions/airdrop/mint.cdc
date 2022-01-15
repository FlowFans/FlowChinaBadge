import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import FlowChinaBadge from "../../contracts/FlowChinaBadge.cdc"
import NFTAirDrop from "../../contracts/NFTAirDrop.cdc"

transaction(metadata: String, publicKey: String) {
    
    let admin: &FlowChinaBadge.Admin
    let drop: &NFTAirDrop.Drop

    prepare(signer: AuthAccount) {
        self.admin = signer
            .borrow<&FlowChinaBadge.Admin>(from: FlowChinaBadge.AdminStoragePath)
            ?? panic("Could not borrow a reference to the NFT admin")
        
        if let existingDrop = signer.borrow<&NFTAirDrop.Drop>(from: NFTAirDrop.DropStoragePath) {
            self.drop = existingDrop
        } else {
            let collection = signer.getCapability<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(FlowChinaBadge.CollectionPrivatePath)

            let drop <- NFTAirDrop.createDrop(
                nftType: Type<@FlowChinaBadge.NFT>(),
                collection: collection
            )

            self.drop = &drop as &NFTAirDrop.Drop

            signer.save(<- drop, to: NFTAirDrop.DropStoragePath)

            signer.link<&NFTAirDrop.Drop{NFTAirDrop.DropPublic}>(
                NFTAirDrop.DropPublicPath, 
                target: NFTAirDrop.DropStoragePath
            )
        }
    }

    execute {
        let token <- self.admin.mintNFT(metadata: metadata)

        self.drop.deposit(token: <- token, publicKey: publicKey.decodeHex())
    }
}
