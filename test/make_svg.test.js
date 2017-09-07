var dir  = __dirname.split('/')[__dirname.split('/').length-1];
var file = dir + __filename.replace(__dirname, '') + " > ";
var test = require('tape');
var make_svg = require('../lib/make_svg.js');

test(file + 'Make SVG file from template & count', function(t){
  var count = 1337;
  var svg = make_svg(count);
  t.ok(svg.indexOf(count.toString()) > -1, 
  '✓ SVG created for count: ' + count)
  t.end();
});
