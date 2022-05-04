<script language="javascript" type="text/javascript">
  import SideBar from "../components/Sidebar/Sidebar.svelte";
  import HeaderStats from "../components/Headers/HeaderStats.svelte";
  import AdminNavbar from "../components/Navbars/AdminNavbar.svelte";
  import Tables from "../views/admin/Tables.svelte";
  import WebSocket from "../myComponents/WebSocketUI.svelte";
  let mqttServer;
  let mqttUsername;
  let mqttPassword;
  let mqttClientID;
  let mqttPort;
</script>

<div class="container" id="content">
  <div class="m-0">
    <SideBar />
  </div>

  <div class="md:-mt-8 md:-mr-2 relative md:ml-60 bg-blueGray-100">
    <AdminNavbar />
    <HeaderStats />
    <Tables />
    <WebSocket />
    <!-- <div>
      <h2>LED Control</h2>
      <table>
        <tr>
          <td
            ><button id="toggleButton" on:click={onClick}
              >Connect Websocket</button
            ></td
          >
          <td
            ><button id="toggleButton" on:click={onPress}>Toggle LED</button
            ></td
          >
          <td><canvas id="led" width="50" height="50" /></td>
        </tr>
      </table>
    </div> -->
  </div>
</div>

<style>
</style>
