#!/bin/sh

(
  cd domain || exit
  flutter clean
  flutter pub get
)
(
  cd data || exit
  flutter clean
  flutter pub get
)
# clean lib
flutter clean
flutter pub get
