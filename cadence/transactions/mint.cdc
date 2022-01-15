import NonFungibleToken from "../contracts/NonFungibleToken.cdc"
import FlowChinaBadge from "../contracts/FlowChinaBadge.cdc"

transaction(metadata: String) {
    
    let admin: &FlowChinaBadge.Admin
    let receiver: &{NonFungibleToken.CollectionPublic}

    prepare(signer: AuthAccount) {
        self.admin = signer.borrow<&FlowChinaBadge.Admin>(from: FlowChinaBadge.AdminStoragePath)
            ?? panic("Could not borrow a reference to the NFT admin")
        
        self.receiver = signer
            .getCapability(FlowChinaBadge.CollectionPublicPath)!
            .borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Could not get receiver reference to the NFT Collection")
    }

    execute {
        let token <- self.admin.mintNFT(metadata: metadata)
        
        self.receiver.deposit(token: <- token)
    }
}
