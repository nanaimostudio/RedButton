#RedButton

#### Folder structure
* Arduino -- code on Arduino (both code and WiFi library)
* iPhone -- iPhone Space Shooter app 
* RedButtonAPI -- the iOS API to receive Arduino signal

### How it works
First, connect Arduino UNO, WiFi Shield, Joystick Shield together
Basic idea:
* When you press a button on Joystick Shield, Arduino notice that change and send the changes to WiFi Shield
* WiFi Shield send out UDP datagrams to iPhone to present each buttons' state
* iPhone received UDP datagram
* iPhone handle the data by using RedButtonAPI

### How to use all this files?
Make sure you install Arduino IDE and Xcode. And connect Arduino, WiFi Shield, Joystick Shield together.
- Copy & Paste WiShield Folder under your Arduino libraries folder
- Using Arduino IDE to open the file in Arduino/RedButtonAPI/ folder, compile and upload it to your Arduino.
- In Xcode, open SpaceGame.xcodeproj under /iPhone/SpaceGame/ folder, compile and run it on your iPhone.
- On your iPhone's settings, selected WiFi Network named "RedButtonAPI"
- Use the Joystick to control your iPhone game !
