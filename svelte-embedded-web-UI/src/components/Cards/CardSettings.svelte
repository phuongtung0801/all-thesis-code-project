<script>
  import mqttSetting from "../card-settings";
  import { useNavigate } from "svelte-navigator";
  import mqttSubscribeMessage from "../../stores/mqttDataReceive";
  let mqttServer;
  let mqttUsername;
  let mqttPassword;
  let mqttClientID;
  let mqttPort = 8883;
  let activeButton = false;
  let wifiActiveButton = false;

  //wifi infor
  let ssid;
  let ssid_password;

  //publish subscribe
  let subscribeTopic;
  let publishTopic;
  let publishMessage;

  //send POST mqtt connect to server
  let formData = new URLSearchParams();
  const sendPost = async () => {
    formData.append("mqttServer", mqttServer);
    formData.append("mqttUsername", mqttUsername);
    formData.append("mqttPassword", mqttPassword);
    formData.append("mqttClientID", mqttClientID);
    formData.append("mqttPort", mqttPort);
    let response = await fetch("http://192.168.137.8/mqtt", {
      credentials: "include",
      method: "POST",
      body: formData,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    });
    let data = await response.json();
    //if connected mqtt, handle these
    if ((data.status = "ok")) {
      console.log("Success: ", data);
      //set store variable
      mqttSetting.set({
        server: mqttServer,
        username: mqttUsername,
        password: mqttPassword,
        clientID: mqttClientID,
        port: mqttPort,
        status: "Connected",
      });
      console.log(mqttSetting.server);
      activeButton = true;
    } else {
      console.log("Some thing wrong in login");
      console.log(data);
      activeButton = false;
    }
  };

  //send subscribe topic POST
  let subscribeTopicForm = new URLSearchParams();
  const subscribeFunction = async () => {
    subscribeTopicForm.append("topic subscribed", subscribeTopic);
    let response = await fetch("http://192.168.137.8/subscribe", {
      credentials: "include",
      method: "POST",
      body: subscribeTopicForm,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    });
    let data = await response.json();
    //if connected mqtt, handle these
    if ((data.status = "ok")) {
      console.log("Success to subscribe to " + subscribeTopic);
    } else {
      console.log("Some thing wrong in subscribe");
      console.log(data);
    }
  };

  //send wifi ssid and password POST
  let wifiInfor = new URLSearchParams();
  const wifiFunction = async () => {
    wifiInfor.append("ssid", ssid);
    wifiInfor.append("ssid_password", ssid_password);
    let response = await fetch("http://192.168.137.8/wifi", {
      credentials: "include",
      method: "POST",
      body: wifiInfor,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    });
    let data = await response.json();
    //if connected mqtt, handle these
    if ((data.status = "ok")) {
      console.log("Success to connect wifi to " + ssid);
      wifiActiveButton = true;
    } else {
      console.log("Some thing wrong in wifi");
      console.log(data);
      wifiActiveButton = false;
    }
  };

  //send publish topic POST
  let publishTopicForm = new URLSearchParams();
  const publishFunction = async () => {
    publishTopicForm.append("topic publish to", publishTopic);
    publishTopicForm.append("publish message", publishMessage);
    let response = await fetch("http://192.168.137.8/publish", {
      credentials: "include",
      method: "POST",
      body: publishTopicForm,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    });
    let data = await response.json();
    //if connected mqtt, handle these
    if ((data.status = "ok")) {
      console.log("Success publish message to " + publishTopic);
      console.log(publishMessage);
      mqttSubscribeMessage.update((msg) => {
        return [
          ...msg,
          {
            topic: publishTopic,
            message: publishMessage,
            status: "publish message",
          },
        ];
      });
    } else {
      console.log("Some thing wrong in publish");
      console.log(data);
    }
  };
</script>

<div
  class="relative flex flex-col min-w-0 break-words w-full mb-6 shadow-lg rounded-lg bg-blueGray-100 border-0"
