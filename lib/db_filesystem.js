var fs = require('fs');
var rl = require('readline');
var path = require('path');
var hash = require('./hash.js');
var error_log = require('../lib/error_logger.js');

var EOL = require('os').EOL; // https://stackoverflow.com/a/14063413/1148249
var LOG_DIR = path.resolve(__dirname, '../logs');

if (!fs.existsSync(LOG_DIR)) { // ignored if already exists
  fs.mkdirSync(LOG_DIR);
}
var LOG_FILE = path.resolve(LOG_DIR, 'access.log');

var AGENTS_DIR = path.join(LOG_DIR, '/agents');
if (!fs.existsSync(AGENTS_DIR)) { // ignored if already exists
  fs.mkdirSync(AGENTS_DIR);
}

/**
 * add - adds an entry into the List for a given url
 * @param {Object} hit - the hit we just received
 * @param {Function} callback - call this once redis responds
 */
module.exports = function file_save_hit (hit, callback) {
  var h = hit.split('|'); // See README.md#How secton for sample data
  var url = h[1];

  // save unique hash of browser data to avoid duplication
  var unique_browser_string = [ h[2], h[3], h[4] ].join('|');
  var hashed_agent = hash(unique_browser_string, 10);

  // save unique data in file to reduce duplication in logs
  var agent_path = path.join(path.resolve(AGENTS_DIR, hashed_agent))
  fs.writeFile(agent_path, unique_browser_string, function (err, data) {
    error_log(err, 'unable to save agent data: ' + agent_path);
    // lineReader = rl.createInterface({
    //   input: require('fs').createReadStream(LOG_FILE)
    // });
    // var lines = [];
    // lineReader.on('line', function (line) {
    // if (line.length > 1 && line.indexOf(url) > -1) {
    //   lines.push(line);
    // }
    // });

    // read the logs to see the last entry for the url being requested:    
    fs.readFile(LOG_FILE, 'utf8', function (err, data) {
      var count = 1;
      if (err) {
        error_log(err, 'unable to read LOG_FILE ' + LOG_FILE);
      }
      else {
        var lines = data.split(EOL).filter(function (line) {
          if (line.length > 1 && line.indexOf(url) > -1) {
            return line;
          }
        });
        if (lines && lines.length > 0) {
          var last_line = lines[lines.length - 1];
          var parts = last_line.split('|'); // parse and incremnt count:
          count = parseInt(parts[parts.length - 1], 10) + 1;
        }
      }
      
      var entry = [h[0], h[1], hashed_agent, count].join('|') + EOL;
      fs.appendFile(LOG_FILE, entry, function (err) {
        error_log(err, 'unable to APPEND to file:' + LOG_FILE);
        callback(err, count);
      }); // if slow, optimise: https://stackoverflow.com/questions/12453057
    });
  });
}
