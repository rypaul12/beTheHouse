require("@nomiclabs/hardhat-waffle");
const { expect } = require("chai");

const toWei = (value) => ethers.utils.parseEther(value.toString());

const fromWei = (value) =>
  ethers.utils.formatEther(
    typeof value === "string" ? value : value.toString()
  );

const getBalance = ethers.provider.getBalance;

const createExchange = async (factory, tokenAddress, sender) => {
  const exchangeAddress = await factory
    .connect(sender)
    .callStatic.createExchange(tokenAddress);

  await factory.connect(sender).createExchange(tokenAddress);

  const Exchange = await ethers.getContractFactory("Exchange");

  return await Exchange.attach(exchangeAddress);
};

describe("Exchange", () => {
  let owner;
  let user;
  let exchange;
  let token;

  beforeEach(async () => {
    [owner, user] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("Token");
    token = await Token.deploy("Chainlink", "LINK", toWei(1000000));
    await token.deployed();

    console.log(token.address);

    const Exchange = await ethers.getContractFactory("Exchange");
    exchange = await Exchange.deploy(token.address);
    await exchange.deployed();
  });

  it("is deployed", async () => {
    // expect(await exchange.deployed()).to.equal(exchange);
    // expect(await exchange.name()).to.equal("Zuniswap-V1");
    // expect(await exchange.symbol()).to.equal("ZUNI-V1");
    // expect(await exchange.totalSupply()).to.equal(toWei(0));
    // expect(await exchange.factoryAddress()).to.equal(owner.address);
  });

  describe("addLiquidity", async () => {
    describe("empty reserves", async () => {
      it("adds liquidity", async () => {
        await token.approve(exchange.address, toWei(200));
        console.log("added liquidity");
        // value = msg.value = amount of eth sent in transaction. so sending 200 wei of link, 100 wei of eth
        await exchange.addLiquidity(toWei(200), { value: toWei(100) });
        expect(await getBalance(exchange.address)).to.equal(toWei(100));
        expect(await exchange.getReserve()).to.equal(toWei(200));
      });

    });
  });
});
