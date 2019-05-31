pragma solidity >=0.4.24;

/**
* @dev 부모 컨트랙트		
1. 크리에이터 설정이 가능하다. onlyAdmin 리스트로 관리		
2. 크리에이터는 작품 컨트랙트를 만들 수 있다. onlyCreater 매핑 정보로
2-1. 코인 디플로이어 처럼 만들자. 발행자는 크리에이터가 된다.
2-2. 팩토리(상품팩토리, 프록시, 싱품)구조로 만들자.
3. 크리에이터 판별 여부 함수를 보유한다. public		
4. (투자자 / 구매자) 상태 내역 저장할 것인가?		
 */
// @import HasNoKlay.sol;


contract InterfaceSigStockRegistry {
    
    event AddedCreator(address indexed newCreator);
    event DeletedCreator(address indexed toDeleteCreator);
    event AddedAdmin(address indexed newAdmin);
    event DeletedAdmin(address indexed toDeleteAdmin);
    event ChangedSigStockOwner(address indexed _newOwner);
    address public SIGSTOCK_OWNER;
    uint8 constant MAX_ADMIN = 10;
    address[MAX_ADMIN] public adminGroup;

    mapping (address => bool) public SIGSTOCK_ADMINS; 
    mapping (address => bool) public isCreator;
    // mapping (address => bool) public isSigProduct;

    constructor () public {
        SIGSTOCK_OWNER = msg.sender;
    }

    modifier onlySigStockAdmin() {
        require(SIGSTOCK_ADMINS[msg.sender] == true, "is not Admin");
        _;
    }

    modifier onlySigStockOwner() {
        require(SIGSTOCK_OWNER == msg.sender, "is not owner");
        _;
    }

    function changeSigStockOwnership(address _sigStockOwner) public returns (bool);
    function addCreator(address _toAddCreator) public returns (bool);
    function deleteCreator(address _toDeleteCreator) public returns (bool);
    function addSigStockAdmin(address _admin, uint8 _num) public returns (bool);
    function deleteSigStockAdmin(address _admin, uint8 _num) public returns (bool);
}

