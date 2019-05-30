// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

console.log('hello!');
// Import local files
import socket from "./socket"

// Get Markdown Template from HTML:
var mt = document.getElementById('badge').innerHTML;

function generate_markdown () {
  var user = document.getElementById("username").value || '{username}';
  var repo = document.getElementById("repo").value || '{project}';
  // console.log('user: ', user, 'repo: ', repo);
  user = user.replace(/[.*+?^$<>()|[\]\\]/g, '');
  repo = repo.replace(/[.*+?^$<>()|[\]\\]/g, '');
  return mt.replace(/{username}/g, user).replace(/{repo}/g, repo);
}

function display_badge_markdown () {
  var md = generate_markdown()
  var pre = document.getElementById("badge").innerHTML = md;
}

setTimeout(function () {
  var how = document.getElementById("how");
  // show form if JS available (progressive enhancement)
  if(how) {
    document.getElementById("how").classList.remove('dn');
    document.getElementById("nojs").classList.add('dn');
    display_badge_markdown(); // render initial markdown template
    var get = document.getElementsByTagName('input');
   for (var i = 0; i < get.length; i++) {
       get[i].addEventListener('keyup', display_badge_markdown, false);
       get[i].addEventListener('keyup', display_badge_markdown, false);
   }
  }
}, 500);

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
