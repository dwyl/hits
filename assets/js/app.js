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

// Import local files
import socket from "./socket"

// Get Markdown Template from HTML:
var mt = document.getElementById('badge').innerHTML;
var mtu = document.getElementById('badge-unique').innerHTML;
var mtendpoint = document.getElementById('badge-endpoint').innerHTML;
var mtsheilds = document.getElementById('badge-shields').innerHTML;

function generate_markdown (template) {
  var user = document.getElementById("username").value || '{username}';
  var repo = document.getElementById("repo").value || '{project}';
  var style = document.getElementById("styles").value || '{style}';
  // console.log('user: ', user, 'repo: ', repo);
  user = user.replace(/[.*+?^$<>()|[\]\\]/g, '');
  repo = repo.replace(/[.*+?^$<>()|[\]\\]/g, '');
  return template.replace(/{username}/g, user).replace(/{repo}/g, repo).replace(/{style}/g, style);
}

function display_badge_markdown () {
  var md = generate_markdown(mt)
  var mdu = generate_markdown(mtu) 
  var mdendpoint = generate_markdown(mtendpoint) 
  var mdshields = generate_markdown(mtsheilds) 
  
  document.getElementById("badge").innerHTML = md;
  document.getElementById("badge-unique").innerHTML = mdu;
  document.getElementById("badge-endpoint").innerHTML = mdendpoint;
  document.getElementById("badge-shields").innerHTML = mdshields;
  document.getElementById("badge-shields-svg").src = mdshields;
  
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

    // changing markdown preview whenever an option is selected
    document.getElementById("styles").onchange = function(e) {
      display_badge_markdown()
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
  root.insertBefore(div(data), previous);
  // remove default message if displayed
  // see https://github.com/dwyl/hits/issues/149
  const defaultMsg = document.getElementById('default-websockets-msg');
  defaultMsg && defaultMsg.remove();
}

function link (data) {
  const a = document.createElement('a');
  const repo = data.repo.split('.svg')[0]
  const text = "/" + data.user + '/' + repo;
  const linkText = document.createTextNode(text);
  a.appendChild(linkText);
  a.title = text;
  a.href = "https://github.com/" + data.user + '/' + repo;
  return a;
}

// borrowed from: https://git.io/v536m
function div(data) {
  let div = document.createElement('div');
  div.id = Date.now();
  div.appendChild(date_as_text())
  div.appendChild(link(data));
  div.appendChild(document.createTextNode(" " + data.count))
  return div;
}

function date_as_text() {
  const DATE = new Date();
  const time = DATE.toUTCString().replace('GMT', '');
  return document.createTextNode(time);
}


