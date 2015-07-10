# hits

What if there was a *simple+easy* way to see how many people have viewed your GitHub Repository?

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
+ **useragent**


## Research

### User Agents

How many **user-agents** (web browsers + crawlers) are there?
there *appear* to be fewer than a couple of thousand user agents. http://www.useragentstring.com/pages/useragentstring.php
which means we could store them using a numeric index; 1 - 3000

But, storing the useragents using a numeric index means we
need to perform a lookup on each hit which requires network IO ...
(*expensive*!)
What if there was a way of *deriving* a `String` representation of the
the user-agent string ... oh, that's right, here's one I made earlier...
https://github.com/ideaq/aguid
