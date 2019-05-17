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
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
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
