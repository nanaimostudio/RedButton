/*
* RedButtonAPI UDP Broadcast
*
* This program creat a local WiFi host named "RedButtonAPI"
* UDP Broadcast Joystick value and Button state through port 1234
*/

extern "C" {
   #include "uip.h"
}

#include <WiShield.h>
#include <stdio.h>
#include <stdlib.h>
//joystick data
int sensorValue1 = 0;
int sensorValue2 = 0;

int buttonA = 0;
int buttonB = 0;
int buttonC = 0;

int count = 0;
const int buttonAPin =  7;
const int buttonBPin =  6;
const int buttonCPin =  5;

// Wireless configuration parameters ----------------------------------------
unsigned char local_ip[] = {192,168,1,20};	// IP address of WiShield
unsigned char gateway_ip[] = {192,168,1,1};	// router or gateway IP address
unsigned char subnet_mask[] = {255,255,255,0};	// subnet mask for the local network
const prog_char ssid[] PROGMEM = {"RedButtonAPI"};		// max 32 bytes

unsigned char security_type = 2;	// 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2

// WPA/WPA2 passphrase
const prog_char security_passphrase[] PROGMEM = {"nanaimostudio"};	// max 64 characters

// WEP 128-bit keys
// sample HEX keys
prog_uchar wep_keys[] PROGMEM = {
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // Key 0
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // Key 1
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // Key 2
   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  // Key 3
};

// setup the wireless mode
// infrastructure - connect to AP
// adhoc - connect to another WiFi device
#define WIRELESS_MODE_INFRA 1
#define WIRELESS_MODE_ADHOC 2
unsigned char wireless_mode = WIRELESS_MODE_ADHOC;
unsigned char ssid_len;
unsigned char security_passphrase_len;
//---------------------------------------------------------------------------

void setup()
{
   WiFi.init();
}

void loop()
{
   WiFi.run();
   int tmp1 = analogRead(A1);
   sensorValue1 = map(tmp1, 0,1023,0,100);
   int tmp0 = analogRead(A0);
   sensorValue2 = map(tmp0, 0,1023,0,100);
   buttonA = digitalRead(buttonAPin);
   buttonB = digitalRead(buttonBPin);
   buttonC = digitalRead(buttonCPin);
  
}

extern "C"
{
   void udpapp_init(void)
   {
      uip_ipaddr_t addr;
      struct uip_udp_conn *c;
   
      //address of Ubuntu box (or send to address)
      uip_ipaddr(&addr, 255, 255, 255, 255);
      c = uip_udp_new(&addr, HTONS(1234));
      if(c != NULL) {
         uip_udp_bind(c, HTONS(1234));
      }
   }

   static void send_data(void)
   {
      //Serial.println("udpsample: sending data...");
//      char str[] = "udpsample: this is some UDP data...";
      char str[30];
      count ++;
      sprintf(str,"id=%i,%i,%i,%i,%i,%i,",count,buttonA,buttonB,buttonC,sensorValue1,sensorValue2);
      memcpy(uip_appdata, str, strlen(str));
      uip_send(uip_appdata, strlen(str));
   }

   void udpapp_appcall(void)
   {
      if(0 != uip_poll()) {
         send_data();
      }
   }   

   void dummy_app_appcall(void)
   {
   }   
}
