# System Info App

Eine Flutter-App, die Systeminformationen ähnlich wie `fastfetch` anzeigt. Funktioniert auf iOS und Android mit automatisierten GitHub Actions Builds.

## Features

✨ **Umfassende Systeminformationen:**

- Device-Infos (Hersteller, Modell, Name)
- OS-Informationen (Name, Version, API-Level)
- Hardware-Details (CPU-Kerne, RAM, Speichernutzung)
- Battery & Connectivity Status
- App-Version und Build-Number
- System-Uptime, Timezone, Locale

📊 **Live-Updates:**
- Automatische Aktualisierung alle 5 Sekunden
- Pull-to-Refresh Funktion
- Memory-Nutzungs-Visualisierung

🎨 **Schönes Design:**

- Material Design 3
- Dark/Light Mode Support
- Responsive Layout

## Setup auf Windows

### 1. Flutter installieren

```bash
# Download von https://flutter.dev/docs/get-started/install/windows
# Oder mit Chocolatey:
choco install flutter

# Prüfe Installation
flutter doctor
```

### 2. Projekt klonen/erstellen

```bash
# Wenn du das Projekt kopiert hast:
cd system_info_app

# Dependencies installieren
flutter pub get
```

### 3. Lokal testen (Android Emulator)

```bash
# Starte Android Emulator (Android Studio)
# Oder: flutter emulators --launch <emulator_id>

# App starten
flutter run
```

## GitHub Actions Setup (für iOS Builds)

### 1. Repo auf GitHub erstellen

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/dein-username/system_info_app.git
git branch -M main
git push -u origin main
```

### 2. GitHub Secrets konfigurieren (optional für CodeSign)

Für späteren produktiven Build mit Code Signing:
- Geh zu `Settings → Secrets and variables → Actions`
- Füge folgende Secrets hinzu (wenn nötig):
  - `BUILD_CERTIFICATE_BASE64` - dein Apple Dev Certificate
  - `P12_PASSWORD` - Password für Certificate
  - `BUILD_PROVISION_PROFILE_BASE64` - Provisioning Profile
  - `KEYCHAIN_PASSWORD` - für Keychain Access

### 3. Workflow triggern

Der Workflow startet automatisch bei jedem Push zu `main` oder `develop`.

Oder manuell triggern:
- Geh zu `Actions` tab in GitHub
- Wähle einen Workflow
- Klick "Run workflow"

## Lokale Builds

### iOS (auf Mac)

```bash
# Debug Build
flutter build ios --debug

# Release Build
flutter build ios --release

# Öffne in Xcode für detaillierte Kontrolle
open ios/Runner.xcworkspace
```

### Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (für Play Store)
flutter build appbundle --release
```

## Projekt-Struktur

```
system_info_app/
├── lib/
│   ├── main.dart                    # App Entry Point
│   ├── models/
│   │   └── system_info_model.dart   # Data Model
│   ├── services/
│   │   └── system_info_service.dart # Daten sammeln
│   └── screens/
│       └── system_info_screen.dart  # UI
├── .github/
│   └── workflows/
│       ├── build-ios.yml            # iOS CI/CD
│       └── build-android.yml        # Android CI/CD
├── pubspec.yaml                     # Dependencies
└── README.md                        # Diese Datei
```

## Dependencies

- **device_info_plus** - Geräte-Informationen
- **battery_plus** - Battery Status
- **connectivity_plus** - Netzwerk-Status
- **package_info_plus** - App-Infos
- **intl** - Lokalisierung

## Development

### Neuen Screen hinzufügen

```dart
// lib/screens/new_screen.dart
import 'package:flutter/material.dart';

class NewScreen extends StatefulWidget {
  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Screen')),
      body: Center(child: Text('Hello')),
    );
  }
}
```

### Tests ausführen

```bash
# Unit Tests
flutter test

# Integration Tests
flutter test integration_test/
```

## Troubleshooting

### Flutter nicht erkannt
```bash
# PATH aktualisieren
echo 'export PATH="$PATH:[FLUTTER_PATH]/bin"' >> ~/.bashrc
source ~/.bashrc
flutter doctor
```

### Dependency Issues
```bash
flutter clean
flutter pub get
```

### iOS Build fehlgeschlagen
```bash
cd ios
pod install --repo-update
cd ..
flutter build ios --release
```

### GitHub Actions Fehler
- Logs prüfen: `Actions → Workflow Run → Build Job`
- Runner-Log anschauen für spezifische Fehler

## Distribution

### Play Store (Android)
1. App Bundle bauen: `flutter build appbundle --release`
2. In Google Play Console hochladen
3. Infos ausfüllen und veröffentlichen

### App Store (iOS)
1. In Xcode öffnen und Code Signing konfigurieren
2. Archive erstellen
3. Zu App Store Connect hochladen via Xcode Organizer

## Performance-Tipps

- Memory Refresh-Intervall anpassen (derzeit 5 Sekunden)
- Alte System-Info Daten cachen
- Build-Größe mit `flutter build apk --split-per-abi` reduzieren

## Lizenz

MIT - Frei verwendbar für private und kommerzielle Projekte

## Support

Bei Fragen oder Problemen:
1. Flutter Docs: https://flutter.dev/docs
2. GitHub Issues erstellen
3. Stack Overflow mit Tag `flutter`
