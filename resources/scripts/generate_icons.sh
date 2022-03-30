#!/bin/sh

# navigate to repo root from /resources/scripts
cd ../..
sh ./resources/scripts/clean.sh
flutter pub run flutter_launcher_icons:main
