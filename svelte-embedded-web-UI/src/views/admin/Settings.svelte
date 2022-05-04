<script>
  // core components
  import CardSettings from "../../components/Cards/CardSettings.svelte";
  import CardProfile from "../../components/Cards/CardProfile.svelte";
  import SideBar from "../../components/Sidebar/Sidebar.svelte";
  export let location;
</script>

<div class="flex flex-wrap">
  <div class="w-full lg:w-2/12 px-4">
    <SideBar />
  </div>
  <div class="w-full lg:w-10/12 px-4">
    <CardSettings />
  </div>
</div>
