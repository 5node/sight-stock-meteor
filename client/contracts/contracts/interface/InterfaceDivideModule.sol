
pragma solidity >=0.4.24;

import "./InterfaceModule.sol";
import "../ERC20/ERC20Basic.sol";
contract InterfaceDivideModule is InterfaceModule {
    
    event Invested(address _from, uint256 _klayAmount, uint256 _timestamp);
    event Purchased(address _from, uint256 _klayAmount, uint256 _timestamp);
    event WithdrawedInvestedKLAYFromCreator(address _from, uint256 _klay);
    event WithdrawedPurchasedKLAYFromCreator(address _from, uint256 _klay);
    event WithdrawedPurchasedKLAYFromInvestor(address _from, uint256 _klay);
    event IsCleared(address _from, uint256 _timestamp);
    
    bool isCleared = false;
    //투자 모듈에서 투자하면 해당 wallet으로 받게 된다.
    address public Wallet = address(this);   
    mapping (address => uint256) public invested;
    mapping (address => uint256) public purchased;
    mapping (address => uint256) public purchasedForInvestor;
    
    function clearedMission() external returns(bool);

    function invest(address _from) public payable returns (bool); 

    function invest2(address _from, uint256 _value) public payable returns (bool); 

    function purchase(address _from) public payable returns(bool);
    
    //onlyCreator // onlyClearedMission 
    function withdrawInvestedKLAYFromCreator() public payable returns(bool);
    
    // 1 ether / 10 ether / 50 ether units
    function withdrawPurchasedKLAYFromCreator() public payable returns(bool);
    
    function withdrawPurchasedKLAYFromInvestor() public payable returns(bool);

    function reclaimERC20(address _tokenContract) external onlyRegistryAdmin {
        
        require(_tokenContract != address(0),"is address(0)");
        
        ERC20Basic token = ERC20Basic(_tokenContract);
        uint256 balance = token.balanceOf(address(this));
        
        require(token.transfer(msg.sender, balance), "fn:reclaimERC20 transfer error");
    }

}