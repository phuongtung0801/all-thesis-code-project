//************************************************************
// dht node to collect humid temp data in living room (living)
//************************************************************
#include "painlessMesh.h"
#include "DHT.h"
#include "math.h"

#define MESH_PREFIX "tung"
#define MESH_PASSWORD "phuongtung0801"
#define MESH_PORT 5555

#define LED D0

Scheduler userScheduler; // to control your personal task
painlessMesh mesh;

// Prototype
void receivedCallback(uint32_t from, String &msg);
void calculateRTT(unsigned int currentTime, unsigned int previousTime, unsigned int count);

unsigned int previousTime = 0;
unsigned int currentTime = 0;
unsigned int previousTimeLoop = 0;
unsigned int count = 0;
unsigned int countSend = 0;

// Task myLoggingTask(1000, TASK_FOREVER, []()
//                    {
//                      previousTime = millis();
//                      //send 64byte each
//                      mesh.sendBroadcast("fwefwefwevevasdvsavasdvsadvsdcsadwvervadvasđvsadcâcsdcasdvervew");
//                      Serial.printf("Sending package %d\n",countSend);
//                      countSend++; });

void setup()
{
  Serial.begin(9600);
  // delay(10);
  // WiFi.begin("TUNG", "123456789");
  // while (WiFi.status() != WL_CONNECTED)
  // {
  //   delay(1000);
  //   Serial.println("Leaf Connecting to WiFi..");
  // }
  // Serial.println("Connected to the WiFi network");
  // Serial.println(WiFi.localIP());

  mesh.setDebugMsgTypes(CONNECTION); // set before init() so that you can see startup messages

  mesh.init(MESH_PREFIX, MESH_PASSWORD, MESH_PORT, WIFI_AP_STA, 6);
  mesh.onReceive(&receivedCallback);

  // Add the task to the your scheduler
  // userScheduler.addTask(myLoggingTask);
  // myLoggingTask.enable();
}

void loop()
{
  // userScheduler.execute(); // it will run mesh scheduler as well
  mesh.update();
  static uint32_t currentTimeLoop = millis();
  // 350 package send (program)
  if (millis() - currentTimeLoop > 3000000)
  {
    Serial.print("Packet loss leaf test done");
    Serial.println("...");
    Serial.println("...");
    Serial.println("...");
    Serial.println("...");
    currentTimeLoop = millis();
    return;
  }
}

void receivedCallback(uint32_t from, String &msg)
{
  Serial.printf("logClient: Received from %u msg=%s\n", from, msg.c_str());
  // forward to root
  mesh.sendSingle(2825211609, "fwefwefwevevasdvsavasdvsadvsdcsadwvervadvasđvsadcâcsdcasdvervew");
  // currentTime = millis();
  // // print RTT of each msg send and response

  // Serial.printf("RTT Time %d is: ", count);
  // Serial.println(currentTime - previousTime);
  // count++;
  // calculateRTT(currentTime, previousTime, count);
  // Serial.println();
}

// note la bien count chay tu 1
void calculateRTT(unsigned int currentTime, unsigned int previousTime, unsigned int count)
{
  Serial.println("calculateRTT");
  // khoi tao gia tri RTT vong dau tien
  int roundTripTime = currentTime - previousTime;
  // array de luu RTT, 300 phan tu gui trong 5ph
  static unsigned int arrayRTT[310];
  // RTT thu count luu vao mang
  arrayRTT[count] = roundTripTime;

  // gan gia tri dau tien cho max va min
  static unsigned int max = arrayRTT[1];
  static unsigned int min = arrayRTT[1];
  // for loop through array

  if (arrayRTT[count] - min > 42949672)
  {
    min = arrayRTT[count];
  }
  if (arrayRTT[count] >= max)
  {
    max = arrayRTT[count];
  }
  Serial.printf("min RTT is: %d\n", min);
  Serial.printf("max RTT is: %d\n", max);
  // tinh RTT trung binh
  double sumRTT = 0;
  for (size_t i = 0; i <= count; i++)
  {
    sumRTT += (double)arrayRTT[i];
  }
  double averageRTT = sumRTT / (double)(count);
  Serial.printf("Average RTT is: %f \n", averageRTT);
}
