<script>
  // library for creating dropdown menu appear on click
  // import { createPopper } from "@popperjs/core";

  // core components

  // const image = "../assets/img/team-1-800x800.jpg";

  let dropdownPopoverShow = false;

  let btnDropdownRef;
  let popoverDropdownRef;

  const toggleDropdown = (event) => {
    // event.preventDefault();
    // if (dropdownPopoverShow) {
    //   dropdownPopoverShow = false;
    // } else {
    //   dropdownPopoverShow = true;
    //   createPopper(btnDropdownRef, popoverDropdownRef, {
    //     placement: "bottom-start",
    //   });
    // }
  };
</script>

<div>
  <!-- svelte-ignore a11y-invalid-attribute -->
  <a
    class="text-blueGray-500 block"
    href="#"
    bind:this={btnDropdownRef}
    on:click={toggleDropdown}
  >
    <div class="items-center flex">
      <span
        class="w-12 h-12 text-sm text-white bg-blueGray-200 inline-flex items-center justify-center rounded-full"
      />
    </div>
  </a>
  <div
    bind:this={popoverDropdownRef}
    class="bg-white text-base z-50 float-left py-2 list-none text-left rounded shadow-lg min-w-48 {dropdownPopoverShow
      ? 'block'
      : 'hidden'}"
  >
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="#"
      on:click={(e) => e.preventDefault()}
      class="text-sm py-2 px-4 font-normal block w-full whitespace-nowrap bg-transparent text-blueGray-700"
    >
      Action
    </a>
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="#"
      on:click={(e) => e.preventDefault()}
      class="text-sm py-2 px-4 font-normal block w-full whitespace-nowrap bg-transparent text-blueGray-700"
    >
      Another action
    </a>
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="#"
      on:click={(e) => e.preventDefault()}
      class="text-sm py-2 px-4 font-normal block w-full whitespace-nowrap bg-transparent text-blueGray-700"
    >
      Something else here
    </a>
    <div class="h-0 my-2 border border-solid border-blueGray-100" />
    <!-- svelte-ignore a11y-invalid-attribute -->
    <a
      href="#"
      on:click={(e) => e.preventDefault()}
      class="text-sm py-2 px-4 font-normal block w-full whitespace-nowrap bg-transparent text-blueGray-700"
    >
      Seprated link
    </a>
  </div>
</div>
