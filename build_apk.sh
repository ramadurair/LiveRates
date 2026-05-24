#!/bin/bash
# ╔═══════════════════════════════════════════════════════════╗
# ║   LiveRates APK Builder — One-shot script                 ║
# ║   Builds a signed debug APK for Pixel 8a (arm64-v8a)     ║
# ╚═══════════════════════════════════════════════════════════╝
set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  LiveRates APK Builder${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# ── 1. Check Java ─────────────────────────────────────────────
if ! command -v java &>/dev/null; then
  echo -e "${RED}✗ Java not found. Install JDK 17+${NC}"
  echo "  macOS:   brew install openjdk@17"
  echo "  Ubuntu:  sudo apt install openjdk-17-jdk"
  exit 1
fi
JAVA_VER=$(java -version 2>&1 | head -1 | grep -oP '(?<=version ")[0-9]+' | head -1)
echo -e "${GREEN}✓ Java $JAVA_VER found${NC}"

# ── 2. Check/Set ANDROID_HOME ─────────────────────────────────
if [ -z "$ANDROID_HOME" ]; then
  # Common locations
  for p in "$HOME/Library/Android/sdk" "$HOME/Android/Sdk" "/usr/local/lib/android/sdk" "$HOME/.android/sdk"; do
    if [ -d "$p" ]; then ANDROID_HOME="$p"; break; fi
  done
fi

if [ -z "$ANDROID_HOME" ] || [ ! -d "$ANDROID_HOME" ]; then
  echo -e "${RED}✗ Android SDK not found.${NC}"
  echo ""
  echo "Install Android Studio: https://developer.android.com/studio"
  echo "Then set:  export ANDROID_HOME=~/Library/Android/sdk  (adjust path)"
  echo "Or run:    sdkmanager 'platforms;android-34' 'build-tools;34.0.0'"
  exit 1
fi
echo -e "${GREEN}✓ Android SDK: $ANDROID_HOME${NC}"

export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH"

# ── 3. Make gradlew executable ────────────────────────────────
if [ ! -f "gradlew" ]; then
  echo -e "${RED}✗ gradlew not found. Run this script from the project root.${NC}"
  exit 1
fi
chmod +x gradlew

# ── 4. Build ──────────────────────────────────────────────────
echo -e "\n${YELLOW}▶ Building APK (this takes 1-3 min on first run)…${NC}"
./gradlew assembleDebug --no-daemon 2>&1 | grep -E "BUILD|error:|Error|warn:|> Task" | head -40

# ── 5. Find the APK ───────────────────────────────────────────
APK=$(find . -name "*.apk" -path "*/debug/*" | grep -v "universal" | grep "arm64" | head -1)
if [ -z "$APK" ]; then
  APK=$(find . -name "*.apk" -path "*/debug/*" | head -1)
fi

if [ -z "$APK" ]; then
  echo -e "${RED}✗ Build failed — APK not found${NC}"
  echo "Run: ./gradlew assembleDebug for full output"
  exit 1
fi

echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ APK built successfully!${NC}"
echo -e "  📦 $APK"
SIZE=$(du -h "$APK" | cut -f1)
echo -e "  📏 Size: $SIZE"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# ── 6. Install if device connected ───────────────────────────
if command -v adb &>/dev/null && adb devices 2>/dev/null | grep -q "device$"; then
  echo -e "\n${YELLOW}▶ Pixel 8a detected, installing…${NC}"
  adb install -r "$APK" && echo -e "${GREEN}✓ Installed! Open 'LiveRates' on your phone.${NC}"
else
  echo -e "\n${YELLOW}To install on Pixel 8a:${NC}"
  echo "  1. Enable Developer Options → USB Debugging"
  echo "  2. Connect via USB"
  echo "  3. Run: adb install \"$APK\""
  echo "  Or: copy the APK to your phone and open it"
fi
