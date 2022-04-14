require('dotenv').config();
require("colors")

async function main() {
	var [deployer] = await ethers.getSigners();

	console.log("deployer", deployer.address);

	let sAXIS;
	let stakeTokenizer;
	let stakerInfo;

	const SAXIS = await ethers.getContractFactory("SAXIS");
	sAXIS = await SAXIS.deploy();
	await sAXIS.deployed();

	const StakeTokenizer = await ethers.getContractFactory("StakeTokenizer");
	stakeTokenizer = await StakeTokenizer.deploy(sAXIS.address);
	await stakeTokenizer.deployed();

	let tx = await sAXIS.addMinter(stakeTokenizer.address);
	await tx.wait();
	const StakerInfo = await ethers.getContractFactory("StakerInfo");
	stakerInfo = await StakerInfo.deploy(false);
	await stakerInfo.deployed();
	console.log("SAXIS : ", sAXIS.address);
	console.log("StakeTokenizer : ", stakeTokenizer.address);
	console.log("StakerInfo : ", stakerInfo.address);
}

main().then(() => console.log("complete".green)).catch((error) => {console.error(error);process.exit(1);});
