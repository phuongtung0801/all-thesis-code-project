<script>
  import { Router, Link, Route } from "svelte-navigator";
  import { createEventDispatcher } from "svelte";
  import { useNavigate } from "svelte-navigator";
  import { navigate } from "svelte-navigator";
  const dispatch = createEventDispatcher();
  const redirect = () => {
    navigate("/home", { replace: true });
  };

  const Navigate = useNavigate();
  const NavigateFunc = (nav) => useNavigate(nav);

  const sendPost = async () => {
    let response = await fetch("http://192.168.137.8/auth", {
      credentials: "include",
    })
      .then((res) => res.json())
      .then((data) => {
        if (data.status == "ok") {
          console.log("Success:", data);
          // redirect("/login");
          Navigate("/home");
        } else {
          console.log("Some thing wrong in auth");
          console.log(data);
          Navigate("/login");
        }
      })
      .catch((error) => {
        console.error("Errorrr:", error);
      });
    console.log("Response is: " + response);
  };
</script>

<!-- <Link to="register">
  <button
    class="bg-blue-500 hover:bg-blue-400 text-white font-bold py-2 px-4 border-b-4 border-blue-700 hover:border-blue-500 rounded"
    >Click hear to go to Login Page</button
  >
</Link> -->

<!-- Section 1 -->
<section class="w-full px-6 pb-12 antialiased bg-white">
  <div class="mx-auto max-w-7xl">
    <nav class="relative z-50 h-24 select-none">
      <div
        class="container relative flex flex-wrap items-center justify-between h-24 mx-auto overflow-hidden font-medium border-b border-gray-200 md:overflow-visible lg:justify-center sm:px-4 md:px-2"
      >
        <div
          class="absolute right-0 flex flex-col items-center items-end justify-center w-10 h-10 bg-white rounded-full cursor-pointer md:hidden hover:bg-gray-100"
        >
          <svg
            class="w-6 h-6 text-gray-700"
            x-show="!showMenu"
            fill="none"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            viewBox="0 0 24 24"
            stroke="currentColor"
            x-cloak=""
          >
            <path d="M4 6h16M4 12h16M4 18h16" />
          </svg>
          <svg
            class="w-6 h-6 text-gray-700"
            x-show="showMenu"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
            x-cloak=""
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </div>
      </div>
    </nav>

    <!-- Main Hero Content -->
    <div
      class="container max-w-lg px-4 py-32 mx-auto text-left md:max-w-none md:text-center"
    >
      <h1
        class="text-5xl font-extrabold leading-10 tracking-tight text-left text-gray-900 md:text-center sm:leading-none md:text-6xl lg:text-7xl"
      >
        <span class="inline md:block">Welcome to</span>
        <span
          class="relative mt-2 text-transparent bg-clip-text bg-gradient-to-br from-indigo-600 to-indigo-500 md:inline-block"
          >ESP32 Web Server</span
        >
      </h1>
      <div
        class="mx-auto mt-5 text-gray-500 md:mt-12 md:max-w-lg md:text-center lg:text-lg"
      >
        Display realtime with websocket, config MQTT
      </div>
      <div class="flex flex-col items-center mt-12 text-center">
        <span class="relative inline-flex w-full md:w-auto">
          <a
            on:click={sendPost}
            href="#_"
            type="button"
            class="textwhite inline-flex items-center justify-center w-full px-8 py-4 font-bold leading-6 text-white bg-indigo-600 border border-transparent rounded-full md:w-auto hover:bg-indigo-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-600"
          >
            Start Now
          </a>
        </span>
        <!-- svelte-ignore a11y-invalid-attribute -->
        <a href="#" class="mt-3 text-sm text-indigo-500">Learn More</a>
      </div>
    </div>
    <!-- End Main Hero Content -->
  </div>
</section>

<style>
  .textwhite {
    color: white;
  }
</style>
