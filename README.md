# hits

What if there was a *simple+easy* way to see how many people have viewed your GitHub Repository?

[![Build Status](https://travis-ci.org/dwyl/hits.svg)](https://travis-ci.org/dwyl/hits)
[![HitCount](https://hitt.herokuapp.com/nelsonic/hits.svg)](https://github.com/nelsonic/hits)
[![codecov.io](http://codecov.io/github/dwyl/hits/coverage.svg?branch=master)](http://codecov.io/github/dwyl/hits?branch=master)
[![Dependency Status](https://david-dm.org/dwyl/hits.svg)](https://david-dm.org/dwyl/hits)
[![devDependency Status](https://david-dm.org/dwyl/hits/dev-status.svg)](https://david-dm.org/dwyl/hits#info=devDependencies)


## Why?

We have a _few_ projects on GitHub ... 
but _sadly_, we ~~have~~ _had_ no idea how many people
are looking at the repos <br />
unless they star/watch them; 
GitHub does not share any stats with people using their site.

We would like to *know* the popularity of each of our repos
to know where we need to be investing our time.

## What?

A simple way to add (*very basic*) analytics to your GitHub repos.

There are already *many* "badges" that people use in their repos.
See: [github.com/dwyl/**repo-badges**](https://github.com/dwyl/repo-badges) <br />
But we haven't seen one that gives a "***hit counter***"
of the number of times a page has been viewed ... <br />
So we decided to create one.


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


Log entries are stored as a (_"pipe" delimited_) `String` 
which can be parsed and re-formatted into any other format:  

```sh
1436570536950|github.com/dwyl/the-book|Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)|88.88.88.88|EN-US
```
This is perhaps best viewed as a table:

| Timestamp     | URL | User Agent  | IP Address   | Language |
| ------------- |:------------|:------------|:------------:|:--------:|
| 1436570536950 | github.com/dwyl/the-book | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) | 84.91.136.21 | EN-GB    |


### Reducing Storage Costs

If a person views multiple pages, three pieces of data are duplicated:
User Agent, IP Address and Language.
Rather than storing this data multiple times, we _hash_ the data 
and store the hash as a lookup.

#### Hash Long Data

If we run the following Browser|IP|Language `String`
```sh
'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)|84.91.136.21|EN-US'
```
through a **sha512** hash function we get: `8HKg3NB5Cf` (_always_).

Sample code:
```js
var hash = require('./lib/hash.js');
var user_agent_string = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)|88.88.88.88|EN-US';
var agent_hash = hash(user_agent_string, 10); // 8HKg3NB5Cf
```

#### Hit Data With Hash

```
1436570536950|github.com/dwyl/the-book|8HKg3NB5Cf
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
