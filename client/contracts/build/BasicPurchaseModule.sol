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

/**
* @dev 기초 구매 인터페이스 ( 추후 구매자를 위한 )
*
* 
* 
* 
 */


contract InterfacePurchaseModule is InterfaceModule {
    
    function configure(
        uint256 _startTime, 
        uint256 _endTime,  
        address _fundsReceiver,
        address _from
        )
    public returns (bool);

    function getNumberPurchasers() public view returns (uint256);
    
    function getRaisedKlay() public view returns (uint256);

    function reclaimERC20(address _tokenContract) external onlyRegistryAdmin {
        
        require(_tokenContract != address(0),"is address(0)");
        
        ERC20Basic token = ERC20Basic(_tokenContract);
        uint256 balance = token.balanceOf(address(this));
        
        require(token.transfer(msg.sender, balance), "fn:reclaimERC20 transfer error");
    }
    
    
}

/**
 * @title Helps contracts guard agains reentrancy attacks.
 * @author Remco Bloemen <remco@2π.com>
 * @notice If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {

  /**
   * @dev We use a single lock for the whole contract.
   */
  bool private reentrancyLock = false;

  /**
   * @dev Prevents a contract from calling itself, directly or indirectly.
   * @notice If you mark a function `nonReentrant`, you should also
   * mark it `external`. Calling one nonReentrant function from
   * another is not supported. Instead, you can implement a
   * `private` function doing the actual work, and a `external`
   * wrapper marked as `nonReentrant`.
   */
  modifier nonReentrant() {
    require(!reentrancyLock);
    reentrancyLock = true;
    _;
    reentrancyLock = false;
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

/**
* @dev 기본적인 구매 모듈  ( 추후 구매자를 위한 )
*
* 
* 
* 
 */
contract BasicPurchaseModule is InterfacePurchaseModule, ReentrancyGuard {
    using SafeMath for uint256;
    event RegisterdBasicPurchaseConfig(address _from, address _wallet, uint256 _startTime, uint256 _endTime);
    event ProductPurchase(address indexed sigStockProduct, address indexed beneficiary, uint256 amount);
    event LogGranularityChanged(uint256 _oldGranularity, uint256 _newGranularity);

    uint public granularity;
    uint256 public purchaserCount;
    uint256 public productSold;
    address public fundsWallet;
    uint256 public startTime;
    uint256 public endTime;

    function configure(
        uint256 _startTime,
        uint256 _endTime,
        address _fundsReceiver,
        address _from
    )
    public
    onlyProduct
    returns (bool)
    {
        require(_fundsReceiver != address(0), "Zero address is not permitted");
        require(_startTime >= now && _endTime > _startTime, "Date parameters are not valid");
        startTime = _startTime;
        endTime = _endTime;
        fundsWallet = _fundsReceiver;
        
        emit RegisterdBasicPurchaseConfig(_from, _fundsReceiver, _startTime, _endTime);
        
        return true;

    }

    mapping (address => uint256) public purchasers;
    
    constructor (address _product, address _registry) public
    InterfaceModule(_product, _registry)
    {
        
    }

    function () external payable {
        purchaseProduct(msg.sender);
    }

    modifier checkGranularity(uint256 _amount) {
        require(_amount % granularity == 0, "Unable to modify token balances at this granularity");
        _;
    }
    
    function changeGranularity(uint256 _granularity) public returns(bool) {
        
        require(_granularity != 0, "Granularity can not be 0");
        
        emit LogGranularityChanged(granularity, _granularity);
        
        granularity = _granularity;

        return true;
    }

    // msg.value와 granularity 값이 같아야 한다.
    function purchaseProduct(address _investor) public payable nonReentrant checkGranularity(msg.value) returns (bool) {
        
        uint256 klayAmount = msg.value;

        _processTx(_investor, klayAmount);

        return true;
    }

    function _processTx(address _beneficiary, uint256 _investedAmount) internal {

        _preValidatePurchase(_beneficiary, _investedAmount);
        // calculate token amount to be created
        uint256 klays = _investedAmount;

        // update state
        productSold = productSold.add(_investedAmount);

        _processPurchase(_beneficiary, klays);

        _forwardFunds();
        
        emit ProductPurchase(sigStockProduct, _beneficiary,  klays);

    }
    
    function _preValidatePurchase(address _beneficiary, uint256 _investedAmount)  internal pure  {
        require(_beneficiary != address(0), "Beneficiary address should not be 0x");
        require(_investedAmount != 0, "Amount invested should not be equal to 0");
        
    }
    /**
    * @notice Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
    * @param _beneficiary Address receiving the tokens
    * @param _tokenAmount Number of tokens to be purchased
    */
    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
        
        if (purchasers[_beneficiary] == 0) {
            purchaserCount = purchaserCount + 1;
        }
        
        purchasers[_beneficiary] = purchasers[_beneficiary].add(_tokenAmount);

    }

    function isPurchaser(address _purchaser) public view returns (bool) {
        
        bool result = false;
        if(purchasers[_purchaser] > 0) {
            result = true;
        }

        return result;
    }
    function getNumberPurchasers() public view returns (uint256) {
        return purchaserCount;
    }

    function getRaisedKlay() public view returns (uint256) {       
        return productSold;
    }

    function _forwardFunds() internal {
        //In progress
        // address divideModule = InterfaceProduct(sigStockProduct).module(DIVIDE_KEY);
        // InterfaceDivideModule(divideModule).purchase(msg.sender);
        fundsWallet.transfer(msg.value);
    }
    

    function getType() public view returns(uint8) {
        return 2;
    }
    

    function getName() public view returns(bytes32) {
        return "BasicPurchaseModule";
    }
}