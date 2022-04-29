module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
    // to customize your Truffle configuration!
  networks: {
      development: {
        host: "127.0.0.1",
        port: 8545,
        network_id: "*"
      }
  },
  db: {enabled: true},
  compilers: {
    solc: {
      version: "0.6.12"
    }
  }
};
