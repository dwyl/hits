var fs = require('fs');
var path = require('path');
var EOL = require('os').EOL; // https://stackoverflow.com/a/14063413/1148249
var LOG_DIR = path.resolve(__dirname, '../logs');

/**
 * add - adds an entry into the List for a given url
 * @param {Object|null} error - the error we just received
 * @param {String} [message=none] - the user-defined error message
 & @returns {Boolean} - returns false if not error and true if error logged
 */
module.exports = function error_logger (error, message) {
  if (error) {
    var _error;
    var filepath = path.resolve(LOG_DIR, 'error.log');
    if (typeof error !== 'object') {
      _error = { error: error };
    } else {
      _error = error;
    }
    _error._message = message || 'none';
    console.log('- - - - - - - - - - - - Error: - - - - - - - - - - - - ');
    console.error(_error);
    console.log('- - - - - - - - - - - - - - - - - - - - - - - - - - - - '); 
    // we expect errors to be infrequent so Sync is "OK" here!
    fs.writeFileSync(filepath, JSON.stringify(_error) + EOL);
    return true;
  } 
  return false;
}
