# LexToken ⚡⚖️⚔️
Standard Ethereum (ERC-20) Tokens with opt-in LexDAO Governance: *Burn, Cap, Mint, Pause, Stamp*

[![built-with openzeppelin](https://img.shields.io/badge/built%20with-OpenZeppelin-3677FF)](https://docs.openzeppelin.com/)

## LexToken Factory

`Factory` deployments allow the public to issue custom LexToken (ERC-20) for a 0.0009 ETH fee:

- [Ethereum Mainnet](https://etherscan.io/address/0xde2bd2986CFBccD8061A935859d06B24d5684cC9#code) *0xde2bd . . .*
- [Rinkeby Testnet](https://rinkeby.etherscan.io/address/0x4C9CbB9af00A6A49fb6fD909FCB747C2231710D5#code) *0x4C9Cb . . .*

### Getting started:

[Etherscan](https://etherscan.io/) is a popular explorer for the Ethereum blockchain.

Etherscan further provides an interface to read and write from the LexToken Factory code deployed on Ethereum: 

[READ](https://etherscan.io/dapp/0xde2bd2986CFBccD8061A935859d06B24d5684cC9#readContract) to keep track of LexToken deployments 🧮

[WRITE](https://etherscan.io/dapp/0xde2bd2986CFBccD8061A935859d06B24d5684cC9#writeContract) to deploy LexToken from Factory 🏭

If you have a [MetaMask](https://metamask.io/) wallet account (🦊) on your Chrome, Firefox or Brave browser and ETH to pay for transactions, you can deploy a LexToken with custom parameters, such as initial supply and hard cap, as well as make direct petitions to lexDAO members to resolve balances if governance is enabled. 

## Dapps powered by LexToken ✨

* [LexDAO Personal Token Factory](https://lexdao.org/#/personal-token) ⚔️
> Personal "Time" Token launcher with LexDAO-certified parameters.
* [PersonalToken.Me](https://personaltoken.me/) 👥
> Generalized Personal Token "Deal" launcher with OpenLaw ricardian docs.

## Governance

[LexDAO Token Review](https://nightly.aragon.org/#/lexdaotokenreview) members vote to resolve lost or disputed balances of LexTokens. LexDAO and other accounts granted the `LexDAORole` control the following functions on all LexTokens:

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

Each LexToken can be certified by lexDAO for wet and dry code quality (for example, "Does my LexTokenized land deed pass muster?"):

    function lexDAOcertify(string memory details, bool _lexDAOcertified) public onlyLexDAO {
        lexDAOcertified = _lexDAOcertified; // lexDAO governance adjusts token certification
        emit LexDAOcertified(details, _lexDAOcertified);
    }

### Lexit 

LexToken users start with `PauserRole` and can effectively shut down their LexToken in the event that they cannot reach consensus with LexDAO transactions, freezing `lexDAOtransfer`. Further, pauser admin(s) can toggle LexDAO governance on-and-off by calling the following function:

    function lexDAOgovernance(string memory details, bool _lexDAOgoverned) public onlyPauser {
        lexDAOgoverned = _lexDAOgoverned; // pauser admin(s) adjust lexDAO governance 
        emit LexDAOgoverned(details, _lexDAOgoverned);
    }
