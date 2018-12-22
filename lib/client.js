var root = document.getElementById("hits");
console.log('Ready!', window.location.host);

setTimeout(function(){
  var socket = io(window.location.host);
  socket.on('news', function (data) {
    console.log(data);
    socket.emit('hello', { msg: 'Hi!' });
  });

  socket.on('hit', function (data) {
    var previous = root.childNodes[0];
    root.insertBefore(div(Date.now(), data.hit), previous);
  });

  // borrowed from: https://git.io/v536m
  function div(divid, text) {
    var div = document.createElement('div');
    div.id = divid;
    div.className = divid;
    if(text !== undefined) { // if text is passed in render it in a "Text Node"
      var txt = document.createTextNode(text);
      div.appendChild(txt);
    }
    return div;
  }
  document.getElementById("how").classList.remove('dn'); // show form if JS available (progressive enhancement)
  document.getElementById("nojs").classList.add('dn'); // show form if JS available (progressive enhancement)
  display_badge_markdown(); // render initial markdown template
}, 500);

// Markdown Template
var mt = '[![HitCount](http://hits.dwyl.io/{user}/{repo}.svg)](http://hits.dwyl.io/{user}/{repo})';

function generate_markdown () {
  var user = document.getElementById("username").value || '{username}';
  var repo = document.getElementById("repo").value || '{project}';
  // console.log('user: ', user, 'repo: ', repo);
  user = user.replace(/[.*+?^$<>()|[\]\\]/g, '');
  repo = repo.replace(/[.*+?^$<>()|[\]\\]/g, '');
  return mt.replace(/{user}/g, user).replace(/{repo}/g, repo);
}

function display_badge_markdown() {
  var md = generate_markdown()
  var pre = document.getElementById("badge").innerHTML = md;
}

var get = document.getElementsByTagName('input');
 for (i = 0; i < get.length; i++) {
     get[i].addEventListener('keyup', display_badge_markdown, false);
     get[i].addEventListener('keyup', display_badge_markdown, false);

 }
