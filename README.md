# 💱 LiveRates — Currency App for Pixel 8a

A lightweight, standalone Android app that fetches live exchange rates for up to **10 currencies** using the free **Frankfurter API** (European Central Bank data — no API key, no account required).

---

## ✨ Features

| Feature | Details |
|---|---|
| **Live rates** | ECB reference rates via `api.frankfurter.dev` (updates ~16:00 CET daily) |
| **Up to 10 currencies** | Pick any from 30 supported currencies |
| **Quick Converter** | Instant conversion between any two currencies |
| **Remembers your picks** | Base currency + selected currencies saved locally |
| **Auto-refresh** | Refreshes every 5 min while app is open |
| **Dark UI** | Dark theme, optimised for Pixel 8a screen |
| **No login, no ads, no tracking** | Fully standalone |

---

## 🚀 Build the APK (3 steps)

### Prerequisites
- **JDK 17+** — [Download](https://adoptium.net/)
- **Android Studio** (for the Android SDK) — [Download](https://developer.android.com/studio)
  - After install, SDK is at `~/Library/Android/sdk` (Mac) or `~/Android/Sdk` (Linux/Windows)

### Step 1 — Clone / unzip the project
```bash
cd ~/Desktop
unzip LiveRates-android.zip   # or wherever you put it
cd CurrencyApp
```

### Step 2 — Set ANDROID_HOME (if not already)
```bash
# macOS
export ANDROID_HOME=~/Library/Android/sdk

# Linux
export ANDROID_HOME=~/Android/Sdk

# Windows (PowerShell)
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
```

### Step 3 — Build
```bash
# Mac / Linux
chmod +x build_apk.sh && ./build_apk.sh

# Or directly with Gradle
chmod +x gradlew && ./gradlew assembleDebug
```

The APK will be at:
```
app/build/outputs/apk/debug/app-arm64-v8a-debug.apk
```

---

## 📲 Install on Pixel 8a

### Option A — USB (fastest)
1. On your Pixel 8a: **Settings → About phone → tap Build number 7 times**
2. **Settings → Developer options → USB debugging ON**
3. Connect USB cable
```bash
adb install app/build/outputs/apk/debug/app-arm64-v8a-debug.apk
```

### Option B — Wi-Fi / File transfer
1. Copy the APK to your phone (Google Drive, USB, email)
2. Open the APK on your phone → tap **Install**
3. If prompted: Settings → Install unknown apps → allow for your file manager

---

## 🏗 Project Structure

```
CurrencyApp/
├── app/src/main/
│   ├── AndroidManifest.xml          # App permissions + config
│   ├── java/com/currencyapp/
│   │   └── MainActivity.java        # WebView host
│   ├── assets/
│   │   └── index.html               # Full app (HTML/CSS/JS)
│   └── res/
│       ├── values/styles.xml        # Dark theme
│       └── mipmap-*/                # Launcher icons
├── app/build.gradle                 # Build config
├── build.gradle                     # Root config
├── settings.gradle
├── gradlew                          # Gradle wrapper
└── build_apk.sh                     # One-shot build script
```

---

## 🔑 API Used

**Frankfurter** — `https://api.frankfurter.dev/v2/rates`
- ✅ Free forever, no API key
- ✅ ECB data (30+ currencies)
- ✅ No rate limits for normal use
- ℹ️ Rates update once per business day (~16:00 CET)

---

## 🛠 Troubleshooting

**"Build failed: SDK location not found"**
→ Set `ANDROID_HOME` as shown above, or create `local.properties`:
```
sdk.dir=/path/to/your/Android/sdk
```

**"Unable to install: INSTALL_FAILED_TEST_ONLY"**
→ Use `adb install -t` flag: `adb install -t app-arm64-v8a-debug.apk`

**App shows "No data"**
→ Tap Refresh — rates require an internet connection to fetch

**Rates look old**
→ ECB updates once daily. The timestamp shows when rates were fetched.
