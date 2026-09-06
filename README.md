<div align="center">

  # 💬 AuraChat

  **A Modern, Real-Time Messaging & HD WebRTC Audio/Video Calling App Built with Flutter & Firebase**

  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
  [![WebRTC](https://img.shields.io/badge/WebRTC-333333?style=for-the-badge&logo=webrtc&logoColor=white)](https://webrtc.org)
  [![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

</div>

---

## 🌟 Overview

**AuraChat** is a feature-rich, high-performance cross-platform application designed for seamless real-time communication. Engineered with **Flutter**, **Firebase Cloud Firestore**, **Firebase Authentication**, and **WebRTC**, AuraChat brings instant text messaging, presence tracking, read receipts, and high-definition audio & video calls to mobile devices.

Built with clean architecture principles, modern Material 3 design system, and Provider state management, AuraChat ensures rapid scalability, fast response times, and a stunning user experience.

---

## ✨ Key Features

- 🔐 **Secure Authentication**: 
  - Email & Password Sign Up and Sign In.
  - One-tap Google Sign-In integration.
  - Persistent user sessions with Firebase Auth.

- 💬 **Real-Time Messaging**:
  - Instant text communication powered by Cloud Firestore streams.
  - Unread message counters and automated read receipts (`isSeen`).
  - Sorted conversation threads based on recent activity.

- 📹 **HD Audio & Video Calling**:
  - High-definition 1-on-1 audio and video calls via `flutter_webrtc`.
  - In-call control suite: Toggle camera, mute/unmute microphone, switch camera direction, and toggle speaker output.
  - Active call timer, duration counter, and call state management.

- 📞 **Call Logs & History**:
  - Comprehensive history of incoming, outgoing, and missed calls.
  - Visual indicators for missed vs. connected calls and call types (Audio/Video).

- 🟢 **Live User Presence**:
  - Real-time online/offline status indicators across user lists and chat threads.

- 🎨 **Modern & Adaptive UI**:
  - Custom curated design system with Material 3 styling.
  - Custom color palette (`AppColors`) with soft indigo primary tones, slate calling backgrounds, and clean card surfaces.

---

## 🛠️ Tech Stack & Dependencies

- **Frontend Framework**: [Flutter](https://flutter.dev) (Dart SDK `^3.11.5`)
- **Backend & Database**: 
  - [Firebase Core](https://pub.dev/packages/firebase_core)
  - [Firebase Auth](https://pub.dev/packages/firebase_auth)
  - [Cloud Firestore](https://pub.dev/packages/cloud_firestore)
  - [Google Sign-In](https://pub.dev/packages/google_sign_in)
- **Real-Time Communication**: [flutter_webrtc](https://pub.dev/packages/flutter_webrtc)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Typography & Icons**: [Google Fonts](https://pub.dev/packages/google_fonts), Cupertino Icons

---

## 📂 Project Architecture

AuraChat follows a clean, modular structure organized by feature and layers:

```
lib/
├── auth/
│   ├── presentation/       # Login, Signup, Splash screens
│   └── provider/           # Login & Signup state management
├── core/
│   ├── providers/          # Global Auth, Home, Call Providers
│   ├── theme/              # AppColors & Material 3 ThemeData
│   ├── utils/              # Helper utilities & extensions
│   └── widgets/            # Reusable UI components
├── model/
│   ├── chat_thread_model.dart
│   ├── message_model.dart
│   └── user_model.dart
├── services/
│   ├── call_services.dart  # WebRTC signaling service
│   ├── chat_services.dart  # Real-time Firestore chat stream operations
│   └── firestore_services.dart
└── user/
    ├── call_log_screen/    # Call history views
    ├── call_screen/        # Incoming/Outgoing & Active Call Screen UI
    ├── chat_screen/        # Chat message list & input screen
    ├── home_screen/        # Recent chats tab & home layout
    ├── profile/            # User profile management
    └── users_screen/       # User directory & contact search
```

---

## 🚀 Getting Started

Follow these steps to get a local copy up and running.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.11.5`)
- [Dart SDK](https://dart.dev/get-started)
- [Android Studio](https://developer.android.com/studio) or [Xcode](https://developer.apple.com/xcode/) (for iOS builds)
- A [Firebase Project](https://console.firebase.google.com/)

---

### Installation Guide

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/chat_app.git
   cd chat_app
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Option 1: Use [FlutterFire CLI](https://firebase.google.com/docs/cli)
     ```bash
     npm install -g firebase-tools
     dart pub global activate flutterfire_cli
     flutterfire configure
     ```
   - Option 2: Manual setup
     - Add `google-services.json` to `android/app/`
     - Add `GoogleService-Info.plist` to `ios/Runner/`

4. **WebRTC Platform Setup**

   - **Android (`android/app/src/main/AndroidManifest.xml`)**:
     Ensure camera and microphone permissions are declared:
     ```xml
     <uses-permission android:name="android.permission.CAMERA" />
     <uses-permission android:name="android.permission.RECORD_AUDIO" />
     <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
     <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
     <uses-permission android:name="android.permission.INTERNET" />
     ```

   - **iOS (`ios/Runner/Info.plist`)**:
     Add permission strings for Camera and Microphone access:
     ```xml
     <key>NSCameraUsageDescription</key>
     <string>AuraChat requires access to your camera for video calls.</string>
     <key>NSMicrophoneUsageDescription</key>
     <string>AuraChat requires access to your microphone for audio and video calls.</string>
     ```

5. **Run the Application**
   ```bash
   flutter run
   ```

---

## 📸 Screen Preview

| Home & Recent Chats | Real-Time Chat | Audio / Video Calling | Call Logs |
| :---: | :---: | :---: | :---: |
| *Chat list with unread badges & online status* | *Instant messages with timestamps & read receipts* | *Full-screen WebRTC calling interface* | *Recent incoming, outgoing & missed calls* |

---

## 🤝 Contributing

Contributions make the open-source community an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

<div align="center">
  Crafted with ❤️ using <b>Flutter</b> & <b>Firebase</b>
</div>
