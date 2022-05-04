import { readable } from "svelte/store";
let url = "ws://192.168.137.8/ws"
const websocket = new WebSocket(url)

export default websocket