# build for macos
flutter build macos --release
mkdir -p build/macos/Build/Products/Release/dmg
ln -s /Applications build/macos/Build/Products/Release/dmg/Applications
cp -r build/macos/Build/Products/Release/MoneyJar.app build/macos/Build/Products/Release/dmg
hdiutil create -volname "MoneyJar" -srcfolder "build/macos/Build/Products/Release/dmg" -ov -format UDZO "build/macos/Build/Products/Release/MoneyJar.dmg"
rm -rf build/macos/Build/Products/Release/dmg
echo "Done, the DMG is located at build/macos/Build/Products/Release/MoneyJar.dmg"