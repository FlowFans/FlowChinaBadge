const emulatorConfig = {
  flowAccessAPI: "http://localhost:8080",
  fclWalletDiscovery: "http://localhost:8701/fcl/authn",
  nonFungibleTokenAddress: "0xf8d6e0586b0a20c7",
  fungibleTokenAddress: "0xee82856bf20e2aa6",
  flowTokenAddress: "0x0ae53cb6e3f42a79",
  projectContractAddress: "0xf8d6e0586b0a20c7",
  projectAdminAddress: "0xf8d6e0586b0a20c7"
};

const testnetConfig = {
  flowAccessAPI: "https://access-testnet.onflow.org",
  fclWalletDiscovery: "https://fcl-discovery.onflow.org/testnet/authn",
  nonFungibleTokenAddress: "0x631e88ae7f1d7c20",
  fungibleTokenAddress: "0x9a0766d93b6608b7",
  flowTokenAddress: "0x7e60df042a9c0868",
  projectContractAddress: process.env.FLOW_TESTNET_ADDRESS,
  projectAdminAddress: process.env.FLOW_TESTNET_ADDRESS
};

const mainnetConfig = {
  flowAccessAPI: "https://access-mainnet-beta.onflow.org",
  fclWalletDiscovery: "https://fcl-discovery.onflow.org/authn",
  nonFungibleTokenAddress: "0x1d7e57aa55817448",
  fungibleTokenAddress: "0xf233dcee88fe0abe",
  flowTokenAddress: "0x1654653399040a61",
  projectContractAddress: process.env.FLOW_MAINNET_ADDRESS,
  projectAdminAddress: process.env.FLOW_MAINNET_ADDRESS
};

function getConfig(network) {
  switch (network) {
    case "testnet":
      return testnetConfig;
    case "mainnet":
      return mainnetConfig;
    default:
      return emulatorConfig;
  }
}

module.exports = {
  webpack: (config, _options) => {
    config.module.rules.push({
      test: /\.cdc/,
      type: "asset/source"
    });
    return config;
  },
  publicRuntimeConfig: {
    appName: "FlowFans Badge",
    pinningServiceKey: process.env.PINNING_SERVICE_KEY,
    ...getConfig(process.env.NETWORK)
  }
};
