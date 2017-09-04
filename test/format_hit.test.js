var dir  = __dirname.split('/')[__dirname.split('/').length-1];
var file = dir + __filename.replace(__dirname, '') + " > ";
var test  = require('tape');
var format = require('../lib/format_hit.js')

test("Create hash for url: 1234", function(t) {
  var hit = '1503784599|/dwyl/hits|Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:54.0) Gecko/20100101 Firefox/54.0|::1|EN-GB';
  var count = 42;
  var formatted = format(hit, count);
  var expected = '2017-08-26 21:56:39 /dwyl/hits 42 3wtuQ6JcHR'
  t.equal(formatted, expected , 
    '✓ Hit: ' + hit  + ' formatted as: ' + formatted);
  t.end();
});
