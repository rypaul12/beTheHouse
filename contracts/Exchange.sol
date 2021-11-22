// contracts/Exchange.sol
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Exchange {
    address public tokenAddress;
    uint256 public num;

    constructor(address _token){
        require(_token != address(0), "invalid token address");
        tokenAddress = _token;
    }

    function addLiquidity(uint256 _tokenAmount) public payable{
        // in function call, additionally add eth via msg.value
        IERC20 token = IERC20(tokenAddress);
        num = msg.value; 
        token.transferFrom(msg.sender, address(this), _tokenAmount);
    }

    function getReserve() public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function getNum() public view returns(uint256){
        return num;
    }

    function getAmount(
    uint256 inputAmount,
    uint256 inputReserve,
    uint256 outputReserve
    ) private pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, "invalid reserves");
        // x*y=k
        // let's say input Reserve of token is x, output Resereve is ETH y (selling input for eth)
        // x' = x + inputAmount
        // y' = y - outputAmount
        // x' * y' = x*y
        // we're searching for output amount
        // (x+inputAmount)(y-outputAmount)=x*y
        // x*y/(x+inputAmount) = y - outputAmount
        // outputAmount = y - (x*y)/(x+inputAmount) -> y*inputAmount/(x+inputAmount)
        return (inputAmount * outputReserve) / (inputReserve + inputAmount);
    }

    function getTokenAmount(uint256 _ethSold) public view returns (uint256) {
        require(_ethSold > 0, "ethSold is too small");
        uint256 tokenReserve = getReserve();
        return getAmount(_ethSold, address(this).balance, tokenReserve);
    }

    function getEthAmount(uint256 _tokenSold) public view returns (uint256) {
        require(_tokenSold > 0, "tokenSold is too small");
        uint256 tokenReserve = getReserve();
        return getAmount(_tokenSold, tokenReserve, address(this).balance);
    }

    function ethToTokenSwap(uint256 _minTokens) public payable {
        uint256 tokenReserve = getReserve();
        // subtract msg.value bc that's eth sent in and already in contract
        uint256 tokensBought = getAmount(
          msg.value,
          address(this).balance - msg.value,
          tokenReserve
        );
        require(tokensBought >= _minTokens, "insufficient output amount");
        IERC20(tokenAddress).transfer(msg.sender, tokensBought);
    }

    function tokenToEthSwap(uint256 _tokensSold, uint256 _minEth) public {      

        uint256 ethBought = getAmount(_tokensSold, getReserve(), address(this).balance);
        // swapping eth from contract to msg.sender + adding tokens sold to contract
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _tokensSold);
        // payable keyword to send eth
        payable(msg.sender).transfer(ethBought);
    }

}