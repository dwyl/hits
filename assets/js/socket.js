// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"

// let socket = new Socket("/socket", {params: {token: window.userToken}})
// https://stackoverflow.com/a/67305310/1148249
let socket = new Socket("wss://hits.dwyl.com/socket/websocket?vsn=2.0.0")

// Connect to the socket:
socket.connect()

export default socket
