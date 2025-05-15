# 📱 STRESS METER

**STRESS METER** is a powerful multilingual Flutter application that analyzes a user's **stress levels** using input from **text**, **voice**, and **facial expressions**. Built with advanced machine learning and signal processing techniques, this app helps users track and understand their emotional well-being in real-time — all from their mobile device.

---

## 🔗 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Architecture Overview](#architecture-overview)
- [File Structure](#file-structure)
- [Screenshots](#screenshots)
- [Why the App Size is Large](#why-the-app-size-is-large)
- [Why No Cloud Database](#why-no-cloud-database)
- [Contributing](#contributing)
- [License](#license)
- [Author](#author)

---

## ✨ Features

- 🧠 **Multimodal Stress Detection**:
  - **Text**: Analyzes sentiment using NLP models
  - **Voice**: Detects stress from tone, pitch, and frequency variations
  - **Face**: Classifies emotions through facial expression detection
- 🌐 **Multilingual Input** support for diverse user bases
- 📊 Real-time visual **stress level indicator**
- 📱 Optimized for mobile (runs offline using TFLite models)
- 🔒 **Privacy-first design**: No sensitive data sent to the cloud

---

## 🧰 Tech Stack

| Layer             | Tools / Frameworks                            |
|------------------|------------------------------------------------|
| UI/UX            | Flutter, Dart                                 |
| Machine Learning | TensorFlow Lite, On-device ML models          |
| Audio Processing | Google Speech-to-Text, Vosk                   |
| Face Detection   | OpenCV / Google ML Kit (TFLite converted)     |
| Text Analysis    | BERT / custom NLP model (TFLite format)       |
| Storage          | Local JSON/File Storage / Shared Preferences  |
| Languages        | i18n, Flutter localization                    |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed – [Install Flutter](https://flutter.dev/docs/get-started/install)
- Android Studio / Xcode (for iOS)
- Internet (for initial dependencies setup)

### 🔧 Setup Instructions

```bash
# Clone the repo
git clone https://github.com/jz6102/stress-meter.git
cd stress-meter

# Install dependencies
flutter pub get

# Run the app
flutter run
```

> Make sure your device/emulator has **camera** and **microphone** permissions enabled.

---

## 🧭 Architecture Overview

The project uses a **clean MVVM structure** for separation of concerns:

- **Model** – Holds data classes (stress score, sentiment result, etc.)
- **ViewModel** – Business logic, ML processing, state handling
- **View** – UI Widgets (screens, controls)
- **Services** – External integration (e.g., ML, camera, audio, speech)

---

## 📁 File Structure

```
lib/
├── main.dart
├── views/           # UI screens (home, results, etc.)
├── viewmodels/      # Logic & state controllers
├── services/        # ML model loading, camera, mic, NLP, etc.
├── models/          # Data classes (StressResult, InputType, etc.)
├── widgets/         # Reusable components (Meter, Charts)
├── utils/           # Constants, helpers, localization
├── assets/
│   ├── models/      # TFLite models (text, voice, face)
│   ├── images/      # Icons, graphics
│   └── languages/   # Localization files
```

---

## ⚖️ Why the App Size is ~400MB?

The app is large because it includes:

- Multiple **TFLite models** for offline processing
- Facial detection ML models with high accuracy
- Language packs for **multilingual support**
- No cloud reliance → **all processing is on-device**

This ensures **speed, privacy, and offline access** at the cost of size.

---

## 🛑 Why No Cloud Database?

- **Privacy-first approach**: Stress data is sensitive and remains on the device
- **Offline functionality**: Works without internet
- **Lightweight architecture**: Avoids external dependency and server costs

> Future versions may include optional cloud sync or analytics with consent.

---

## 🤝 Contributing

We welcome contributions from the community. To contribute:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/YourFeature`
3. Commit your changes: `git commit -m 'Add your feature'`
4. Push to the branch: `git push origin feature/YourFeature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## 👤 Author

**Jaikanna B**  
Flutter Developer  
📧 jaikanna777@gmail.com  
🔗 [GitHub](https://github.com/jz6102)

---

## ⭐ If You Like This Project...

Please consider giving it a ⭐ on [GitHub](https://github.com/jz6102/stress-meter)!
