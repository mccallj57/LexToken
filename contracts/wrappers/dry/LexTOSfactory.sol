/*
██╗     ███████╗██╗  ██╗  
██║     ██╔════╝╚██╗██╔╝  
██║     █████╗   ╚███╔╝   
██║     ██╔══╝   ██╔██╗   
███████╗███████╗██╔╝ ██╗  
╚══════╝╚══════╝╚═╝  ╚═╝  
                          
████████╗ ██████╗ ███████╗
╚══██╔══╝██╔═══██╗██╔════╝
   ██║   ██║   ██║███████╗
   ██║   ██║   ██║╚════██║
   ██║   ╚██████╔╝███████║
   ╚═╝    ╚═════╝ ╚══════╝
DEAR MSG.SENDER(S):

/ LexTOS is a project in beta.
// Please audit and use at your own risk.
/// Entry into LexTOS shall not create an attorney/client relationship.
//// Likewise, LexTOS should not be construed as legal advice or replacement for professional counsel.
///// STEAL THIS C0D3SL4W 

~presented by Open, ESQ || LexDAO LLC
*/

pragma solidity 0.5.17;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IToken { // brief ERC-20 interface
    function balanceOf(address account) external view returns (uint256);
    function burn(uint256 amount) external;
    function transfer(address recipient, uint256 amount) external;
}

/*********************
SMART TERMS OF SERVICE
*********************/
contract LexTOS is Context, Ownable { 
    IToken public OT; 
    uint256 public purchaseRate;
    uint256 public redemptionAmount;
    string public offer;
    string public terms;
    
    // signature tracking 
    uint256 public signature; 
    mapping (uint256 => Signature) public sigs;
    
    struct Signature {  
        address signatory;
        uint256 number;
        uint256 timestamp;
        string details;
    }
    
    event OfferUpgraded(string indexed _offer);
    event PurchaseRateUpgraded(uint256 indexed _purchaseRate);
    event RedemptionAmountUpgraded(uint256 indexed _redemptionAmount);
    event Signed(address indexed signatory, uint256 indexed number, string indexed details);
    event TermsUpgraded(string indexed _terms);
    
    constructor (
        address _offerToken, // offer token for mkt
        address _owner, // initial owner of TOS / offer 
        uint256 _purchaseRate, 
        uint256 _redemptionAmount, 
        string memory _offer, 
        string memory _terms) public {
        OT = IToken(_offerToken);
        transferOwnership(_owner);
        purchaseRate = _purchaseRate;
        redemptionAmount = _redemptionAmount;
        offer = _offer;
        terms = _terms;
    } 
    
    /***************
    LEXTOS FUNCTIONS
    ***************/
    function() external payable { 
        uint256 purchaseAmount = msg.value * purchaseRate;
        OT.transfer(_msgSender(), purchaseAmount);
    } 
    
    function redeemOffer(string memory details) public {
	    uint256 number = signature + 1; 
	    signature = signature + 1;
	    
        sigs[number] = Signature( 
            _msgSender(),
            number,
            now,
            details);
                
        OT.burn(redemptionAmount);
        emit Signed(_msgSender(), number, details);
    }
 
    /*************
    MGMT FUNCTIONS
    *************/
    // offer / terms
    function upgradeOffer(string memory _offer) public onlyOwner {
        offer = _offer;
        emit OfferUpgraded(_offer);
    } 
    
    function upgradeTerms(string memory _terms) public onlyOwner {
        terms = _terms;
        emit TermsUpgraded(_terms);
    } 
    
    // OT mgmt
    function upgradePurchaseRate(uint256 _purchaseRate) public onlyOwner {
        purchaseRate = _purchaseRate;
        emit PurchaseRateUpgraded(_purchaseRate);
    }
    
    function upgradeRedemptionAmount(uint256 _redemptionAmount) public onlyOwner {
        redemptionAmount = _redemptionAmount;
        emit RedemptionAmountUpgraded(_redemptionAmount);
    }
    
    function withdrawETH() public onlyOwner {
        address(_msgSender()).transfer(address(this).balance);
    }
    
    function withdrawOT() public onlyOwner {
        OT.transfer(_msgSender(), OT.balanceOf(address(this)));
    } 
}

contract LexTOSfactory is Context {
    // presented by OpenESQ || LexDAO LLC ~ Use at own risk! || chat with us: lexdao.chat 
    string public stamp;
    uint8 public version = 1;
    uint256 public factoryFee;
    address payable public lexDAO; 
    
    LexTOS private TOS;
    address[] public tos; 
    
    event FactoryFeeUpdated(uint256 indexed _factoryFee);
    event FactoryStampUpdated(string indexed _stamp);
    event LexDAOpaid(string indexed details, uint256 indexed payment, address indexed sender);
    event LexDAOupdated(address indexed _lexDAO);
    event tosDeployed(address indexed TOS, address indexed owner);
    
    constructor (
        string memory _stamp, 
        uint256 _factoryFee, 
        address payable _lexDAO) public 
    {
        lexDAO = _lexDAO;
        stamp = _stamp;
        factoryFee = _factoryFee;
    }
    
    function newLexTOS( // public issues LexTOS for factory ether (Ξ) fee
        address _offerToken, 
        address _owner, 
        uint256 _purchaseRate, 
        uint256 _redemptionAmount, 
        string memory _offer, 
        string memory _terms) payable public {
        require(msg.value == factoryFee, "factory fee not attached");
        
        TOS = new LexTOS(
            _offerToken, 
            _owner, 
            _purchaseRate, 
            _redemptionAmount, 
            _offer, 
            _terms);
        
        tos.push(address(TOS));
        address(lexDAO).transfer(msg.value);
        emit tosDeployed(address(TOS), _owner);
    }
    
    function payLexDAO(string memory details) payable public { // public attaches ether (Ξ) with details to lexDAO
        lexDAO.transfer(msg.value);
        emit LexDAOpaid(details, msg.value, _msgSender());
    }
    
    function getTOSCount() public view returns (uint256) {
        return tos.length;
    }
    
    /***************
    LEXDAO FUNCTIONS
    ***************/
    modifier onlyLexDAO () {
        require(_msgSender() == lexDAO, "caller not lexDAO");
        _;
    }

    function updateFactoryFee(uint256 _factoryFee) public onlyLexDAO {
        factoryFee = _factoryFee;
        emit FactoryFeeUpdated(_factoryFee);
    }
    
    function updateFactoryStamp(string memory _stamp) public onlyLexDAO {
        stamp = _stamp;
        emit FactoryStampUpdated(_stamp);
    }
    
    function updateLexDAO(address payable _lexDAO) public onlyLexDAO {
        lexDAO = _lexDAO;
        emit LexDAOupdated(_lexDAO);
    }
}
