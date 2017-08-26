var hash = require('./hash.js');
/**
 * This file/module's only job is to format the Hit data for human-friendly UI
 * @param {String} hit - the standard nodejs http request object.
 * @param {Number} count - the count for the given url
 * @returns {string} hit - human-friendly hit data for display in UI
 */
module.exports = function format_hit_for_ui (hit, count) {
  var h = hit.split('|'); // See README.md#How secton for sample data
  var url = h[1];
  var date = format_date_time_from_timestamp(h[0])
  
  // save unique hash of browser data to avoid duplication
  var unique_browser_string = [ h[2], h[3], h[4] ].join('|');
  var hashed_agent = hash(unique_browser_string, 10);
  return [date, url, count, hashed_agent].join(' ');
}

function format_date_time_from_timestamp (timestamp) {
  var date = new Date(timestamp * 1000).toJSON();
  var len = date.length;
  return date.substring(0, len -5).replace('T', ' ');
}
