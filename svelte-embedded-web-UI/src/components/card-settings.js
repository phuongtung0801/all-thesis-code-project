import { writable } from "svelte/store";

const mqttSettings = writable(
    {
        server: "phuongtung08081.tk",
        username: "phuongtung256",
        password: "nguyenthiminhthy2304",
        clientID: "0801",
        port: "8883",
        status: "Connected"
    }
)



export default mqttSettings

// export default mqttSubscribeMessages;
