require("@nomiclabs/hardhat-waffle");
const { utils } = require("ethers");

// The next line is part of the sample project, you don't need it in your
// project. It imports a Hardhat task definition, that can be used for
// testing the frontend.
require("./tasks/faucet");

module.exports = {
  networks: {
    hardhat: {
      accounts: {
        accountsBalance: utils.parseEther("1000000").toString(),
      },
      gasPrice: 1000,
    },
  },
  solidity: "0.8.3"
};
