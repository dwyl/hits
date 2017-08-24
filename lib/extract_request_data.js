var uniki = require('uniki'); // to create super-short hash of the User Agent

// This file/module's only job is extracting the request data from http headers
module.exports = function extract (req) {
  var h = req.headers;                    // shortcut to headers reduces typing
  var agent = uniki(h['user-agent'], 7);  // the user-agent for device/browser
  var lang = '';                          // the browser language
  
  // get the user's IP addres from headers or connection object:
  var ip = h['x-forwarded-for'] || req.connection.remoteAddress;
  
  // get url the client requested:
  var url = req.url.replace('.svg', '')
          .replace('.png', '')
          .replace('https://github.com/', ''); // strip to save storage

  if(h['accept-language']) { // Language for: github.com/dwyl/hits/issues/43
    if (h['accept-language'].indexOf(',') > -1) { // e.g: en-GB,en;q=0.5
      lang = h['accept-language'].split(',')[0].toUpperCase();
    } else {
      lang = h['accept-language'].toUpperCase();  
    }
  }
  
  return [Date.now(), url, h['user-agent'], ip, lang].join('|');
}
