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
    response.writeHead(200, {"Content-Type": "image/svg+xml"});
    response.end(img.toString());
  // }
  // response.end('hello world!');

}).listen(port);
