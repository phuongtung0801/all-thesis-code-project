//************************************************************
// dht node to collect humid temp data in living room (living)
//************************************************************
#include "painlessMesh.h"
#include "DHT.h"
#include "math.h"

#define MESH_PREFIX "tung"
#define MESH_PASSWORD "phuongtung0801"
#define MESH_PORT 5555

#define LIVING_LAMP 5 // D1 pin NodeMCU

Scheduler userScheduler; // to control your personal task
painlessMesh mesh;

// Prototype
void receivedCallback(uint32_t from, String &msg);
Task myLoggingTask(3000, TASK_FOREVER, []()
                   {
#if ARDUINOJSON_VERSION_MAJOR == 6
        DynamicJsonDocument jsonBuffer(1024);
        JsonObject msg = jsonBuffer.to<JsonObject>();
#else
        DynamicJsonBuffer jsonBuffer;
        JsonObject& msg = jsonBuffer.createObject();
#endif
    msg["nodename"] = "light_sensor";
    msg["nodeID"] = mesh.getNodeId();
    msg["topic"] = "living/light";
    msg["light"] = String(analogRead(A0));    

    String str;
#if ARDUINOJSON_VERSION_MAJOR == 6
    serializeJson(msg, str);
#else
    msg.printTo(str);
#endif
// send to root node
    mesh.sendSingle(2825211609, str);

  // log to serial
#if ARDUINOJSON_VERSION_MAJOR == 6
    serializeJson(msg, Serial);
#else
    msg.printTo(Serial);
#endif
    Serial.printf("\n"); });

void setup()
{
  Serial.begin(9600);
  delay(10);
  pinMode(A0, INPUT);
  pinMode(LIVING_LAMP, OUTPUT);
  mesh.setDebugMsgTypes(CONNECTION); // set before init() so that you can see startup messages
  mesh.init(MESH_PREFIX, MESH_PASSWORD, &userScheduler, MESH_PORT, WIFI_STA, 6);
  mesh.onReceive(&receivedCallback);

  // Add the task to the your scheduler
  userScheduler.addTask(myLoggingTask);
  myLoggingTask.enable();
}

void loop()
{
  userScheduler.execute(); // it will run mesh scheduler as well
  mesh.update();
}

void receivedCallback(uint32_t from, String &msg)
{
  Serial.printf("logClient: Received from %u msg=%s\n", from, msg.c_str());
  if (msg == "living/lamp/on")
  {
    // Lamp living room turn on
    Serial.println("Lamp living room turn on");
    digitalWrite(LIVING_LAMP, LOW);
    return;
  }
  if (msg == "living/lamp/off")
  {
    // Lamp living room turn on
    Serial.println("Lamp living room turn off");
    digitalWrite(LIVING_LAMP, HIGH);
    return;
  }
}
