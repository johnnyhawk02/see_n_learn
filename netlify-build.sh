#!/bin/bash

# Exit on error
set -e

# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"
flutter precache
flutter doctor

# Build web app
flutter build web --release