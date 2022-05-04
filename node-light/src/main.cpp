//************************************************************
// light sensor node to control lamp at front door (yard)
//************************************************************
#include <painlessMesh.h>
#include <Arduino.h>

#define MESH_PREFIX "tung"
#define MESH_PASSWORD "phuongtung0801"
#define MESH_PORT 5555

#define LED D0
#define LED1 D3
#define LAMP D4
#define LAMP_SW D5
bool LAMP_STATE = HIGH;

Scheduler userScheduler; // to control your personal task
painlessMesh mesh;

// Prototype
void receivedCallback(uint32_t from, String &msg);
void lampSwitch();

size_t logServerId = 0;

// Send message to the logServer every 10 seconds
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
    msg["topic"] = "light";
    msg["light"] = String(analogRead(A0));    

    String str;
#if ARDUINOJSON_VERSION_MAJOR == 6
    serializeJson(msg, str);
#else
    msg.printTo(str);
#endif
    if (logServerId == 0) // If we don't know the logServer yet
        mesh.sendBroadcast(str);
    else
        mesh.sendSingle(logServerId, str);
    // check light sensor to control light
    if (analogRead(A0) < 500 && LAMP_STATE == 1 )
    {
      digitalWrite(LAMP, LOW);
    }
    else if (analogRead(A0) > 500 && LAMP_STATE == 1 )
    {
      digitalWrite(LAMP, HIGH);
    }

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
  pinMode(A0, INPUT);
  pinMode(LED1, OUTPUT);
  pinMode(LED, OUTPUT);
  mesh.setDebugMsgTypes(ERROR | STARTUP | CONNECTION); // set before init() so that you can see startup messages

  mesh.init(MESH_PREFIX, MESH_PASSWORD, &userScheduler, MESH_PORT, WIFI_AP_STA, 6);
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
  // String cmd = String(msg);
  if (msg == "/yard/lamp/off")
  {
    digitalWrite(LED, HIGH);
    return;
  } // LED off
  if (msg == "/yard/lamp/on")
  {
    digitalWrite(LED, LOW);
    return;
  }
  if (msg == "/yard/lamp/state off")
  {
    LAMP_STATE = 0;
    return;
  }
  else if (msg == "/yard/lamp/state on")
  {
    LAMP_STATE = 1;
    return;
  } // LED on
  // Saving logServer
#if ARDUINOJSON_VERSION_MAJOR == 6
  DynamicJsonDocument jsonBuffer(1024 + msg.length());
  DeserializationError error = deserializeJson(jsonBuffer, msg);
  if (error)
  {
    Serial.printf("DeserializationError\n");
    return;
  }
  JsonObject root = jsonBuffer.as<JsonObject>();
#else
  DynamicJsonBuffer jsonBuffer;
  JsonObject &root = jsonBuffer.parseObject(msg);
#endif
  if (root.containsKey("topic"))
  {
    if (String("logServer").equals(root["topic"].as<String>()))
    {
      // check for on: true or false
      logServerId = root["nodeId"];
      Serial.printf("logServer detected!!!\n");
    }
    else if (String("exeNode").equals(root["topic"].as<String>()))
    {
      String exeCmd = root["exeCmd"].as<String>();
      if (exeCmd == "1")
      {
        digitalWrite(4, HIGH);
        Serial.printf("Turn on LED !");
      }
      else
      {
        digitalWrite(4, LOW);
        Serial.printf("Turn off LED !");
      }
    }
    Serial.printf("Handled from %u msg=%s\n", from, msg.c_str());
  }
}