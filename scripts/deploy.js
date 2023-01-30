const hre = require("hardhat");

require('dotenv').config()

async function main() {
  const WETH = await hre.ethers.getContractFactory("WETH");
  const wethContract = await WETH.deploy();

  await wethContract.deployed();

  const wethAddress = wethContract.address;
  console.log(
    `WETH token is deployed to ${wethAddress}`
  );

  const BiggestWethDick = await hre.ethers.getContractFactory("BiggestWethDick");
  const biggestWethDickContract = await BiggestWethDick.deploy(wethAddress);

  await biggestWethDickContract.deployed();

  console.log(
    `BiggestWethDick game is deployed to ${biggestWethDickContract.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
