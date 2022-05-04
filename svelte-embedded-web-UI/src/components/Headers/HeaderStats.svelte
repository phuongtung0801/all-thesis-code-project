<script>
  // core components
  import CardStats from "../Cards/CardStats.svelte";
  import mqttSetting from "../card-settings";
</script>

<!-- Header -->
<div class="relative bg-red-500 md:pt-32 pb-32 pt-12">
  <div class="px-4 md:px-10 mx-auto w-full">
    <div>
      <!-- Card stats -->
      <div class="flex flex-wrap">
        <div class="w-full lg:w-6/12 xl:w-3/12 px-4">
          <CardStats
            statSubtitle="BROKER"
            statTitle={$mqttSetting.server}
            statIconName="far fa-chart-bar"
            statIconColor="bg-red-500"
          />
        </div>
        <div class="w-full lg:w-6/12 xl:w-3/12 px-4">
          <CardStats
            statSubtitle="USER NAME"
            statTitle={$mqttSetting.username}
            statIconName="fas fa-users"
            statIconColor="bg-yellow-500"
          />
        </div>
        <div class="w-full lg:w-6/12 xl:w-3/12 px-4">
          <CardStats
            statSubtitle="CLIENT ID"
            statTitle={$mqttSetting.clientID}
            statIconName="fas fa-id-card"
            statIconColor="bg-pink-500"
          />
        </div>
        <div class="w-full lg:w-6/12 xl:w-3/12 px-4">
          {#if $mqttSetting.status == "Connected"}
            <CardStats
              statSubtitle="STATUS"
              statTitle={$mqttSetting.status}
              statIconName="fas fa-thumbs-up"
              statIconColor="bg-green-500"
            />
          {:else}
            <CardStats
              statSubtitle="STATUS"
              statTitle={$mqttSetting.status}
              statIconName="fas fa-thumbs-down"
              statIconColor="bg-gray-500"
            />
          {/if}
        </div>
      </div>
    </div>
  </div>
</div>