>
  <div class="rounded-t bg-red-400 mb-0 px-6 py-6">
    <div class="content-center text-center flex justify-between">
      <h6 class=" w-full text-white text-xl font-bold">MY SETTINGS</h6>
    </div>
  </div>
  <div class="flex-auto px-4 lg:px-10 py-10 pt-0">
    <form>
      <h6 class="text-blueGray-400 text-base mt-3 mb-6 font-bold uppercase">
        MQTT connection
      </h6>
      <div class="text-center items-end flex justify-between">
        <hr />
        <button
          class:active={activeButton}
          class="bg-red-400 text-white active:bg-red-500 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-md outline-none focus:outline-none mr-1 ease-linear transition-all duration-150"
          type="button"
          on:click={sendPost}
        >
          {#if activeButton}
            Connected
          {:else}
            Connect to MQTT Broker
          {/if}

          <!-- Connect to Broker -->
        </button>
      </div>
      <div class="flex flex-wrap">
        <div class="w-full lg:w-6/12 px-4">
          <div class="relative w-full mb-3">
            <label
              class="block uppercase text-blueGray-600 text-sm font-bold mb-2"
              for="grid-username"
            >
              Broker
            </label>
            <input
              id="grid-username"
              type="text"
              class="border-0 px-3 py-3 placeholder-blueGray-300 text-blueGray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
              bind:value={mqttServer}
            />
          </div>
        </div>
        <div class="w-full lg:w-6/12 px-4">
          <div class="relative w-full mb-3">
            <label
              class="block uppercase text-blueGray-600 text-sm font-bold mb-2"
              for="grid-email"
            >
              Username
            </label>
            <input
              id="grid-email"
              type="email"
              class="border-0 px-3 py-3 placeholder-blueGray-300 text-blueGray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
              bind:value={mqttUsername}
            />
          </div>
        </div>
        <div class="w-full lg:w-6/12 px-4">
          <div class="relative w-full mb-3">
            <label
              class="block uppercase text-blueGray-600 text-sm font-bold mb-2"
              for="grid-first-name"
            >
              Password
            </label>
            <input
              id="grid-first-name"
              type="text"
              class="border-0 px-3 py-3 placeholder-blueGray-300 text-blueGray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
              bind:value={mqttPassword}
            />
          </div>
        </div>
        <div class="w-full lg:w-6/12 px-4">
          <div class="relative w-full mb-3">
            <label
              class="block uppercase text-blueGray-600 text-sm font-bold mb-2"
              for="grid-last-name"
            >
              Client ID
            </label>
            <input
              id="grid-last-name"
              type="text"
              class="border-0 px-3 py-3 placeholder-blueGray-300 text-blueGray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
              bind:value={mqttClientID}
            />
          </div>
        </div>
      </div>
    </form>

    <form>
      <h6 class="text-blueGray-400 text-base mt-3 mb-6 font-bold uppercase">
        Topic and Message
      </h6>
      <div class="text-center items-end flex justify-between">
        <hr />
        <button
          class="bg-red-400 text-white active:bg-red-500 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-md outline-none focus:outline-none mr-1 ease-linear transition-all duration-150"
          type="button"
          on:click={subscribeFunction}
        >
          Subscribe
          <!-- Connect to Broker -->
        </button>
      </div>
      <div class="w-full lg:w-6/12 px-4">
        <div class="relative w-full mb-3">
          <label
            class="block uppercase text-blueGray-600 text-sm font-bold mb-2"
            for="grid-first-name"
          >
            Topic to subscribe
          </label>
          <input
            id="grid-first-name"
            type="text"
            class="border-0 px-3 py-3 placeholder-blueGray-300 text-blueGray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
            bind:value={subscribeTopic}
          />
        </div>
      </div>
      <div class="text-center items-end flex justify-between">
        <hr />
        <button
          class="bg-red-400 text-white active:bg-red-500 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-md outline-none focus:outline-none mr-1 ease-linear transition-all duration-150"
          type="button"
          on:click={publishFunction}
        >
          Publish
          <!-- Connect to Broker -->
        </button>
      </div>
      <div class="flex flex-wrap">
        <div class="w-full lg:w-6/12 px-4">
          <div class="relative w-full mb-3">
            <label
              class="block uppercase text-blueGray-600 text-sm font-bold mb-2"
              for="grid-username"
            >
              Topic to publish
            </label>
            <input
              id="grid-username"
              type="text"
              class="border-0 px-3 py-3 placeholder-blueGray-300 text-blueGray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
              bind:value={publishTopic}
            />
          </div>
        </div>
        <div class="w-full lg:w-6/12 px-4">
          <div class="relative w-full mb-3">
            <label
              class="block uppercase text-blueGray-600 text-sm font-bold mb-2"
              for="grid-email"
            >
              Message
            </label>
            <input
              id="grid-email"
              type="email"
              class="border-0 px-3 py-3 placeholder-blueGray-300 text-blueGray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
              bind:value={publishMessage}
            />
          </div>
        </div>
      </div>
    </form>
    <hr class="mt-6 border-b-1 border-blueGray-300" />
    <form>
      <h6 class="text-blueGray-400 text-base mt-3 mb-6 font-bold uppercase">
        Wifi Connection
      </h6>
      <div class="text-center items-end flex justify-between">
        <hr />
        <button
          class:active={wifiActiveButton}
          class="bg-red-400 text-white active:bg-red-500 font-bold uppercase text-sm px-4 py-2 rounded shadow hover:shadow-md outline-none focus:outline-none mr-1 ease-linear transition-all duration-150"
          type="button"
          on:click={wifiFunction}
        >
          {#if wifiActiveButton}
            Connected to {ssid}
          {:else}
            Connect to Wifi
          {/if}
        </button>
      </div>
      <div class="flex flex-wrap">
        <div class="w-full lg:w-12/12 px-4">
          <div class="relative w-full mb-3">
            <label
              class="block uppercase text-blueGray-600 text-sm font-bold mb-2"
              for="grid-address"
            >
              SSID
            </label>
            <input
              id="grid-address"
              type="text"
              class="border-0 px-3 py-3 placeholder-blueGray-300 text-blueGray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
              bind:value={ssid}
            />
          </div>
        </div>
        <div class="w-full lg:w-12/12 px-4">
          <div class="relative w-full mb-3">
            <label
              class="block uppercase text-blueGray-600 text-sm font-bold mb-2"
              for="grid-city"
            >
              Password
            </label>
            <input
              id="grid-city"
              type="email"
              class="border-0 px-3 py-3 placeholder-blueGray-300 text-blueGray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
              bind:value={ssid_password}
            />
          </div>
        </div>
        <!-- <div class="w-full lg:w-4/12 px-4">
          <div class="relative w-full mb-3">
            <label
              class="block uppercase text-blueGray-600 text-sm font-bold mb-2"
              for="grid-country"
            >
              Country
            </label>
            <input
              id="grid-country"
              type="text"
              class="border-0 px-3 py-3 placeholder-blueGray-300 text-blueGray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
              value="United States"
            />
          </div>
        </div> -->
        <!-- <div class="w-full lg:w-4/12 px-4">
          <div class="relative w-full mb-3">
            <label
              class="block uppercase text-blueGray-600 text-sm font-bold mb-2"
              for="grid-postal-code"
            >
              Postal Code
            </label>
            <input
              id="grid-postal-code"
              type="text"
              class="border-0 px-3 py-3 placeholder-blueGray-300 text-blueGray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
              value="Postal Code"
            />
          </div>
        </div> -->
      </div>

      <hr class="mt-6 border-b-1 border-blueGray-300" />

      <h6 class="text-blueGray-400 text-sm mt-3 mb-6 font-bold uppercase">
        About Me
      </h6>
      <div class="flex flex-wrap">
        <div class="w-full lg:w-12/12 px-4">
          <div class="relative w-full mb-3">
            <label
              class="block uppercase text-blueGray-600 text-sm font-bold mb-2"
              for="grid-about-me"
            >
              About me
            </label>
            <textarea
              id="grid-about-me"
              type="text"
              class="border-0 px-3 py-3 placeholder-blueGray-300 text-blueGray-600 bg-white rounded text-sm shadow focus:outline-none focus:ring w-full ease-linear transition-all duration-150"
              rows="4"
              value="A beautiful UI Kit and Admin for Svelte & Tailwind CSS. It is Free
                and Open Source."
            />
          </div>
        </div>
      </div>
    </form>
  </div>
</div>

<style>
  .active {
    background-color: #6495ed;
  }
</style>
