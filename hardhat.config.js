require('dotenv').config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('hardhat-deploy');
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
	const accounts = await hre.ethers.getSigners();

	for (const account of accounts) {
		console.log("accounts",account.address);
	}
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
	networks: {
		localhost: {
			url: "http://127.0.0.1:8545"
		},
		ganache :{
			url: "http://127.0.0.1:7545",
			accounts: [process.env.PRIVKEY]
		},
		axis :{
			url: "/",
			accounts: [process.env.PRIVKEY]
		},
		icicbtest :{
			url: "/",
			accounts: [process.env.PRIVKEY]
		}
	},
	etherscan: {
		// Your API key for Etherscan
		// Obtain one at https://etherscan.io/
		apiKey: ""
	},
	solidity: {
		compilers: [
			{
				version: '0.5.16',
				settings: {
					optimizer: {
						enabled: true,
						runs: 1000,
					},
				}
			},
		]
	},
	mocha: {
		timeout: 200000
	}
};
