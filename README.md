# LexToken ⚡⚖️⚔️
Standard Ethereum (ERC-20) Tokens with LexDAO Governance: *Burnable, Capped, Mintable, Pausable, Uniswap-enabled*

[LexToken Factory Maker](https://etherscan.io/address/https://etherscan.io/address/0x80CFbE26CCA322411F9F005d25ba54127618Fcb0#code) *0x80C . . .*

[LexToken Factory](https://etherscan.io/address/0x99755ceba6460491173307985ea7c0cdb0a84d7a#code) *0x997 . . .*

## LexToken Factory Maker

The `LexTokenFactoryMaker` allows the public to deploy LexToken factories for a 0.0009 ETH fee. 

LexToken factories can be programmed with their own `FactoryFee` payable in ETH, (identifying) string `stamp` and can be further set as `gated` to restrict factory access to a `deployer` account. For example, an Aragon DAO might use the Agent app to control a gated LexToken Factory and issue a series of token assets with a vote of group commitments logically attached. In this fashion, the public can understand LexDAO-governed assets as legally or otherwise authorized merely by checking the upstream factory address. A general-purpose (*ungated*) LexToken factory is documented below 👇.

### LexDAO Certification

Each contract issued in the LexToken lineage can be certified by lexDAO for code and legal security purposes. An example call involves this simple overlay to the ERC-20 contract:

    function lexDAOcertify(bool _certified) public onlyLexDAO {
        certified = _certified; // lexDAO governance maintains token contract certification
    }

// and factory: 

    function updateCertification(bool updatedCertification) public {
        require(msg.sender == _lexDAO);
        _certified = updatedCertification;
        emit CertificationUpdated(updatedCertification);
    }

### LexDAO Governance Account

The master lexDAO governance account for LexToken factories // LexToken fee and recovery managment is controlled by the existing `_lexDAO.`

## LexToken Factory

The `LexToken Factory` allows the public to deploy custom LexToken (ERC-20) for a 0.0009 ETH fee.

[Etherscan](https://etherscan.io/) is a popular explorer for the Ethereum blockchain.

Etherscan further provides an interface to read and write from the LexToken Factory code deployed on Ethereum: 

[READ](https://etherscan.io/dapp/0x99755ceba6460491173307985ea7c0cdb0a84d7a#readContract) to keep track of LexToken deployments 🧮

[WRITE](https://etherscan.io/dapp/0x99755ceba6460491173307985ea7c0cdb0a84d7a#writeContract) to deploy LexToken from Factory 🏭

If you have a [MetaMask](https://metamask.io/) wallet account (🦊) on your Chrome, Firefox or Brave browser and ETH to pay for transactions, you can deploy a LexToken with custom parameters, such as initial supply and hard cap, as well as make direct petitions to lexDAO members to resolve balances. 

## Uniswap Listing

All LexToken deployments automatically create an exchange on [Uniswap](https://uniswap.exchange/) (🦄) which can be read in each verified LexToken smart contract and deployment transaction.

## Dapps powered by LexToken ✨

* [PersonalToken.Me](https://personaltoken.me/) 👥

## Governance

[LexDAO](http://nightly.aragon.org/#/lexdao) members vote to resolve lost or disputed balances of LexTokens. LexDAO and other accounts granted the `LexDAORole` control the following functions on all LexTokens:

    function lexDAOburn(address account, uint256 amount) public onlyLexDAO {
        _burn(account, amount); // lexDAO governance reduces token balance
    }
    
    function lexDAOcertify(bool _certified) public onlyLexDAO {
        certified = _certified; // lexDAO governance maintains token contract certification
    }

    function lexDAOmint(address account, uint256 amount) public onlyLexDAO {
        _mint(account, amount); // lexDAO governance increases token balance
    }
    
    function lexDAOtransfer(address from, address to, uint256 amount) public onlyLexDAO {
        _transfer(from, to, amount); // lexDAO governance transfers token balance
    }

### Lexit 

LexToken users retain the `PauserRole` and can effectively shut down their LexToken in the event that they cannot reach consensus with LexDAO transactions. We nonetheless welcome users to call the `addPauser` function with the lexDAO Agent address (0x97103fda00a2b47EaC669568063C00e65866a633) and negotiate pausing services on [lexdao.chat](http://lexdao.chat/).
