import { writable } from "svelte/store";

const mqttSubscribeMessages = writable([
    {
        topic: "undefine",
        message: "undefine",
        status: "subscribe"
    }
]
)

export default mqttSubscribeMessages
// export default mqttSubscribeMessages;
