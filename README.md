# hits

![hits-dwyl-teal-banner](https://user-images.githubusercontent.com/194400/30136430-d1b2c2b8-9356-11e7-9ed5-3d84f6e44066.png)

<div align="center">
  
[![Build Status](https://img.shields.io/travis/dwyl/hits.svg?style=flat-square)](https://travis-ci.org/dwyl/hits)
[![HitCount](http://hits.dwyl.io/dwyl/hits.svg)](https://github.com/dwyl/hits)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/hits/master.svg?style=flat-square)](http://codecov.io/github/dwyl/hits?branch=master)
[![Dependency Status](https://img.shields.io/david/dwyl/hits.svg?style=flat-square)](https://david-dm.org/dwyl/hits)
[![devDependency Status](https://img.shields.io/david/dev/dwyl/hits.svg?style=flat-square)](https://david-dm.org/dwyl/hits#info=devDependencies)
</div>

## Why?

We have a _few_ projects on GitHub ... <br />

We want to _instantly see_ the _popularity_ of _each_ of our repos
to know what people are finding _useful_ and help us
decide where we need to be investing our time.


While GitHub has a _basic_
"[traffic](https://github.com/blog/1672-introducing-github-traffic-analytics)" 
[tab](https://github.com/dwyl/start-here/graphs/traffic) 
which displays page view stats, GitHub only records the data
for the [_past 14 days_](https://github.com/dwyl/hits/issues/49)
and then it gets reset. 
The data is not relayed to the "owner" in "***real time***"
and you would need to use the API and "poll" for data ...
_Manually_ checking who has viewed a 
project is _exceptionally_ tedious when you have 
more than a _handful_ of projects.

## What?

A _simple & easy_ way to see how many people 
have _viewed_ your GitHub Repository.

There are already *many* "badges" that people use in their repos.
See: [github.com/dwyl/**repo-badges**](https://github.com/dwyl/repo-badges) <br />
But we haven't seen one that gives a "***hit counter***"
of the number of times a GitHub page has been viewed ... <br />
So, in today's mini project we're going to _create_ a _basic **Web Counter**_.

https://en.wikipedia.org/wiki/Web_counter

## How?

If you simply want to display a "hit count badge" in your project's GitHub page,
visit: http://hits.dwyl.io to get the Markdown!



### Want to _Run_ it Yourself?!

To run the code on your localhost in 3 easy steps:

#### 1. Download the Code:

Download (clone) the code to your local machine:

```sh
git clone https://github.com/dwyl/hits.git && cd hits
```

> Note: you will need to have Node.js running on your localhost.

#### 2. Install the Dependencies

Install dependencies:
```sh
npm install
```

#### 3. Run the Server

Run locally:
```sh
npm run dev
```

Now open _Two_ web browser windows/tabs:
+ _first tab_: http://localhost:8000/ (_this is the hits "home page"_)
+ _second tab_: http://localhost:8000/any/url/count.svg



## Implementation _Detail_

In case anyone wants to know the thought process that went into building this...

### What Data to Capture/Store?

The _first_ question we asked ourselves was:
What is the ***minimum possible*** amount of (_useful/unique_)
**info** we can store ***per visit*** (_to one of our projects_)?

1. **date + time** (_timestamp_) ***when*** 
the person visited the site/page. <br />
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/now

2. **url** being visited. i.e. which project was viewed.

3. **user-agent** the browser/device (_or "crawler"_) visiting the site/page
https://en.wikipedia.org/wiki/User_agent

4. IP Address of the client. (_for checking uniqueness_)

5. **Language** of the person's web browser. 
_Note: While not "essential", we added **Browser Language** 
as the **5th** piece of data (when it is set/sent by the browser/device)
because it's **insightful** to know what language people are using
so that we can determine if we should be **translating**/"**localising**" 
our content._

### "Common Log Format" (CLF) ?

We initially _considered_ using the "Common Log Format" (CLF)
because it's well-known/understood.
see: https://en.wikipedia.org/wiki/Common_Log_Format

An example log entry: 
```
127.0.0.1 user-identifier frank [10/Oct/2000:13:55:36 -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326
```

Real example:
```
84.91.136.21 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) 007 [05/Aug/2017:16:50:51 -0000] "GET github.com/dwyl/phase-two HTTP/1.0" 200 42247
```

The data makes sense when viewed as a table:

| IP Address of Client | User Identifier | User ID | Date+Imte of Request | Request "Verb" and URL of Request | HTTP Status Code | Size of Response |
| ------------- | ----------- | -- | ------------ | -------- | -- | -- |
| 84.91.136.21 | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) | 007 | [05/Aug/2017:16:50:51 -0000] | "GET github.com/dwyl/phase-two HTTP/1.0" | 200 | 42247 |

On further reflection, we think the "Common Log Format" is _inneficient_ 
as it contains a lot of _duplicate_ and some _useless_ data.

We can do better.

### Alternative Log Format ("ALF")

From the CLF we can remove: 

+ **IP Address**, **User Identifier** and **User ID** can be condensed into a single hash (_see below_).
+ "**GET**"" - the word is implied by the service we are running (_we only accept GET requests_)
+ **Response size** is _irrelevant_ and will be the same for most requests.

| Timestamp | URL | User Agent | IP Address | Language | Hit Count |
| ----------| --- | ---------- | ---------- | -------- | --------- |
| 1436570536950 | github.com/dwyl/the-book | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) | 84.91.136.21 | EN-GB | 42 |


In the log entry (_example_) described above the first 3 bits of data will 
identify the "user" requesting the page/resource, so rather than duplicating the data in an inefficient string, we can _hash_ it!

Any repeating user-identifying data should be concactenated 

Log entries are stored as a (_"pipe" delimited_) `String` 
which can be parsed and re-formatted into any other format:  

```sh
1436570536950|github.com/dwyl/phase-two|Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)|88.88.88.88|EN-US|42
```

### Reducing Storage (_Costs_)

If a person views _multiple_ pages, 
_three_ pieces of data are duplicated:
**User Agent**, **IP Address** and **Language** for each request/log.
Rather than storing this data _multiple_ times, 
we _hash_ the data and store the hash as a lookup.

#### Hash Long Repeating (Identical) Data

If we run the following `Browser|IP|Language` `String`:
```sh
'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)|84.91.136.21|EN-US'
```
through a **SHA** hash function we get: `8HKg3NB5Cf` (_always_)<sup>1</sup>.

_Sample_ code:
```js
var hash = require('./lib/hash.js');
var user_agent_string = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)|88.88.88.88|EN-US';
var agent_hash = hash(user_agent_string, 10); // 8HKg3NB5Cf
```

<sup>1</sup>Note: SHA hash is _always_ 40 characters,
but we _truncate_ it because 10 alphanumeric characters (_selected from a set of 26 letters + 10 digits_)
means there are 36<sup>10</sup> = [3,656,158,440,062,976](http://www.wolframalpha.com/input/?i=36%5E10)
(_three and a half [**Quadrillion**](http://www.wolframalpha.com/input/?i=3,656,158,440,062,976+in+english)_) 
possible strings which we consider "_enough_" entropy. 
(_if you disagree, tell us why in an 
  [issue](https://github.com/dwyl/hits/issues)_!)

#### Hit Data With Hash

```
1436570536950|github.com/dwyl/the-book|8HKg3NB5Cf|42
```

We're _sure_ you will agree this is considerably more compact.

> Note: our log also _strips_ the `github.com/` from the url so it's:
```
1436570536950|dwyl/the-book|8HKg3NB5Cf|42
```
Which is a _considerable_ saving on "CLF" (_see above_)

# Data Storage

We aren't using a "Database", rather we are using the filesystem.

## Filesystem

For implementation see:
[`/lib/db_filesystem.js`](https://github.com/dwyl/hits/blob/master/lib/db_filesystem.js)


> Yes, we know Heroku does not give access to the Filesystem...
If you want to run this on Heroku see: https://github.com/dwyl/hits/issues/54

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
https://github.com/dwyl/aguid

### Log Formats

+ Apache Log Sample:
http://www.monitorware.com/en/logsamples/apache.php
(_looked at the existing log formats, all were too verbose/wasteful for us!_)

### Node.js http module headers

https://nodejs.org/api/http.html#http_message_rawheaders

## Running the Test Suite locally

The test suite includes tests for 3 databases
therefore running the tests on your `localhost` 
requires all 3 to be running.

Deploying and _using_ the app only requires _one_ 
of the databases to be available.
