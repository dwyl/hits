var dir  = __dirname.split('/')[__dirname.split('/').length-1];
var file = dir + __filename.replace(__dirname, '') + " > ";
var test = require('tape');
var error_log = require('../lib/error_logger.js');

test(file+'Log an error if not null', function (t) {
  var error = { 
    Error: "ENOTDIR: not a directory, open '/dwyl/hits/.txt' at Error (native)",
    errno: -20,
    code: 'ENOTDIR',
    syscall: 'open',
    path: '/dwyl/hits/data/my/awesome/url/.txt' 
  }
  var message = 'unable to open file';
  var res = error_log(error, message);
  t.true(res === true);
  t.end();
});

test(file+'Handle Logging a non-object error', function (t) {
  t.true(error_log(1, 0) === true);
  t.end();
});

test(file + 'No error -> No Log', function (t) {
  var error = null;
  var res = error_log(error);
  t.true(res === false, 'No error logged');
  t.end();
});
