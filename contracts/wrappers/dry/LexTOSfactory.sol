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

interface IToken { // brief ERC-20 interface
    function balanceOf(address account) external view returns (uint256);
    function burn(uint256 amount) external;
    function transfer(address recipient, uint256 amount) external;
}

contract LexTOS is Context { 
    IToken public OT; 
    address payable public owner;
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
    
    event OfferUpdated(string indexed _offer);
    event OfferRedeemed(address indexed signatory, uint256 indexed number, string indexed details);
    event OwnerPaid(address indexed sender, uint256 indexed payment, string indexed details);
    event OwnerUpdated(address indexed _owner);
    event PurchaseRateUpdated(uint256 indexed _purchaseRate);
    event RedemptionAmountUpdated(uint256 indexed _redemptionAmount);
    event TermsUpdated(string indexed _terms);
    
    constructor (
        address _offerToken, // offer token for mkt
        address payable _owner, // initial owner of TOS / offer 
        uint256 _purchaseRate, 
        uint256 _redemptionAmount, 
        string memory _offer, 
        string memory _terms) public {
        OT = IToken(_offerToken);
        owner = _owner;
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
        owner.transfer(msg.value);
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
        emit OfferRedeemed(_msgSender(), number, details);
    }
 
    /**************
    OWNER FUNCTIONS
    **************/
    modifier onlyOwner () {
        require(_msgSender() == owner, "caller not owner");
        _;
    }
    
    function payOwner(string memory details) payable public { // public attaches ether (Ξ) with details to owner
        owner.transfer(msg.value);
        emit OwnerPaid(_msgSender(), msg.value, details);
    }

    function updateOffer(string memory _offer) public onlyOwner {
        offer = _offer;
        emit OfferUpdated(_offer);
    }
    
    function updateOwner(address payable _owner) public onlyOwner {
        owner = _owner;
        emit OwnerUpdated(_owner);
    }
    
    function updatePurchaseRate(uint256 _purchaseRate) public onlyOwner {
        purchaseRate = _purchaseRate;
        emit PurchaseRateUpdated(_purchaseRate);
    }
    
    function updateRedemptionAmount(uint256 _redemptionAmount) public onlyOwner {
        redemptionAmount = _redemptionAmount;
        emit RedemptionAmountUpdated(_redemptionAmount);
    }
    
    function updateTerms(string memory _terms) public onlyOwner {
        terms = _terms;
        emit TermsUpdated(_terms);
    }

    function withdrawOT() public onlyOwner {
        OT.transfer(_msgSender(), OT.balanceOf(address(this)));
    }
}

contract LexTOSfactory is Context {
    // presented by OpenESQ || LexDAO LLC ~ Use at own risk! || chat with us: lexdao.chat 
    address payable public lexDAO; 
    uint8 public version = 1;
    uint256 public factoryFee;
    string public stamp;
    
    LexTOS private TOS;
    address[] public tos; 
    
    event FactoryFeeUpdated(uint256 indexed _factoryFee);
    event FactoryStampUpdated(string indexed _stamp);
    event LexDAOpaid(address indexed sender, uint256 indexed payment, string indexed details);
    event LexDAOupdated(address indexed _lexDAO);
    event tosDeployed(address indexed TOS, address indexed _owner);
    
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
        address payable _owner, 
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
        emit LexDAOpaid(_msgSender(), msg.value, details);
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