contract SightStockOwnable {
    address public owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    function transferOwnership(address _newOwner) public onlyOwner {
        _transferOwnership(_newOwner);
    }

    function _transferOwnership(address _newOwner) internal {
        require(_newOwner != address(0));
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}

/**
* @dev 기초 작품 인터페이스
* 1. 
* 2.
* 3. 
* 4. 
 */


contract InterfaceProduct is SightStockOwnable {

    /**
     * @param content_key : 오프체인 해시 값
     * @param mainTitle : 대 제목
     * @param subTitle : 소 제목
     * @param description : 내용
     * @param createdTime : 만들어진 시간
     * @param recital : 비고
     */
    struct ContentData {
        bytes contentKey; 
        string mainTitle;
        string subTitle;
        string description;
        string recital;
        uint256 createdTime;
    }
    
    mapping(uint8 => ContentData) public productItems;
    
    mapping(uint8 => address) public module;
    
    //기초 정보
    uint256 public maxDivideValue;
    uint256 public creatorRate;
    uint8 public contentCount;
    string public productTitle;
    string public productDescription;

    //모듈 정보
    uint8 public constant INVEST_KEY = 1;
    uint8 public constant PURCHASE_KEY = 2;
    uint8 public constant DIVIDE_KEY = 3;
    // uint256 public investorCount;
    // uint256 public purchaserCount;

    // address[] public investors;
    // address[] public purchasers;

    
    function getModule(uint8 _moduleType, uint8 _moduleIndex) public view returns (bytes32, address);
    
    // function getInvestorsLength() public view returns(uint256);

    // function getPurchasersLength() public view returns(uint256);
    
    // function addMultiContents() public returns(bool);
    
    // function addContent() public returns(bool)
}

/**
* @dev 기초 모듈 인터페이스
*
* 1. getName, getType을 갖는다.
* 2. 작품의 컨트랙트, 전체 레지스트리 컨트랙트 정보를 갖는다.
* 3. 특정 제어자를 갖는다.
 */

contract InterfaceModule {
    //작품 컨트랙트
    address public sigStockProduct;
    address public sigStockRegistry;
    
    uint8 public constant INVEST_KEY = 1;
    uint8 public constant PURCHASE_KEY = 2;
    uint8 public constant DIVIDE_KEY = 3;

    constructor (address _product, address _registry) public {
        sigStockProduct = _product;
        sigStockRegistry = _registry;
    }
    
    // 레지스트리의 관리자 확인 제어자
    modifier onlyRegistryAdmin {
        require(true == InterfaceSigStockRegistry(sigStockRegistry).SIGSTOCK_ADMINS(msg.sender), "msg.sender is not admin");
        _;
    }

    // 프로덕트의 상품 창작자 제어자
    modifier onlyProductOwner() {

        require(msg.sender == InterfaceProduct(sigStockProduct).owner(), "msg.sender is not owner");
        _;
    }
    // 프로덕트 컨트랙트 제어자
    modifier onlyProduct() {
        require(msg.sender == sigStockProduct, "is not product");
        _;
    }
    // 프로덕트 투자자 제어자 (will go to InvestModule)

    // 프로덕트 구매자 제어자 (will go to PurchaseModule)

    function getSig(bytes _data) internal pure returns (bytes4 sig) {
        uint len = _data.length < 4 ? _data.length : 4;
        
        for (uint i = 0; i < len; i++) {
            sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
        }
    }

    function getType() public view returns(uint8);
    
    function getName() public view returns(bytes32);

}

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

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

/**
* @dev 기초 투자 인터페이스 ( 투자자를 위한 )
*
* 
* 
* 
 */

contract InterfaceInvestModule is InterfaceModule {
    
    event ProductInvest(address indexed investor, address indexed beneficiary, uint256 value, uint256 amount);
    event DeliveredStock(uint256 tokenId, address indexed beneficiary, uint256 amount);
    event LogGranularityChanged(uint256 _oldGranularity, uint256 _newGranularity);
    event RegisterdBasicInvestConfig(address _from, uint256 _cap, uint256 _maxInvestors, uint256 _startTime, uint256 _endTime);
    
    struct InvestData {
        uint256 tokenId;
        address owner;
        uint256 amount;
        uint256 timeStamp;
    }
    uint public granularity;
    uint public constant rate = 1;
    uint256 public investorCount;
    uint256 public productSold;
    uint256 public fundsRaised;
    
    //configure 설정 값
    uint public startTime;
    uint public endTime;
    uint256 public cap;
    uint256 public max_investors;

    mapping (address => uint256) public investors;
    mapping (uint256 => InvestData) public investList;

    function getNumberInvestors() public view returns (uint256);
    
    function getRaisedKlay() public view returns (uint256);

    function configure(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _cap,
        uint256 _max_investors,
        address _fundsReceiver,
        address _from
    )
    public
    returns (bool);

    function reclaimERC20(address _tokenContract) external onlyRegistryAdmin {
        
        require(_tokenContract != address(0),"is address(0)");
        
        ERC20Basic token = ERC20Basic(_tokenContract);
        uint256 balance = token.balanceOf(address(this));
        
        require(token.transfer(msg.sender, balance), "fn:reclaimERC20 transfer error");
    }

}

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract BasicDivideModule is InterfaceDivideModule {
    using SafeMath for uint256;
    uint256 public creatorRate = 0;
    uint256 public maxDivideValue = 0;
    constructor (address _product, address _registry) public
    InterfaceModule(_product, _registry)
    {
      creatorRate = InterfaceProduct(sigStockProduct).creatorRate();
      maxDivideValue = InterfaceProduct(sigStockProduct).maxDivideValue();
    }
    
    modifier isClearedMission {
        require(isCleared == true, "is not cleared");
        _;
    }
    function clearedMission() external onlyRegistryAdmin returns(bool) {
        
        isCleared = true;

        emit IsCleared(msg.sender, block.timestamp);

        return true;
    }
    
    function invest(address _from) public payable returns(bool) {
        
        invested[Wallet] += msg.value;

        Wallet.transfer(msg.value);

        emit Invested(_from, msg.value, block.timestamp);

        return true;
    }

    function invest2(address _from, uint256 _value) public payable returns(bool) {
        
        invested[Wallet] += _value;
        
        Wallet.transfer(msg.value);
        
        emit Invested(_from, _value, block.timestamp);

        return true;
    }
    
    function purchase(address _from) public payable returns (bool) {
        
        purchased[Wallet] += msg.value;

        emit Purchased(_from, msg.value, block.timestamp);

        return true;
    }
    
    function withdrawInvestedKLAYFromCreator() public onlyProductOwner isClearedMission payable returns (bool) {
        
        uint256 allOfKlay = invested[Wallet];
        
        invested[Wallet] = 0;
        
        msg.sender.transfer(allOfKlay);
        
        emit WithdrawedInvestedKLAYFromCreator(msg.sender, allOfKlay);
        
        return true;
    }
    
    // 1 klay / 10 klay / 50 klay units
    function withdrawPurchasedKLAYFromCreator() public payable returns (bool) {
        require(purchasedForInvestor[Wallet] == 0, "is not completed investor's step");
        require(creatorRate > 0,"is not initialized");
        require(purchased[Wallet] >= maxDivideValue, "has not sufficient klay");
        //creatorRate는 현재 2 KLAY에 해당한다. 100 * 2 / 10
        uint256 rate = (creatorRate / 10 ether); //klay
        uint klayValue = maxDivideValue * rate;
        
        purchased[Wallet] -= klayValue;
        purchasedForInvestor[Wallet] += purchased[Wallet];
        purchased[Wallet] = 0;

        msg.sender.transfer(klayValue);
        
        emit WithdrawedPurchasedKLAYFromCreator(msg.sender, klayValue);
        return true;
    }
    
    function withdrawPurchasedKLAYFromInvestor() public payable returns(bool) {
        require(creatorRate > 0,"is not initialized");
        require(purchased[Wallet] == 0, "is not completed creator's step");
        
        uint256 rate;
        //1. 캡 가져와야 한다.
        //2. 투자자 투자한 금액 가져와야한다.
        //3. 투자금액 / 캡 ==> 소유권 비율이 된다.
        //4. 구매해서 벌어들인 금액을 소유권 비율대로 나눠분배한다.
        uint klay = 10 ether * rate.div(creatorRate);
        
        address investModule = InterfaceProduct(sigStockProduct).module(INVEST_KEY);
        //cap이 1000KLAY인 경우
        uint256 _cap = InterfaceInvestModule(investModule).cap();
        //투자금액이 50KLAY인 경우
        uint256 _InvestorValue = InterfaceInvestModule(investModule).investors(msg.sender);
        
        rate = _InvestorValue.div(_cap); // 5% 비율을 가지고 있다.
        
        uint256 getValue = purchasedForInvestor[Wallet] * rate;
        
        purchasedForInvestor[Wallet].sub(getValue);

        msg.sender.transfer(getValue);
        
        emit WithdrawedPurchasedKLAYFromInvestor(msg.sender, klay);
        
        return true;
        
    }
    
    function() external payable {
        
    }
    
    function getType() public view returns(uint8) {
        return 3;
    }
    
    function getName() public view returns(bytes32) {
        return "BasicDivideModule";
    }
}