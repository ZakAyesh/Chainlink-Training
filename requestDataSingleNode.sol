pragma solidity ^0.6.0;

import "github.com/smartcontractkit/chainlink/evm-contracts/src/v0.6/ChainlinkClient.sol";

contract ChainlinkExample is ChainlinkClient {
    uint256 public currentPrice;
    address public owner;
    address public ORACLE_ADDRESS = 0xB36d3709e22F7c708348E225b20b13eA546E6D9c;
    bytes32 constant JOBID = "628eded7db7f4f799dbf69538dec7ff2";
    uint256 constant private ORACLE_PAYMENT = 100000000000000000;
    
    constructor() public {
        setPublicChainlinkToken();
        owner = msg.sender;
    }
    
    function requestEthereumPrice() public onlyOwner {
        Chainlink.Request memory req = buildChainlinkRequest(JOBID, address(this), this.fulfill.selector);
        req.add("get", "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD");
        req.add("path", "USD");
        req.addInt("times", 100);
        sendChainlinkRequestTo(ORACLE_ADDRESS, req, ORACLE_PAYMENT);
    }
    
    function fulfill(bytes32 _requestId, uint256 _price) public 
    recordChainlinkFulfillment(_requestId) {
        currentPrice = _price;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}