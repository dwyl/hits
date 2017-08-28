var crypto = require('crypto');

// generate a hash of a specific length
module.exports = function hash (str, length) {
  return crypto.createHash('sha512') // crypto.stackexchange.com/questions/26336
  .update(str.toString()).digest('base64')
  .replace('/','').replace(/[Il0oO=\/\+]/g,'') // remove ambiguous chars
  .substring(0, length || 12);
}
