<script>
  import { onMount } from "svelte";
  import { onDestroy } from "svelte";
  import mqttSubscribeMessage from "../stores/mqttDataReceive";
  import websocketConnect from "../stores/websocketConnect";
  const websocket = websocketConnect;
  var url = "ws://192.168.137.8/ws";
  var output;
  // var button;
  var canvas;
  var context;
  let subscribeMessage;

  // onMount conponent run connect websocket when render to DOM
  onMount(() => {
    init();
  });
  //close ws connection when destroy component
  onDestroy(() => {
    // websocket.close();
    console.log("Ondestroy function executed");
  });

  // const websocket = new WebSocket(url);
  const onClick = () => {
    console.log("OnPress nek");
    init();
  };
  // This is called when the page finishes loading
  function init() {
    // Assign page elements to variables
    // button = document.getElementById("toggleButton");
    output = document.getElementById("output");
    canvas = document.getElementById("led");

    // Draw circle in canvas
    context = canvas.getContext("2d");
    context.arc(25, 25, 15, 0, Math.PI * 2, false);
    context.lineWidth = 3;
    context.strokeStyle = "black";
    context.stroke();
    context.fillStyle = "black";
    context.fill();

    // Connect to WebSocket server
    wsConnect(url);
    console.log("Init ws");
  }

  // Call this to connect to the WebSocket server
  function wsConnect(url) {
    // Connect to WebSocket server
    // websocket = new WebSocket(url);

    // Assign callbacks
    websocket.onopen = function (evt) {
      onOpen(evt);
    };
    websocket.onclose = function (evt) {
      onClose(evt);
    };
    websocket.onmessage = function (evt) {
      onMessage(evt);
    };
    websocket.onerror = function (evt) {
      onError(evt);
    };
  }

  // Called when a WebSocket connection is established with the server
  function onOpen(evt) {
    // Log connection state
    console.log("Connected");

    // Enable button
    // button.disabled = false;

    // Get the current state of the LED
    doSend("getLEDState");
  }

  // Called when the WebSocket connection is closed
  function onClose(evt) {
    // Log disconnection state
    console.log("Disconnected WebSocket");

    // Disable button
    // button.disabled = true;

    // Try to reconnect after a few seconds
    setTimeout(function () {
      wsConnect(url);
    }, 2000);
  }

  // Called when a message is received from the server
  function onMessage(evt) {
    // Print out our received message
    console.log("Received: " + evt.data);
    //jsonMsg has data: {"topic":"topicName","msg":"msgContent" }
    let jsonMsg = JSON.parse(evt.data);
    console.log(jsonMsg);
    console.log(jsonMsg.topic);
    console.log(jsonMsg.msg);
    if (jsonMsg.topic != "led_state") {
      mqttSubscribeMessage.update((msg) => {
        return [
          ...msg,
          {
            topic: jsonMsg.topic,
            message: jsonMsg.msg,
            status: "receive message",
          },
        ];
      });
    }

    // Update circle graphic with LED state
    switch (jsonMsg.msg) {
      case "zero":
        console.log("LED is off");
        context.fillStyle = "black";
        context.fill();
        break;
      case "one":
        console.log("LED is on");
        context.fillStyle = "red";
        context.fill();
        break;
      default:
        break;
    }
  }

  // Called when a WebSocket error occurs
  function onError(evt) {
    console.log("ERROR: " + evt.data);
  }

  // Sends a message to the server (and prints it to the console)
  function doSend(message) {
    console.log("Sending: " + message);
    websocket.send(message);
  }

  // Called whenever the HTML button is pressed
  const onPress = () => {
    console.log(websocket);
    doSend("toggleLED");
    doSend("getLEDState");
  };

  // Call the init function as soon as the page loads
  // window.addEventListener("load", init);
</script>

<!-- Section 1 -->
<section
  class="py-8 leading-7 text-gray-900 bg-white sm:py-12 md:py-16 lg:py-24"
>
  <div class="max-w-6xl px-4  mx-auto border-solid lg:px-12">
    <div
      class="flex flex-col items-start leading-7 text-gray-900 border-0 border-gray-200 lg:items-center lg:flex-row"
    >
      <div class="box-border flex-1 text-center border-solid sm:text-left">
        <h2
          class="m-0 text-2xl font-semibold  tracking-tight text-left text-black border-0 border-gray-200"
        >
          WEBSOCKET CONNECTION
        </h2>
        <p
          class="mt-2 text-xl text-left text-gray-900 border-0 border-gray-200 sm:text-2xl"
        >
          Control and display LED status through WebSocket
        </p>
      </div>
      <button
        on:click={onClick}
        class="bg-red-400 mx-3 hover:bg-red-500 text-white font-bold py-2 px-4 rounded inline-flex items-center"
      >
        <span>Connect</span>
      </button>
      <button
        on:click|preventDefault={onPress}
        class=" bg-gray-300 mx-3 hover:bg-gray-400 text-gray-800 font-bold py-2 px-4 rounded inline-flex items-center"
      >
        <span>Toggle LED</span>
      </button>

      <td><canvas id="led" width="50" height="50" /></td>
    </div>
  </div>
</section>
