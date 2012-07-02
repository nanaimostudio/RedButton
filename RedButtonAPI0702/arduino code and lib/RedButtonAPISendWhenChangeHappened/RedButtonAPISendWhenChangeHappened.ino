




/*
* UDP endpoint
*
* A simple UDP endpoint example using the WiShield 1.0
*/

extern "C" {
   #include "uip.h"
}
#include <WiShield.h>
//joystick data
int sensorValue1 = 0;
int sensorValue2 = 0;
//button data
int buttonStateA = 0;
int buttonStateB = 0;
int buttonStateC = 0;
const int buttonAPin =  7;
const int buttonBPin =  6;
const int buttonCPin =  5;
int count = 1;

// Wireless configuration parameters ----------------------------------------
unsigned char local_ip[] = {192,168,1,20};	// IP address of WiShield
unsigned char gateway_ip[] = {192,168,1,1};	// router or gateway IP address
unsigned char subnet_mask[] = {255,255,255,0};	// subnet mask for the local network
const prog_char ssid[] PROGMEM = {"LELE"};		// max 32 bytes

unsigned char security_type = 2;	// 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2

// WPA/WPA2 passphrase
const prog_char security_passphrase[] PROGMEM = {"xingjizhengba2"};	// max 64 characters

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
unsigned char wireless_mode = WIRELESS_MODE_INFRA;
unsigned char ssid_len;
unsigned char security_passphrase_len;
//---------------------------------------------------------------------------

void setup()
{
   WiFi.init();
   Serial.begin(9600);
}

void loop()
{
   WiFi.run();
   buttonStateA = digitalRead(buttonAPin);
   buttonStateB = digitalRead(buttonBPin);
   buttonStateC = digitalRead(buttonCPin);
   sensorValue1 = map (analogRead(A1),0,1023,0,100);
   sensorValue2 = map (analogRead(A0),0,1023,0,100);
}

extern "C"
{
   void udpapp_init(void)
   {
      uip_ipaddr_t addr;
      struct uip_udp_conn *c;
      uip_ipaddr(&addr, 255,255,255,255);
      c = uip_udp_new(&addr, HTONS(1234));
      if(c != NULL) {
         uip_udp_bind(c, HTONS(1234));
      }
   }
   static void send_data(void)
   {
     char msg[50]="";  
     count++;
     sprintf(msg,"id=%i,%i,%i,%i,%i,%i",count,buttonStateA,buttonStateB,buttonStateC,sensorValue1,sensorValue2);
     uip_send(msg, strlen(msg));   
 
   }
   void udpapp_appcall(void)
   {
     //uip_poll()
     //Is non-zero if the reason the application is invoked 
     //is that the current connection has been idle for a while and should be polled.
      if(0 != uip_poll()) {
         send_data();
      }
   }   
   void dummy_app_appcall(void)
   {
   }   
}
