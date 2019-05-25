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


// Websockets! https://github.com/dwyl/hits/issues/79
// var channel = socket.channel('hit:lobby', {}); // connect to Hits "room"
// channel.join(); // join the channel.
//
// channel.on('shout', function (payload) { // listen to the 'shout' event
//   console.log('shout', payload);
//   // var li = document.createElement("li"); // creaet new list item DOM element
//   // var name = payload.name || 'guest';    // get name from payload or set default
//   // li.innerHTML = '<b>' + name + '</b>: ' + payload.message;
//   // ul.appendChild(li);                    // append to list
// });


//
// var ul = document.getElementById('msg-list');        // list of messages.
// var name = document.getElementById('name');          // name of message sender
// var msg = document.getElementById('msg');            // message input field

// "listen" for the [Enter] keypress event to send a message:
// msg.addEventListener('keypress', function (event) {
//   console.log('keypress', event);
//   // if (event.keyCode == 13 && msg.value.length > 0) { // don't sent empty msg.
//   //   channel.push('shout', { // send the message to the server
//   //     name: name.value,     // get value of "name" of person sending the message
//   //     message: msg.value    // get message text (value) from msg input field.
//   //   });
//   //   msg.value = '';         // reset the message input field for next message.
//   // }
// });
