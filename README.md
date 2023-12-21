# Room

Room is a group chat application built with Flutter and Firebase, allowing users to enterg different rooms and engage in conversations.


## Getting Started

You have two options to get started:

###1.Download the App and Start Using It:
   Simply download the app and start using it right away.
   The room creation feature is not added yet,but you can use the exsisting rooms.
   
   -latest version:[Room v0.1.0](https://github.com/HARISH6000/Room/releases/tag/v0.1.0)

###2.Clone this Repository and Set Up Your Own Firebase Project:
   Clone this repository and create a new Firebase project. 
   Integrate it with the cloned Flutter project to gain more control over the app.
   By using this method you can manually create more rooms in the backend.

    Follow these steps to get the app up and running on your local machine.

    #### Prerequisites

    - Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
    - Firebase Project: [Create a Firebase Project](https://console.firebase.google.com/)

    #### Configuration

    1. Clone the repository:

        ```bash
        git clone https://github.com/HARISH6000/Room
        ```

    2. Navigate to the project directory:

        ```bash
        cd Room
        ```

    3. Install dependencies:

        ```bash
        flutter pub get
        ```

    4. Configure Firebase:
    
        - Create a Firebase project.
        - Add a new Android/iOS app to your Firebase project.
        - Download the `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) file.
        - Place the downloaded file in the respective platform folder (`android/app` for Android, `ios/` for iOS).
        -  ```bash
        flutterfire configure
        ```
        - use the above command to configure your project.

    5. Run the app:

        ```bash
        flutter run
        ```

