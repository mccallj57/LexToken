# LexToken ⚡⚖️⚔️
Standard Ethereum (ERC-20) Tokens with opt-in LexDAO Governance: *Burn, Cap, Mint, Pause, Stamp*

## LexToken Factory

`Factory` deployments allow the public to deploy custom LexToken (ERC-20) for a 0.0009 ETH fee:

- [Ethereum Mainnet](https://etherscan.io/address/0xc47e4bbdd9cdfa9a1209d05c3ded2e9b2e49dfee#code) *0xc47e . . .*
- [Rinkeby Testnet](https://rinkeby.etherscan.io/address/0x4A29ae06056873C436bD53301620270328757b87#code) *0x4A29 . . .*

### Getting started:

[Etherscan](https://etherscan.io/) is a popular explorer for the Ethereum blockchain.

Etherscan further provides an interface to read and write from the LexToken Factory code deployed on Ethereum: 

[READ](https://etherscan.io/dapp/0xc47e4bbdd9cdfa9a1209d05c3ded2e9b2e49dfee#readContract) to keep track of LexToken deployments 🧮

[WRITE](https://etherscan.io/dapp/0xc47e4bbdd9cdfa9a1209d05c3ded2e9b2e49dfee#writeContract) to deploy LexToken from Factory 🏭

If you have a [MetaMask](https://metamask.io/) wallet account (🦊) on your Chrome, Firefox or Brave browser and ETH to pay for transactions, you can deploy a LexToken with custom parameters, such as initial supply and hard cap, as well as make direct petitions to lexDAO members to resolve balances if governance is enabled. 

## Dapps powered by LexToken ✨

* [PersonalToken.Me](https://personaltoken.me/) 👥

## Governance

[LexDAO](http://nightly.aragon.org/#/lexdao) members vote to resolve lost or disputed balances of LexTokens. LexDAO and other accounts granted the `LexDAORole` control the following functions on all LexTokens:

    modifier onlyLexDAOgoverned () {
        require(lexDAOgoverned == true);
        _;
    }

    function lexDAOcertify(string memory details, bool _lexDAOcertified) public onlyLexDAO {
        lexDAOcertified = _lexDAOcertified; // lexDAO governance adjusts token certification
        emit LexDAOcertified(details, _lexDAOcertified);
    }

    function lexDAOstamp(string memory _stamp) public onlyLexDAO onlyLexDAOgoverned {
        stamp = _stamp; // lexDAO governance adjusts token stamp
        emit LexTokenStampUpdated(_stamp);
    }
    
    function lexDAOtransfer(string memory details, address from, address to, uint256 amount) public onlyLexDAO onlyLexDAOgoverned {
        _transfer(from, to, amount); // lexDAO governance transfers token balance
        emit LexDAOtransferred(details);
    }
    
### LexDAO Certification

Each contract issued in the LexToken lineage can be certified by lexDAO for code and legal security purposes. An example call involves this simple overlay to the ERC-20 contract:

    function lexDAOcertify(string memory details, bool _lexDAOcertified) public onlyLexDAO {
        lexDAOcertified = _lexDAOcertified; // lexDAO governance adjusts token certification
        emit LexDAOcertified(details, _lexDAOcertified);
    }

### Lexit 

LexToken users retain the `PauserRole` and can effectively shut down their LexToken in the event that they cannot reach consensus with LexDAO transactions. We nonetheless welcome users to call the `addPauser` function with the lexDAO Agent address (0x97103fda00a2b47EaC669568063C00e65866a633) and negotiate pausing services on [lexdao.chat](http://lexdao.chat/).

Further, pauser admin(s) can toggle LexDAO governance on-and-off by calling the following function:

    function lexDAOgovernance(string memory details, bool _lexDAOgoverned) public onlyPauser {
        lexDAOgoverned = _lexDAOgoverned; // pauser admin(s) adjust lexDAO governance 
        emit LexDAOgoverned(details, _lexDAOgoverned);
    }
