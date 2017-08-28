# hits

A _simple + easy_ way to see how many people have _viewed_ your GitHub Repository.

[![Build Status](https://img.shields.io/travis/dwyl/hits.svg?style=flat-square)](https://travis-ci.org/dwyl/hits)
[![HitCount](http://hits.dwyl.io/dwyl/hits.svg)](https://github.com/dwyl/hits)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/hits/master.svg?style=flat-square)](http://codecov.io/github/dwyl/hits?branch=master)
[![Dependency Status](https://img.shields.io/david/dwyl/hits.svg?style=flat-square)](https://david-dm.org/dwyl/hits)
[![devDependency Status](https://img.shields.io/david/dev/dwyl/hits.svg?style=flat-square)](https://david-dm.org/dwyl/hits#info=devDependencies)


## Why?

We have a _few_ projects on GitHub ... <br />
_Sadly_, we ~~have~~ _had_ no idea how many people
are _reading/using_ the projects because GitHub only shares "[traffic](https://github.com/blog/1672-introducing-github-traffic-analytics)" stats 
for the [_past 14 days_](https://github.com/dwyl/hits/issues/49) and not in "real time".
(_unless people star/watch the repo_)

We want to *know* the popularity of each of our repos
to know what people are finding _useful_ and help us
decide where we need to be investing our time.

## What?

A simple way to add (*very basic*) analytics to your GitHub repos.

There are already *many* "badges" that people use in their repos.
See: [github.com/dwyl/**repo-badges**](https://github.com/dwyl/repo-badges) <br />
But we haven't seen one that gives a "***hit counter***"
of the number of times a GitHub page has been viewed ... <br />
So, in today's mini project we're going to _create_ a _basic **Web Counter**_.

https://en.wikipedia.org/wiki/Web_counter

### What Data to Capture/Store?

The _first_ question we asked ourselves was:
What is the ***minimum possible*** amount of (_useful/unique_)
**data** we can store ***per visit*** (_to one of our projects_)?

1. **date + time** (_timestamp_) ***when*** 
the person visited the site/page. <br />
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/now

2. **url** being visited.

3. **user-agent** the browser/device (_or "crawler"_) visiting the site/page
https://en.wikipedia.org/wiki/User_agent

4. IP Address of the client.

5. **language** of the person's web browser. 
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

| IP Address of Client | User Identifier | User ID | Date+Imte of Request | URL of Request" | HTTP Status Code | Size of Response |
| -------------|:-----------|:--|:------------:|:--------:|:--|--|--|
| 84.91.136.21 | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) | 007 | [05/Aug/2017:16:50:51 -0000] | "GET github.com/dwyl/phase-two HTTP/1.0" | 200 | 42247 |

On further reflection, we think the "Common Log Format" is _inneficient_ 
as it contains a lot of _duplicate_ and some _useless_ data.

We can do better.

### Alternative Log Format (ALF)

From the CLF we can remove: 

+ **IP Address**, **User Identifier** and **User ID** can be condensed into a single hash (_see below_).
+ **GET** - the word is implied by the service we are running (_we only accept GETs_)
+ **Response size** is irrelevant and will be the same for most requests.

| Timestamp     | URL | User Agent  | IP Address   | Language | Hit Count |
| ------------- |:------------|:------------|:------------:|:--------:|
| 1436570536950 | github.com/dwyl/the-book | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) | 84.91.136.21 | EN-GB | 42 |


In the log entry (_example_) described above the first 3 bits of data will 
identify the "user" requesting the page/resource, so rather than duplicating the data in an inefficient string, we can _hash_ it!

Any repeating user-identifying data should be concactenated 

Log entries are stored as a (_"pipe" delimited_) `String` 
which can be parsed and re-formatted into any other format:  

```sh
1436570536950|github.com/dwyl/phase-two|Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)|88.88.88.88|EN-US|42
```

### Reducing Storage Costs

If a person views _multiple_ pages, three pieces of data are duplicated:
User Agent, IP Address and Language.
Rather than storing this data multiple times, we _hash_ the data 
and store the hash as a lookup.

#### Hash Long Repeating (Identical) Data

If we run the following `Browser|IP|Language` `String`:
```sh
'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)|84.91.136.21|EN-US'
```
through a **SHA** hash function we get: `8HKg3NB5Cf` (_always_)<sup>1</sup>.

Sample code:
```js
var hash = require('./lib/hash.js');
var user_agent_string = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)|88.88.88.88|EN-US';
var agent_hash = hash(user_agent_string, 10); // 8HKg3NB5Cf
```

<sup>1</sup>Note: SHA hash is always longer than 

#### Hit Data With Hash

```
1436570536950|github.com/dwyl/the-book|8HKg3NB5Cf|42
```


## How?

Place a badge (*image*) in your repo `README.md` so others can
can see how popular the page is and you can track it.



## _Run_ it Your_self_!

Download (clone) the code to your local machine:

```sh
git clone https://github.com/dwyl/hits.git && cd hits
```

> Note: you will need to have Node.js running on your localhost.

Install dependencies:
```sh
npm install
```
Run locally:
```sh
npm run dev
```
Visit: http://localhost:8000/any/url/count.svg


# Data Storage

Recording the "hit" data is _essential_ 
for this app to _work_ and be _useful_.

We have built it to work with _two_ "data stores": 
Filesystem and Redis <!-- and PostgreSQL. --> <br />
> _**Note**: you only need **one** storage option to be available_.

## Filesystem




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

### Node.js http module headers

https://nodejs.org/api/http.html#http_message_rawheaders

## Running the Test Suite locally

The test suite includes tests for 3 databases
therefore running the tests on your `localhost` 
requires all 3 to be running.

Deploying and _using_ the app only requires _one_ 
of the databases to be available.
