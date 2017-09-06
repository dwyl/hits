/**
 * This file/module's only job is to extract the request data from http headers
 * @param {Object} request - the standard nodejs http request object.
 * @returns {string} hit - see readme for format.
 */
module.exports = function extract (request) {
  var h = request.headers || {};          // shortcut to headers reduces typing
  var lang;                               // the browser language

  // get the user's IP addres from headers or connection object:
  var ip = h['x-forwarded-for'] || 
    request.connection && request.connection.remoteAddress;

  // get url the client requested:
  var url = request.url.replace('.svg', '')
    .replace('.png', '')
    .replace('https://github.com/', ''); // strip to save storage

  if(h['accept-language']) { // Language for: github.com/dwyl/hits/issues/43
    if (h['accept-language'].indexOf(',') > -1) { // e.g: en-GB,en;q=0.5
      lang = h['accept-language'].split(',')[0].toUpperCase(); // e.g: EN-GB
    } else {
      lang = h['accept-language'].toUpperCase();  
    }
  }

  return [ Math.floor(Date.now()/1000), 
    url, h['user-agent'], ip, lang ].join('|');
}
