# Suinvest

## Introduction

### 💭 Background

Web3's technical brilliance often means that consumer apps that are built around this technology have a complicated UX. This open-source app aims to show how the experience of onboarding to crypto on Sui can be seamless and hassle-free.

By creating a user-friendly mobile application which abstracts away much of the hassle of blockchain account management to a Face ID scan and compiles coin data in a simple way, we aimed to create an all-in-one Sui DeFi app perfect for first-time crypto users.

This project was funded by a Sui Ecosystem Grant with the purpose of being a fully documented, open-source project. The app was designed with best practices in mind, allowing future Sui developers to learn from our design patterns and implementation.

### 📋 Scope

This project is a standalone mobile application for new users of the Sui network which allows them to sign in to the application through Apple Face ID and use the tools in the application to invest and trade crypto assets.

Specific features include:
- On initial app launch, the user can add 1 account to the app either by entering a private key or randomly generating a new one.
- The same FaceID that unlocks the device also unlocks access to the account.
- The ability to view the account portfolio value in USD as well as ecosystem health (Sui price, market cap, etc).
- The ability to search all coins on Sui and see the 24 hr price graph of each coin.
- The ability to swap from SUI to another token and from another token back to SUI.

### 👤 Team

Our team is comprised of 4 developers from UC Berkeley:
- Matthew Fogel ([LinkedIn](https://www.linkedin.com/in/m-fogel/) / [GitHub](https://github.com/dev-matthew)), UC Berkeley EECS ‘24
- Lawson Graham ([LinkedIn](https://www.linkedin.com/in/lawsongraham/) / [GitHub](https://github.com/LawsonGraham)), UC Berkeley CS & Philosophy ‘25
- Sena Hazir ([LinkedIn](https://www.linkedin.com/in/senahazir/) / [GitHub](https://www.linkedin.com/in/senahazir/)), UC Berkeley CS ‘25
- Derrick Cui ([LinkedIn](https://www.linkedin.com/in/derrick-cui/) / [GitHub](https://github.com/zeebradoom)), UC Berkeley CS & Business ‘25


## Design

### 📍 [Figma Design](https://www.figma.com/file/rQTPA0y29JF3QvLzLWhdWK/sui-app-design?type=design&node-id=0%3A1&mode=design&t=XRQymPFUMHFeUWcY-1)

Our design philosophy was to focus on simplicity and ease of use, as our app focuses on onboarding new users to the Sui ecosystem. Our color pallete matches the existing color scheme of the Sui ecosystem. All pages have simple buttons to move forward or backwards throughout the app.

When a user first signs up, they can simply enter their private key or randomly generate one and protect it with FaceID. When a user opens the app, they will be prompted to sign in with FaceID before being redirected to the rest of the app.

The main app has three sections - home page, coins page, and exchange page:
- Home page displays information about the user’s portfolio as well as information about the Sui ecosystem’s health as a whole.
- Coins page displays a list of coins, which users can tap on to view historical data and other important metrics.
- Exchange page allows users to buy or sell tokens that they hold in exchange for SUI token.

## Tech Stack / Architecture

<img src="assets/images/Sui Technical Architecture.png"><br>

Suinvest was developed using [Flutter](https://flutter.dev/). As an educational project, Flutter is advantageous because of its relative simplicity to understand and large package presence. This [tutorial](https://codelabs.developers.google.com/codelabs/flutter-codelab-first#0) proved useful for getting started.

Important Integrations:
- [Sui Flutter Package](https://pub.dev/packages/sui)
  - This package allows our application to interact with the Sui Blockchain.
  - This is useful for our swapping functionality, in which we make calls to on-chain Cetus DEX contracts.
- [Flutter Locker Package](https://pub.dev/packages/flutter_locker)
  - This packages allows our application to retrieve the user's private key and Sui Wallet after a successful face identification.
  - Prior to local retrieval, the key is securely stored via Apple Keychain's storage.
- [CoinGecko API](https://www.coingecko.com/api/documentation)
  - This API allows our application to fetch relevant information. This includes ecosystem health like market cap as well as specific coin data such as price and volume.

## Project Structure

<img src="assets/images/Sui File Graph.png"><br>
*This image was generated using [Visualizing a Codebase](https://githubnext.com/projects/repo-visualization/#integrate-into-your-own-projects)*

### Important Files / Directories
```
.
├── ...
├── ios                    # Packages to configure ios deployment
├── lib
│   ├── src                # Load and stress tests
│   │   ├── common         # Constant addresses, coin data, colors, etc
│   │   ├── frontend
│   │   │   ├── widgets                # UI widgets, output StatelessWidgets
│   │   │   ├── accountcreation.dart   # First time user flow
│   │   │   ├── coinPage.dart          # List of coins
│   │   │   ├── exchange.dart          # Swap tokens
│   │   │   ├── home.dart              # Home page showing ecosystem health data
│   │   │   ├── price_history.dart     # Price graph / data on each coin
│   │   │   └── routing.dart           # Global app router and bottom nav bar
|   |   |
|   |   ├── services
│   │   │   ├── authentication.dart    # Authentication secret management
│   │   │   ├── coingecko.dart         # Fetch coin price data from API
│   │   │   └── sui.dart               # On-chain Cetus interactions
|   |   |
│   │   └── app.dart       # FaceID account fetch / page navigation
│   └── main.dart          # Entry point - run this file to launch the app
```

## How to Run

- Ensure you have the newest version of Flutter installed (3.16.9 was used for this project)
- Ensure you have the newest version of Xcode installed and that your Mac is up to date
- Clone this repository and navigate to the root folder in your terminal
- Run `flutter doctor` to ensure your installation was successful
- Execute `flutter pub get` to install dependencies
- Execute `flutter run`
    - When prompted, choose a simulator/device
