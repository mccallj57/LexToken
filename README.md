# LexToken ⚡⚖️⚔️
Standard Ethereum (ERC-20) Tokens with LexDAO Governance: *Burnable, Capped, Mintable, Pausable*

[LexToken ERC20 Factory](https://etherscan.io/address/0x00534caeB1c9A7fbE59449653914ECcd4bCfBdB6#code) *0x005 . . .*

## Smart Contract

[Etherscan](https://etherscan.io/) is a popular explorer for the Ethereum blockchain.

Etherscan further provides an interface to read and write from the LexToken Factory code deployed on Ethereum: 

[READ](https://etherscan.io/dapp/0x00534caeB1c9A7fbE59449653914ECcd4bCfBdB6#readContract) to keep track of LexToken deployments 🧮

[WRITE](https://etherscan.io/dapp/0x00534caeB1c9A7fbE59449653914ECcd4bCfBdB6#writeContract) to deploy LexToken from Factory 🏭

If you have a [MetaMask](https://metamask.io/) wallet account (🦊) on your Chrome, Firefox or Brave browser and ETH to pay for transactions, you can deploy a LexToken with custom parameters, such as initial supply and hard cap, as well as make direct petitions to lexDAO members to resolve balances. 

## Uniswap Listing

All LexToken deployments automatically create an exchange on [Uniswap](https://uniswap.exchange/) (🦄) which can be read in each verified LexToken smart contract and deployment transaction.

## Governance

[LexDAO](http://nightly.aragon.org/#/lexdao) members vote to resolve lost or disputed balances of LexTokens. LexDAO and other accounts granted the `LexDAORole` control the following functions on all LexTokens:

    function lexDAOburn(address account, uint256 amount) public onlyLexDAO returns (bool) {
        _burn(account, amount); // lexDAO governance reduces token balance
        return true;
    }

    function lexDAOmint(address account, uint256 amount) public onlyLexDAO returns (bool) {
        _mint(account, amount); // lexDAO governance increases token balance
        return true;
    }
    
    function lexDAOtransfer(address from, address to, uint256 amount) public onlyLexDAO returns (bool) {
        _transfer(from, to, amount); // lexDAO governance transfers token balance
        return true;
    }

LexToken users retain the `PauserRole` and can effectively shut down their LexToken in the event that they cannot reach consensus with LexDAO transactions. We nonetheless welcome users to call the `addPauser` function with the lexDAO Agent address (0x97103fda00a2b47EaC669568063C00e65866a633) and negotiate pausing services on [lexdao.chat](http://lexdao.chat/).

Factory Fee for LexToken Deployment: 0.001 ETH 🏭
