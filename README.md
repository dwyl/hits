# hits

What if there was a *simple+easy* way to see how many people have viewed your GitHub Repository?

[![Code Climate](https://hitt.herokuapp.com/hitz)](https://github.com/nelsonic/hits)


[![Code Climate](https://codeclimate.com/github/nelsonic/hits/badges/gpa.svg)](https://codeclimate.com/github/nelsonic/hits)
[![Test Coverage](https://codeclimate.com/github/nelsonic/hits/badges/coverage.svg)](https://codeclimate.com/github/nelsonic/hits/coverage)
[![Dependency Status](https://david-dm.org/nelsonic/hits.svg)](https://david-dm.org/nelsonic/hits)
[![devDependency Status](https://david-dm.org/nelsonic/hits/dev-status.svg)](https://david-dm.org/nelsonic/hits#info=devDependencies)


## Why?

We have a few repos on GitHub ... but sadly, we have no idea how many people
are looking at the repos unless they star/watch them; GitHub does not share
any stats with people using their site.

We would like to *know* the popularity of each of our repos
to know where we need to be investing our time.

## What?

A simple way to add (*very basic*) analytics to your GitHub repos.

There are already *many* "Badges" available which people put in their repos: https://github.com/dwyl/repo-badges
But we haven't seen one that gives a "***hit counter***"
of the number of times a page has been viewed ...

## How?

Place a Badge (*image*) in your repo `README.md` so others can

### Implementation

> Core Node.js or Hapi.js ...?

What is the ***minimum possible*** amount of data we can store?

+ **date+time** the person visited the site.
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/now
+ **user-agent** the browser or crawler visiting the page
https://en.wikipedia.org/wiki/User_agent
+ **referer** url of the page where the image is requested from?
https://en.wikipedia.org/wiki/HTTP_referer

Log entries are stored as a `String` which can be parsed and re-formatted into
any other format:  
```sh
1436570536950 x7uapo9 84.91.136.21
```
| Timestamp     | User Agent  | IP Address   |
| ------------- |:------------|:------------:|
| 1436570536950 | x7uapo9     | 84.91.136.21 |

We then have a user-agent hash where we can lookup the by id:
```js
{
  "x7uapo9":"Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10",
  "N03v1lz":"Googlebot/2.1 (+http://www.google.com/bot.html)"
}
```





## Research

### User Agents

How many **user agents** (web browsers + crawlers) are there?
there *appear* to be ***fewer than a couple of thousand*** user agents. http://www.useragentstring.com/pages/useragentstring.php
which means we could store them using a numeric index; 1 - 3000

But, storing the user agents using a numeric index means we
need to perform a lookup on each hit which requires network IO ...
(*expensive*!)
What if there was a way of *deriving* a `String` representation of the
the user-agent string ... oh, that's right, here's one I made earlier...
https://github.com/ideaq/aguid

### Log Formats

+ Apache Log Sample:
http://www.monitorware.com/en/logsamples/apache.php

### Node.js http module headers

https://nodejs.org/api/http.html#http_message_rawheaders
