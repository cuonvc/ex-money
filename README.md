# Exmoney - Expense tracking application

### Step by step to build the application for Android
- Clone the mobile project from [develop branch](https://github.com/cuonvc/ex-money/tree/develop)
- Clone the backend project from [develop branch]() and run with Spring or pull the [Docker image]() from Docker hub
- [Install Dart and Flutter](https://docs.flutter.dev/get-started/install)
- Create [Firebase](https://console.firebase.google.com/u/0/) project
- Generate SHA1 and SHA256 and config to the Android application on Firebase - ```keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android```
- In the Android app on Firebase project, config the ```SHA1``` and ```SHA256``` token
- Download the ```google-services.json``` file and paste to ```../android/app``` directory
- Copy and paste the client ID from the ```GoogleService-Info.plist``` into ```../ios/Runner/Info.plist``` file
```  <key>GIDClientID</key>
<!-- TODO Replace this value: -->
<!-- Copied from GoogleService-Info.plist key CLIENT_ID -->
<string>[YOUR IOS CLIENT ID]</string>
```
- Paste the ```firebase_options.dart``` file to ```../lib``` directory
- Paste the ```firebase.json``` file to the root directory
- ...and ```flutter pub get```

---
