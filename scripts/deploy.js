require('dotenv').config();
require("colors")
/* const fs = require("fs"); */

/* ; */
/* const { ethers } = require("hardhat"); */
/* const SFCAbi = require("../artifacts/contracts/sfc/SFC.sol/SFC.json").abi; */
/* const StakerInfoAbi = require("../artifacts/contracts/sfc/StakerInfo.sol/StakerInfo.json").abi; */

async function main() {
	// get network
	var [deployer] = await ethers.getSigners();

	/* let network = await deployer.provider._networkPromise;
	let chainId = network.chainId; */

	console.log("deployer", deployer.address);

	let sICICB;
	let stakeTokenizer;
	let stakerInfo;

	/* ----------- sICICB -------------- */
	//deploy SICICB contract for test
	const SICICB = await ethers.getContractFactory("SICICB");
	sICICB = await SICICB.deploy();
	await sICICB.deployed();

	const StakeTokenizer = await ethers.getContractFactory("StakeTokenizer");
	stakeTokenizer = await StakeTokenizer.deploy(sICICB.address);
	await stakeTokenizer.deployed();

	let tx = await sICICB.addMinter(stakeTokenizer.address);
	await tx.wait();

	// stakerInfo
	const StakerInfo = await ethers.getContractFactory("StakerInfo");
	stakerInfo = await StakerInfo.deploy(true);
	await stakerInfo.deployed();

	//sfc
	// const sFC = new ethers.Contract("0x1c1cB00000000000000000000000000000000000",SFCAbi,sfcOwner);
	// tx = await sFC.updateStakeTokenizerAddress(stakeTokenizer.address);
	// await tx.wait();

	console.log("SICICB : ", sICICB.address);
	console.log("StakeTokenizer : ", stakeTokenizer.address);
	console.log("StakerInfo : ", stakerInfo.address);

	/* for (let i=0; i<8; i++) {
		console.log('wallet #' + (i + 1), addrs[i].address)
		try {
			tx = await stakerInfo.connect(addrs[i]).updateInfo(process.env.STAKERINFO_URL);
			await tx.wait();
			const info = await stakerInfo.getInfo(i);
			console.log("validator #" + (i + 1), info)	
		} catch (error) {
			console.error(error)
		}
		
	} */
}

main().then(() => console.log("complete".green)).catch((error) => {console.error(error);process.exit(1);});
