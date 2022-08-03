const { getNamedAccounts, network, deployments, ethers } = require("hardhat");
const { assert, expect } = require("chai")
const BigNumber = require('big-number');
const { takeSnapshot, revertToSnapshot } = require("../utils/snapshot");
const { executeActionFromMSW } = require("../utils/multiSigAction");

const {openAndMintFromCDP} = require("../utils/positionActions");

describe("Liquidations", function () {
  this.timeout(80000);
  let senderAcc;
  let multiSigWallet;
  let CDPManagerContractObj, noiContractObj, LiquidatorContractObj, ParametersContractObj, TreasuryContractObj;
  let owner;
  let deployer;
  const wei = new BigNumber(10).pow(18);

  beforeEach(async () => {
    snapshot = await takeSnapshot();
  });

  afterEach(async () => {
      await revertToSnapshot(snapshot);
  });

  before(async () => {
    deployer = (await getNamedAccounts()).deployer;


    // getContract gets the most recent deployment for the specified contract
    noiContractObj = await ethers.getContract("NOI", deployer);
    CDPManagerContractObj = await ethers.getContract("CDPManager", deployer);
    LiquidatorContractObj = await ethers.getContract("Liquidator", deployer);
    ParametersContractObj = await ethers.getContract("Parameters", deployer);
    TreasuryContractObj = await ethers.getContract("Treasury", deployer);
    multiSigWallet = await ethers.getContract("MultiSigWallet", deployer);

    senderAcc = await hre.ethers.getSigners();
    owner = senderAcc[0];

  });


  it("... should liquidate CDP", async () => {

    let cdpIndex = await openAndMintFromCDP(CDPManagerContractObj, senderAcc[1],"13",10000);

    // should be set by the multi sig
    await executeActionFromMSW(
        multiSigWallet,
        0,
        ParametersContractObj.address,
        "setLR",
        ["uint8"],
        [150]
    );

    await openAndMintFromCDP(CDPManagerContractObj, senderAcc[2],"20",10001);

    const approveCDPManager = await noiContractObj.connect(senderAcc[2]).approve(CDPManagerContractObj.address, BigNumber(10).pow(18).mult(10001).toString());
    await approveCDPManager.wait();

    const liquidateCDP = await LiquidatorContractObj.connect(senderAcc[2]).liquidateCDP(cdpIndex);
    await liquidateCDP.wait();
  });

  it("... should fail Liquidation", async () => {

    const txOpenCDP = await CDPManagerContractObj.connect(senderAcc[1]).openCDP(senderAcc[1].address, {value: ethers.utils.parseEther("13")});
    await txOpenCDP.wait();
    const getCDPIndex = await CDPManagerContractObj.connect(senderAcc[1]).cdpi();
    const cdpIndex = getCDPIndex.toString();

    const txmintFromCDPManager = await CDPManagerContractObj.connect(senderAcc[1]).mintFromCDP(cdpIndex, BigNumber(10).pow(18).mult(1000).toString());
    await txmintFromCDPManager.wait();

    LiquidatorContract = await ethers.getContractFactory("Liquidator");
    try {
      await LiquidatorContractObj.connect(owner).liquidateCDP(cdpIndex);
    } catch (err) {
        //console.log("CATCH ERR", err.toString())
        expect(err.toString()).to.have.string('Liquidator__CDPNotEligibleForLiquidation');
      }
  });
});
