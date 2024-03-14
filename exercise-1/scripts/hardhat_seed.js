const hre = require("hardhat");
const { ethers } = require("hardhat");
// const { ethers, artifacts } from 'hardhat';

async function main() {
  await hre.run('compile');

  const VulnerableToken = await ethers.getContractFactory("VulnerableToken");
  const token = await VulnerableToken.deploy();

  await token.deployed();

  console.log("token deployed to:", token.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
