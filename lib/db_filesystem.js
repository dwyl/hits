var fs = require('fs');
var path = require('path');
var hash = require('./hash.js');
var mkdirp = require('mkdirp');
var assert = require('assert');
var EOL = require('os').EOL; // https://stackoverflow.com/a/14063413/1148249

var DATA_DIR = path.resolve(__dirname, '../data/');
var agents_path = path.resolve(DATA_DIR, 'agents');
mkdirp(agents_path);

/**
 * add - adds an entry into the List for a given url
 * @param {Object} hit - the hit we just received
 * @param {Function} callback - call this once redis responds
 */
module.exports = function redis_save_hit (hit, callback) {
  var h = hit.split('|'); // See README.md#How secton for sample data
  var url = h[1];
  var parts = url.split('/').filter(function(n){ return n != undefined });
  var dir = path.join(DATA_DIR, parts.slice(0, -1).join('/'));

  // save unique hash of browser data to avoid duplication
  var unique_browser_string = [ h[2], h[3], h[4] ].join('|');
  var hashed_agent = hash(unique_browser_string, 10);

  fs.writeFile(path.resolve(agents_path, hashed_agent), 
  unique_browser_string, function (err, data) {
    
    // create directory for the url
    mkdirp(dir, function (err) {
      assert(!err);
      var filepath = path.join(dir, parts[parts.length - 1])

      // save hit data with hashed browser data:
      var entry = h[0] + '|' + hashed_agent + EOL;
      fs.appendFile(filepath, entry, function (err) {
        assert(!err);
        
        // count how many lines are in the file for the URL:
        fs.readFile(filepath, 'utf8', (err, data) => {
          assert(!err);
          
          callback(err, data.split(EOL).length - 1);
        }); // if slow, optimise: https://stackoverflow.com/questions/12453057
      });
    });
  });
}
