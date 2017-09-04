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
fs.appendFileSync(LOG_FILE, '- - - New Logs:');

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
  var LOG_FILE = path.join(LOG_DIR, 
      url.split('/').join('_').replace(':', '') + '.log');
  var count = 1; // hit count starts at 1
  // save unique hash of browser data to avoid duplication
  var unique_browser_string = [ h[2], h[3], h[4] ].join('|');
  var hashed_agent = hash(unique_browser_string, 10);
  // save unique data in file to reduce duplication in logs
  var agent_path = path.join(path.resolve(AGENTS_DIR, hashed_agent))
  fs.writeFile(agent_path, unique_browser_string, function (err, data) {
    error_log(err, 'unable to save agent data: ' + agent_path);
    lineReader = rl.createInterface({
      input: require('fs').createReadStream(LOG_FILE)
        .on('error', function (err) {
          console.log('Error!', err);
          error_log(err, 'unable to save agent data: ' + LOG_FILE);
          var entry = [h[0], h[1], hashed_agent, count].join('|') + EOL;
          fs.appendFile(LOG_FILE, entry, function (err) {
            error_log(err, 'unable to APPEND to file:' + LOG_FILE);
            callback(err, count);
          });
        })
    });
    var lines = [];
    lineReader.on('line', function (line) {
      lines.push(line);
    });

    lineReader.on('close', function() {
      var last_line = lines[lines.length - 1];
      var parts = last_line.split('|'); // parse and incremnt count:
      count = parseInt(parts[parts.length - 1], 10) + 1;
      
      var entry = [h[0], h[1], hashed_agent, count].join('|') + EOL;
      fs.appendFile(LOG_FILE, entry, function (err) {
        error_log(err, 'unable to APPEND to file:' + LOG_FILE);
        callback(err, count);
      }); // if slow, optimise: https://stackoverflow.com/questions/12453057
    });
  });
}
