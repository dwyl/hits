/**
 * add - adds an entry into the List for a given url
 * @param {Object} hit - the hit we just received
 * @param {Function} callback - call this once redis responds
 */
module.exports = function add (hit, callback) {
  // if(process.env.REDISCLOUD_URL) {
  //   return require('./db_redis.js')(hit, callback);
  // }
  // else {
    return require('./db_filesystem.js')(hit, callback);
  // }
}
