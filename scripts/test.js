require('dotenv').config();
require("colors")

const { ethers } = require("hardhat");
const SFCAbi = require("../artifacts/contracts/sfc/SFC.sol/SFC.json").abi;

async function main() {
	var [deployer] = await ethers.getSigners();
	const sFC = new ethers.Contract("0xeAb1000000000000000000000000000000000000",SFCAbi,deployer);
	for (let i = 1; i <= 8; i++) {
		const v1 = await sFC.getValidator(i)
		console.log('#' + i, v1.auth)
	}
	
}

main().then(() => console.log("complete".green)).catch((error) => {console.error(error);process.exit(1);});
