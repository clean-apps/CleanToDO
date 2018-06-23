# Cleaner To-Do list for Android

It is an attempt to create a cleaner, smarter and a fully featured todo manager.

- [x] Fully featured todo list screen 
- [x] Ability to group tasks into lists and further group those lists
- [x] Smart reminders with support for repeat notifications
- [x] Quickly add tasks from lists view
- [x] Summary of tasks with the My Day screen
- [x] Multiple Color screens, with Material UI
- [ ] Online task sync

[<img src="https://raw.githubusercontent.com/babanomania/CleanToDO/master/images/download-apk-version.png" />](https://github.com/babanomania/CleanToDO/releases/download/1.2.20180623/clean_todo_v1.2.20180623.apk)

# Screenshots

<img src="https://github.com/babanomania/CleanToDO/raw/master/images/framed/1_promo.jpg?raw=true" width="600"/>
 
<img src="https://github.com/babanomania/CleanToDO/raw/master/images/framed/2_promo.jpg?raw=true" width="600"/>

<img src="https://github.com/babanomania/CleanToDO/raw/master/images/framed/3_promo.jpg?raw=true" width="600"/>

# Usage

1. Follow the installation instructions on [www.flutter.io](www.flutter.io) to install Flutter.
2. You'll need to create a Firebase instance. Follow the instructions at [https://console.firebase.google.com](https://console.firebase.google.com)
3. Once your Firebase instance is created, you'll need to enable anonymous authentication.
    * Go to the Firebase Console for your new instance.
    * Click "Authentication" in the left-hand menu
    * Click the "sign-in method" tab
    * Click "anonymous" and enable it
    * Create an app within your Firebase instance for Android, with package name com.yourcompany.cleantodo
    * Follow instructions to download google-services.json, and place it into clean_todo/android/app/
    * Run the following command to get your SHA-1 key:
    
       ```
       keytool -exportcert -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
       ```
    * In the Firebase console, in the settings of your Android app, add your SHA-1 key by clicking "Add Fingerprint".

4. Clean ToDo can be run like any other Flutter app, either through the IntelliJ UI or through running the following command from within the clean_todo directory:

       flutter run

# License

Copyright 2018 Shouvik Basu

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
limitations under the License.

# Credits

* [This Talk](https://www.youtube.com/watch?v=iflV0D0d1zQ) by Emily Fortuna and Matt Sullivan that inspired me to learn flutter
* [Microsoft To-Do](https://todo.microsoft.com/en-us) team for their awesome material design UI/UX
* [Flutter Team](https://github.com/flutter/)
* [Firebase Team](https://firebase.google.com/docs/auth/)
* [Launcher Icons Plugin](https://github.com/franzsilva/flutter_launcher_icons)
* [Path Provider Plugin](https://github.com/flutter/plugins/tree/master/packages/path_provider)
* [Sqflite Plugin](https://github.com/tekartik/sqflite)
* [Local Notifications Plugin](https://github.com/MaikuB/flutter_local_notifications)
* [Shared Notifications Plugin](https://github.com/flutter/plugins/tree/master/packages/shared_preferences)
* [Color Plugin](http://github.com/MichaelFenwick/Color)
* [Google Sign-In Plugin](https://github.com/flutter/plugins/tree/master/packages/google_sign_in)


