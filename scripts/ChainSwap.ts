const { ethers } = require("hardhat");

const TOKENA_ADDRESS = "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d";
const TOKENB_ADDRESS = "0x0000000000000000000000000000000000000000";
const PRICE_FEED_ADDRESS = "0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419";
const AMOUNT = ethers.utils.parseEther("1");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying TokenSwap contract...");
  const TokenSwap = await ethers.getContractFactory("TokenSwap");
  const tokenSwap = await TokenSwap.deploy(TOKENA_ADDRESS, TOKENB_ADDRESS, PRICE_FEED_ADDRESS);
  await tokenSwap.deployed();

  console.log("TokenSwap contract deployed to:", tokenSwap.address);

  const token1 = await ethers.getContractAt("IERC20", TOKENA_ADDRESS);
  const token2 = await ethers.getContractAt("IERC20", TOKENB_ADDRESS);

  console.log(`Token1 balance before swap: ${await token1.balanceOf(deployer.address)}`);
  console.log(`Token2 balance before swap: ${await token2.balanceOf(deployer.address)}`);

  console.log("Swapping tokens...");
  await token1.approve(tokenSwap.address, AMOUNT);
  await tokenSwap.swapTokens(AMOUNT);

  console.log(`Token1 balance after swap: ${await token1.balanceOf(deployer.address)}`);
  console.log(`Token2 balance after swap: ${await token2.balanceOf(deployer.address)}`);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
