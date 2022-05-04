<script>
  export let color = "light";
  export let topicName = "NoneTopic";
  export let message = "NoneMessage";
  export let QoS = "Default";
  export let status = "NoneStatus";
</script>

<tr>
  <th
    class="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4 text-left flex items-center"
  >
    <span
      class="ml-3 font-bold {color === 'light'
        ? 'btext-blueGray-600'
        : 'text-whit'}"
    >
      {topicName}
    </span>
  </th>
  <td
    class="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4"
  >
    {message}
  </td>
  <td
    class="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4"
  >
    <i class="fas fa-circle text-emerald-500 mr-2" />
    {QoS}
  </td>
  <td
    class="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-nowrap p-4"
  >
    <i class="fas fa-circle text-emerald-500 mr-2" />
    {status}
  </td>
</tr>
