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

1. Clone the repository from GitHub:
   ```bash
   git clone https://github.com/rubayethasan21/iPact.git
   ```

2. Navigate into the project directory:
   ```bash
   cd iPact
   ```

3. Clean the project to remove any previous builds:
   ```bash
   flutter clean
   ```

4. Install dependencies:
   ```bash
   flutter pub get
   ```

5. Run the project on a simulator or physical device:
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










