//************************************************************
// dht node to collect humid temp data in bed2ing room (bed2ing)
//************************************************************
#include "painlessMesh.h"
#include "DHT.h"
#include "math.h"

#define MESH_PREFIX "tung"
#define MESH_PASSWORD "phuongtung0801"
#define MESH_PORT 5555

#define BED2_LAMP 5 // D1 pin NodeMCU

Scheduler userScheduler; // to control your personal task
painlessMesh mesh;

// Prototype
void receivedCallback(uint32_t from, String &msg);

void setup()
{
  Serial.begin(9600);
  delay(10);
  pinMode(BED2_LAMP, OUTPUT);

  mesh.setDebugMsgTypes(CONNECTION); // set before init() so that you can see startup messages

  mesh.init(MESH_PREFIX, MESH_PASSWORD, MESH_PORT, WIFI_STA, 6);
  mesh.onReceive(&receivedCallback);

  // Add the task to the your scheduler
  // userScheduler.addTask(myLoggingTask);
  // myLoggingTask.enable();
}

void loop()
{
  mesh.update();
}

void receivedCallback(uint32_t from, String &msg)
{
  Serial.printf("logClient: Received from %u msg=%s\n", from, msg.c_str());
  if (msg == "bed2/lamp/on")
  {
    // Lamp bed2 room turn on
    Serial.println("Lamp bed2 room turn on");
    digitalWrite(BED2_LAMP, HIGH);
    return;
  }
  if (msg == "bed2/lamp/off")
  {
    // Lamp bed2 room turn on
    Serial.println("Lamp bed2 room turn off");
    digitalWrite(BED2_LAMP, LOW);
    return;
  }
}
