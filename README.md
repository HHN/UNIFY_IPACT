<p align="center">
  <a href="https://www.hs-heilbronn.de/de/induko" target="blank"><img src="induko_image.png" width="600" alt="Induko Logo" /></a>
</p>

[circleci-image]: https://img.shields.io/circleci/build/github/nestjs/nest/master?token=abc123def456
[circleci-url]: https://circleci.com/gh/nestjs/nest

<p align="center">

Heilbronn University is researching advanced technical tools and didactic approaches designed to foster collaboration and interaction. The primary goal is to enhance and facilitate interdisciplinary, inter-faculty, and inter-university cooperation. Through the InduKo research project, we aim to strengthen this collaboration using innovative digital tools and modern, digitally supported strategies that boost motivation and foster innovation through partnership.

In many research collaborations, sensitive data is frequently exchanged between universities, research institutions and industry partners. While digital platforms, cloud storage, and online communication tools simplify this process, they often lack mechanisms to document and verify file transfers reliably. Confidentiality agreements require proof that data was exchanged and remained unaltered, yet traditional methods such as email, cloud storage, and messaging services provide no guarantee of integrity or receipt confirmation. iPact addresses these challenges by offering a secure, decentralized platform for file exchange without relying on a central authority. Using Distributed Ledger Technology (DLT), every data transaction is recorded in an immutable ledger, ensuring transparency, authenticity, and long-term verifiability. This approach eliminates vulnerabilities associated with centralized systems while maintaining user control over shared data.

iPact showcases how Distributed Ledger Technology can ensure the integrity and traceability of digital file exchanges. By demonstrating a decentralized approach to documenting and verifying data transfers, it highlights how sensitive information can be securely exchanged without relying on third-party trust, offering a new perspective on secure academic collaboration. Further information can be found in the PDF document linked above.

iPact was developed as part of a subproject within the <a href="https://www.hs-heilbronn.de/en/projekt-induko-2cab68e84c21b797" target="_blank">InduKo project (Innovation through Collaboration), </a> which was funded by  <a href="https://stiftung-hochschullehre.de/en/" target="_blank">Stiftung Innovation in der Hochschullehre</a> (August 2021 - July 2024).

</p>

# iPact: Secure Collaboration and File Sharing Application

iPact is a secure, privacy-focused collaboration application designed to allow users to create encrypted collaborations and share sensitive files securely. It integrates with the IOTA Shimmer testnet to ensure file immutability through immutable transactions between users.



## Features

- **Secure Profile Creation**: Each user creates a unique profile tied to an IOTA wallet, with a private key securely stored using IOTA Stronghold technology.
- **Collaboration Creation**: Users can invite others to secure collaborations using invitation links.
- **Encrypted File Sharing**: Files are encrypted using two layers of encryption, ensuring privacy and confidentiality.
- **File Immutability Check**: Users can verify the integrity of shared files using the IOTA Tangle to ensure no tampering over time.
- **Cross-platform Compatibility**: Available on Android with support for future expansion.

## Getting Started

### Prerequisites

Before setting up iPact locally, ensure you have:

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK (included with Flutter)
- Android Studio or Visual Studio Code for running the app on an emulator or physical device.

### Installation

1. Navigate into the project directory:
   ```bash
   cd iPact
   ```

2. Clean the project to remove any previous builds:
   ```bash
   flutter clean
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the project on a simulator or physical device:
   ```bash
   flutter run
   ```

For additional help building this Flutter app, check out the [Flutter Development Documentation](https://docs.flutter.dev/get-started/codelab) and the [IOTA SDK Flutter Guide](https://iota-for-flutter.github.io/tutorial/building-a-comprehensive-app-with-iota-sdk/building-for-android.html).

## Features in Detail

### 1. Collaboration Creation
- Start a new collaboration by inviting other users using an invitation link.
- Collaborations allow secure file sharing between trusted participants.

### 2. Secure File Sharing with Encryption
- Files added to a collaboration undergo two-layer encryption:
    - **Symmetric Encryption (AES)** for file confidentiality.
    - **Asymmetric Encryption (RSA)** using the recipient's public key.
- Files are shared via external platforms like email or messaging apps.

### 3. Decrypting Files on the Receiver's Side
- Once the encrypted files are received, the receiver decrypts the outer layer using their private key and requests the symmetric key to decrypt the file contents.

### 4. File Immutability Verification
- Use the immutability check feature to confirm that shared files have not been tampered with over time. The app compares the file’s hash with the transaction stored on the IOTA Tangle.

## Helpful Resources

- Flutter Development: [Flutter Documentation](https://flutter.dev/docs)
- IOTA SDK for Flutter: [IOTA SDK Flutter Guide](https://iota-for-flutter.github.io/tutorial/building-a-comprehensive-app-with-iota-sdk/building-for-android.html)


## License
- This project is licensed under [Apache 2.0](LICENSE). Copyright 2024 , Hochschule Heilbronn.

## Acknowledgments

This project was developed as part of the **InduKo Project**, funded by **Stiftung Innovation in der Hochschullehre**. We also acknowledge the support from students, faculty, and contributors who have been part of this collaborative effort.

For more information about the InduKo research project, visit the official website.







