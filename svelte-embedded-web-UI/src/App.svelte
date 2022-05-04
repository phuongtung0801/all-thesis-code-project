<script>
  import { Router, Link, Route } from "svelte-navigator";
  import Register from "./routes/Register.svelte";
  import Auth from "./Auth.svelte";
  import Home from "./routes/Home.svelte";
  import Login from "./routes/Login.svelte";
  import Settings from "./views/admin/Settings.svelte";

  export let url = "";
  let gifs = [];
  let searchTerm = "";
  let username;
  let password;
  let result = null;

  let myData = {
    Username: username,
    Password: password,
  };
</script>

<Router>
  <div>
    <Route path="/"><Auth /></Route>
    <Route path="/home" component={Home} />
    <Route path="/login" component={Login} />
    <Route path="/settings" component={Settings} />
  </div>
</Router>

<main>
  <!-- <form action="/" method="POST">
    <label for="fname">First name:</label><br />
    <input type="text" id="fname" name="fname" value="John" /><br />
    <label for="lname">Last name:</label><br />
    <input type="text" id="lname" name="lname" value="Doe" /><br /><br />
    <input type="submit" value="Submit" />
  </form> -->
</main>

<style global lang="postcss">
  @tailwind base;
  @tailwind components;
  @tailwind utilities;
</style>
