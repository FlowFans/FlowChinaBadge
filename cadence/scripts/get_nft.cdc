import FlowChinaBadge from "../contracts/FlowChinaBadge.cdc"
import NonFungibleToken from "../contracts/NonFungibleToken.cdc"

pub struct AccountItem {
    pub let tokenId: UInt64
    pub let metadata: String
    pub let owner: Address

    init(tokenId: UInt64, metadata: String, owner: Address) {
        self.tokenId = tokenId
        self.metadata = metadata
        self.owner = owner
    }
}

pub fun main(address: Address, id: UInt64): AccountItem? {
    if let col = getAccount(address).getCapability<&FlowChinaBadge.Collection{NonFungibleToken.CollectionPublic, FlowChinaBadge.FlowChinaBadgeCollectionPublic}>(FlowChinaBadge.CollectionPublicPath).borrow() {
        if let item = col.borrowFlowChinaBadge(id: id) {
            return AccountItem(tokenId: id, metadata: item.metadata, owner: address)
        }
    }

    return nil
}
