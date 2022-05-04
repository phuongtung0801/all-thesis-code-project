<script>
  import { createEventDispatcher } from "svelte";
  import { Router, Link, Route } from "svelte-navigator";
  import { useNavigate } from "svelte-navigator";

  const dispatch = createEventDispatcher();
  let username;
  let password;

  // const redirect = () => {
  //   navigate("/register", { replace: true });
  // };

  const Navigate = useNavigate();
  let formData = new URLSearchParams();

  const sendPost = async () => {
    formData.append("Username", username);
    formData.append("Password", password);
    let response = await fetch("http://192.168.137.8/login", {
      credentials: "include",
      method: "POST",
      body: formData,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    });
    let data = await response.json();
    if ((data.status = "ok")) {
      console.log("Success: ", data);

      Navigate("/home");
    } else {
      console.log("Some thing wrong in login");
      console.log(data);
      Navigate("/login");
    }
    // .then((res) => res.json())
    // .then((data) => {
    //   if (data.status == "ok") {
    //     console.log("Success:", data);
    //     // redirect("/login");
    //     Navigate("/home");
    //   } else {
    //     console.log("Some thing wrong in login");
    //     console.log(data);
    //     Navigate("/login");
    //   }
    // })
    // .catch((error) => {
    //   console.error("Errorrr:", error);
    // });
    console.log("Response is: " + response);
  };
</script>

<main class="center">
  <h1>This is a Login Page!</h1>
</main>

<div class="w-full max-w-xs center">
  <form class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
    <div class="mb-4">
      <input
        class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
        id="username"
        type="text"
        placeholder="Username"
        bind:value={username}
      />
    </div>
    <div class="mb-6">
      <input
        class="shadow appearance-none border border-red-500 rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
        id="password"
        type="password"
        placeholder="******************"
        bind:value={password}
      />
      <p class="text-red-500 text-xs italic">Please choose a password.</p>
    </div>
    <div class="flex items-center justify-between">
      <button
        on:click={sendPost}
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
        type="button"
      >
        Sign In
      </button>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <!-- <input
        type="submit"
        class="inline-block align-baseline font-bold text-sm text-blue-500 hover:text-blue-800"
        value="submit"
        on:click={toRegister}
      /> -->
      <!-- svelte-ignore a11y-invalid-attribute -->
      <button
        on:click={() => Navigate("/register")}
        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
        type="button"
      >
        Register
      </button>
    </div>
  </form>
  <p class="text-center text-gray-500 text-xs">
    &copy;2020 Acme Corp. All rights reserved.
  </p>
</div>

<style global lang="postcss">
  @tailwind base;
  @tailwind components;
  @tailwind utilities;
  .center {
    text-align: center;
    margin: auto;
    width: 50%;
    padding: 10px;
  }

  .textwhite {
    color: white;
  }
</style>
