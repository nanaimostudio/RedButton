#RedButton

#### Folder structure
* Arduino -- code on Arduino (both code and WiFi library)
* HardwareConnection -- images for hardware connection
* iPhone -- iPhone app controlled by Arduino button
* video -- video demo address

### How it works
First, connect Arduino UNO, WiFi Shield, Joystick Shield together
Basic idea:
* When you press a button on Joystick Shield, Arduino notice that change
* Arduino send the change to WiFi Shield
* WiFi Shield send out an UDP datagram to iPhone because of this change
* iPhone received UDP datagram
* iPhone handle the data and trigger the fire event

### How to use all this files?
Make sure you install Arduino IDE and Xcode. And connect Arduino, WiFi Shield, Joystick Shield together.
- Copy&Paste WiShield Folder under your Arduino libraries folder
- Using Arduino IDE to open the file in /UDPButtonControlOK/ folder, 
change the ip to your iPhone's ip in "uip_ipaddr(&addr, 192, 168, 1, 112);"
compile and upload it to your Arduino.
- In Xcode, open SpaceGame.xcodeproj under /iPhone/SpaceGame/ folder, compile and run it on your iPhone.
- Start firing when you press A button on Joystick Shield.
