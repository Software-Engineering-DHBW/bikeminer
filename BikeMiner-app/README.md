# Bikeminer-App

This app is written in Dart

[BikeMiner-app Documentation](https://htmlpreview.github.io/?https://github.com/Software-Engineering-DHBW/bikeminer/blob/main/BikeMiner-app/Documentation/api/index.html)

## Setup and run

1. [Install Flutter](https://docs.flutter.dev/get-started/install)

2. Open this app with an IDE that supports flutter. (e.g. AndroidStudio, VSCode)
3. Open lib/main.dart
4. If there appears a bar "**install plugins**", then execute it
5. If there appears a bar "**Dart SDK is not configured**", then press "**Open Dart settings**"
    - Paste the Flutter-SDK-Path to "File>Settings> Languages & Frameworks>**Flutter**" and press **apply**
    - if "**Flutter**" is not shown under path <em>"File > Settings> Languages & Frameworks"</em>
        - <em>install Flutter plugin in AndroidStudio </em>
6. If there appears a bar "**get dependency**", then press/execute
    - No "**get dependency**" is shown?
        - <em>Open up a terminal in this project</em> 
        - <em>Execute ```flutter pub get```</em>

7. Connect Android Smartphone with Computer or create/add a virtual Device per AndroidStudio's Device Manager
    - **Attention**: Device must support Google Play Services
        - <em>Older Devices may need to perform a Google Services Update first</em>
    - if you use your own Android Smartphone
        - <em>you have to replace the content of</em> ```final _server= "127.0.0.1"``` <em>(in lib/backend/api_connector.dart line:8) with the IP of your device</em>
    - <em>**Special-Case**</em>: 
        - if the **virtual device** does not work, you might have to replace the content of ```final_server="127.0.0.1"``` with ```10.0.2.2```
8. Click on "Run"-Button to execute the main.dart


## Testing

- Paste in the commandline:
    - ```flutter test/backend/api_connector_test.dart```
- or open the testfile and start it with the IDE.


## Getting Started

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
