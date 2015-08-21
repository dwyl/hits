var http = require('http');
var fs   = require('fs');
var path = require('path');
var filepath = path.resolve(__dirname + '/climate.svg')
// console.log(filepath);
var img  = fs.readFileSync(filepath, 'utf-8');
// console.log(img);
var port = process.env.PORT || 8000;
http.createServer(function handler(request, response) {
  var url = request.url;

  console.log("request.url:", url);
  // if (url.length === 1) {
    // response.writeHead(200, {"Content-Type": "image/svg+xml"});
    response.writeHead(307, {"Location": "https://img.shields.io/badge/hits-12-brightgreen.svg"});
    response.end();
  // }
  // response.end('hello world!');

}).listen(port);

console.log('Visit http://localhost:' + port);
