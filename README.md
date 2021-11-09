# Crowdfunding project

## Setup
- [Truffle](https://www.trufflesuite.com/) is needed.
- [Infura](https://infura.io/) account:  In case you  want to deploy to the test net.
- Create an `.env` file and add the Infura ProjectID and your MetaMask seed (create a copy from .env.example).
- Alternative to the previous steps, you can deploy it locally using [Ganache](https://www.trufflesuite.com/ganache)

## How to use it?
Use node version. Install it if needed:
```
nvm use
```

Install truffle suite:
```
npm install -g truffle
```

Install dependencies:
```
npm install
```

Compile the project:
```
truffle compile
```

Migrate the contract to the Ropsten network:
```
truffle migrate --network ropsten
```

You should see your contract deployed [here](https://ropsten.etherscan.io/).



