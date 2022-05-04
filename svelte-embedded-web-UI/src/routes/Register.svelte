<script>
  import { createEventDispatcher } from "svelte";
  import { Router, Link, Route } from "svelte-routing";
  import { useNavigate } from "svelte-navigator";

  const dispatch = createEventDispatcher();
  let username;
  let password;

  const Navigate = useNavigate();
  // const redirect = (nav) => {
  //   navigate(nav, { replace: true });
  // };
  const sendPost = async () => {
    let response = await fetch("http://192.168.137.8/register", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      credentials: "include",
      body: JSON.stringify({
        Username: username,
        Password: password,
      }),
    })
      .then((respon) => respon.json())
      .then((data) => {
        if (data.status == "ok") {
          console.log("Success:", data);
          // redirect("/login");
          Navigate("/login");
        } else {
          console.log("Some thing wrong in register");
          Navigate("/register");
        }
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  };
</script>

<main class="center">
  <h1>This is a Register Page!</h1>
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
        Register
      </button>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a
        class="inline-block align-baseline font-bold text-sm text-blue-500 hover:text-blue-800"
        href="#"
      >
        Forgot Password?
      </a>
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
</style>
