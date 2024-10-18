# My Doctor - Flutter Frontend & AWS-Hosted Backend

This project implements a login system for a patient-doctor app. The frontend is built using Flutter, and the backend is hosted on AWS, using Node.js with Express.js. 
The app supports Google and Facebook sign-in, along with manual email-password registration.

## Getting Started

### Step 1: Clone the Repository
You can use 'git clone' or github desktop.
`git clone https://github.com/IT21175466/My-Doctor.git`

### Step 2: Open the Frontend in Visual Studio Code
Open the 'fontend' folder in vs code.

### Step 3: Install Dependencies
Use 'flutter pub get'

### Step 4: Run the Flutter App
Connect an emulator or a physical device. (Android or IOS).
Functions are not working yet. Because we need to verify SHA-1 Key.

### Step 5: Verify or Update the SHA-1 Key in Firebase
To get the SHA-1 certificate, run the following command:

#### For windows
`keytool -list -v -alias androiddebugkey -keystore "C:\Users\<Your Username>\.android\debug.keystore"`

example - `keytool -list -v -alias androiddebugkey -keystore "C:\Users\Chamath Harshana\.android\debug.keystore"`

Password - `android`

#### For mac
`keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore`

Password - `android`

### Step 6: Copy the SHA-1 fingerprint in the output under 'Certificate fingerprints'
example - 30:13:D7:29:BC:C1:CA:C0:33:3B:CA:6B:69:A3:22:A5:92:B8:25:A2

### Step 7: Add the SHA-1 Certificate to Firebase
  1. Go to the Firebase Console. (I Invited your emails to my firebase project)
  2. Select your project. (MyDoctor)
  3. Navigate to Project Settings (click on the gear icon on the left menu).
  4. Scroll down to Your apps and select your Android app.
  5. Under SHA certificate fingerprints, click Add Fingerprint.
  6. Paste your new SHA-1 key and click Save.

### Step 8: Test the App
Test the functions using an emulator or a physical device. It working on both android and IOS platforms.


