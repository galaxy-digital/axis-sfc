require('dotenv').config()
/* 
const fs = require("fs")
const colors = require("colors") 
*/
const { ethers } = require("hardhat")
const StakerInfoAbi = require("../artifacts/contracts/sfc/StakerInfo.sol/StakerInfo.json").abi
const contracts = require('../contracts')

const main = async() => {
    /* const [owner] = await ethers.getSigners() */
	/* console.log('provider', network.provider) */
	const provider = new ethers.providers.Web3Provider(network.provider)
	for (let i=1; i<=8; i++) {
		const privKey = process.env['KEY' + i]
		const wallet  = new ethers.Wallet(privKey, provider)
		console.log('wallet #' + i, wallet.address)
		const stakerInfo = new ethers.Contract(contracts.StakerInfo,StakerInfoAbi, wallet)
		var tx = await stakerInfo.updateInfo(process.env.STAKERINFO_URL)
		await tx.wait()
		var info = await stakerInfo.getInfo(i)
		console.log("validator #" + i, info)
	}
}

main().then(() => console.log("complete".green)).catch((error) => {console.error(error);process.exit(1)})
