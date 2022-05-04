//************************************************************
// dht node to collect humid temp data in bed1 room (bed1)
//************************************************************
#include "painlessMesh.h"
#include "DHT.h"
#include "math.h"

#define MESH_PREFIX "tung"
#define MESH_PASSWORD "phuongtung0801"
#define MESH_PORT 5555

#define BED1_LAMP 5 // D1 pin NodeMCU

Scheduler userScheduler; // to control your personal task
painlessMesh mesh;

// Prototype
void receivedCallback(uint32_t from, String &msg);

void setup()
{
  Serial.begin(9600);
  delay(10);
  pinMode(BED1_LAMP, OUTPUT);

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
  if (msg == "bed1/lamp/on")
  {
    // Lamp bed1 room turn on
    Serial.println("Lamp bed1 room turn on");
    digitalWrite(BED1_LAMP, HIGH);
    return;
  }
  if (msg == "bed1/lamp/off")
  {
    // Lamp bed1 room turn on
    Serial.println("Lamp bed1 room turn off");
    digitalWrite(BED1_LAMP, LOW);
    return;
  }
}
