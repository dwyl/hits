// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// Connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("hit:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on('hit', function (payload) { // listen to the 'shout' event
  console.log('hit', payload);
  append_hit(payload);
  // var li = document.createElement("li"); // creaet new list item DOM element
  // var name = payload.name || 'guest';    // get name from payload or set default
  // li.innerHTML = '<b>' + name + '</b>: ' + payload.message;
  // ul.appendChild(li);                    // append to list
});

const root = document.getElementById("hits");
function append_hit (data) {
  const previous = root.childNodes[0];
  const DATE = new Date();
  const date = Date.now();
  const time = DATE.toUTCString().replace('GMT', '');
  const text = time + ' /' + data.user + '/' + data.repo + ' ' + data.count
  root.insertBefore(div(date, text), previous);
}

// borrowed from: https://git.io/v536m
function div(divid, text) {
  let div = document.createElement('div');
  div.id = divid;
  const txt = document.createTextNode(text);
  div.appendChild(txt);
  return div;
}

export default socket
