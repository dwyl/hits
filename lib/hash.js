var crypto = require('crypto');

// generate a hash of a specific length
module.exports = function hash (str, length) {
  var len = length || 8;
  var h = crypto.createHash('sha512')
  .update(str.toString()).digest('base64')
  .replace('/','').replace(/[Il0oO=\/\+]/g,''); // remove ambiguous chars
  return h.substring(0, len);
}
