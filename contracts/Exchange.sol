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
        // just addign one side at the moment?
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
}
