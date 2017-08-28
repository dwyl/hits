var dir  = __dirname.split('/')[__dirname.split('/').length-1];
var file = dir + __filename.replace(__dirname, '') + " > ";
var test = require('tape');
var fs = require('fs');
var path = require('path');
var rimraf = require('rimraf');
var LOG_DIR = path.resolve(__dirname, '../logs');

test(file + 'Delete /logs directory to ensure tests are fresh', function (t) {
  console.log('LOG_DIR: ', LOG_DIR);
  rimraf(LOG_DIR, function () { 
    console.log('fs.existsSync(LOG_DIR):', fs.existsSync(LOG_DIR));
    t.equal(false, fs.existsSync(LOG_DIR), 
      LOG_DIR + ' does not exist ' + fs.existsSync(LOG_DIR));
    t.end();
  });
});
