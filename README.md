# Hits

![hits-dwyl-teal-banner](https://user-images.githubusercontent.com/194400/30136430-d1b2c2b8-9356-11e7-9ed5-3d84f6e44066.png)

<!-- <div align="center">

[![Build Status](https://img.shields.io/travis/dwyl/hits-phoenix/master.svg?style=flat-square)](https://travis-ci.org/dwyl/hits-phoenix)
[![Inline docs](http://inch-ci.org/github/dwyl/hits-phoenix.svg?style=flat-square)](http://inch-ci.org/github/dwyl/hits-phoenix)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/hits-phoenix/master.svg?style=flat-square)](http://codecov.io/github/dwyl/hits-phoenix?branch=master)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/dwyl/hits-phoenix.svg?style=flat-square)](https://beta.hexfaktor.org/github/dwyl/hits-phoenix)
[![HitCount](http://hits.dwyl.io/dwyl/hits-phoenix.svg)](https://github.com/dwyl/hits-phoenix)

</div> -->


## Why?

@dwyl We have a _few_ projects on GitHub ... <br />

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

### Why Phoenix (Elixir + PostgreSQL/Ecto)?

We wrote our MVP in `Node.js`: https://github.com/dwyl/hits-nodejs
That worked well to test the idea (_before we embraced Phoenix_).
We decided to re-write in `Elixir`/`Phoenix` because we want
the reliability and fault tolerance of `Erlang`,
built-in application monitoring
([`supervisor`](http://erlang.org/doc/man/supervisor.html))
and metrics ([`telemetry`](https://github.com/beam-telemetry/telemetry))
and the built-in support for _highly_ scalable WebSockets
will allow us to build an _awesome_ UX!

For more on "Why Elixir?" see:
https://github.com/dwyl/learn-elixir/issues/102



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



### _Run_ the App on `localhost`

To _run_ the app on your localhost follow these easy steps:

#### 0. Ensure your `localhost` has Node.js & Phoenix installed

see: [before you start](https://github.com/dwyl/phoenix-chat-example#0-pre-requisites-before-you-start)


#### 1. Clone/Download the Code

```
git clone https://github.com/dwyl/hits.git && cd hits
```

#### 2. Install the Dependencies

Install elixir/node dependencies
and setup Webpack static asset compilation (_with hot reloading_):

```
mix deps.get
cd assets && npm install
node node_modules/webpack/bin/webpack.js --mode development && cd ..
```

#### 3. Create the database

```
mix ecto.create && mix ecto.migrate
```

### 4. Run the App

```
mix phx.server
```

That's it! <br />


Visit: http://localhost:4000/ (_in your web browser_)


## TODO: Update Screenshot of Localhost when Working

![hits-homepage](https://user-images.githubusercontent.com/194400/30294516-3dc31aca-9735-11e7-9e07-29a74e7c6bf0.png)

Or visit _any_ endpoint that includes `.svg` in the url,
e.g: http://localhost:8080/yourname/project.svg

![hits-example-badge](https://user-images.githubusercontent.com/194400/30294601-915b28b2-9735-11e7-8c56-c3ea6f414ded.png)

Refresh the page a few times and watch the count go up!

![hit-count-42](https://user-images.githubusercontent.com/194400/30295139-7db6c008-9737-11e7-9098-9488319e1271.png)

> note: I've increased the "zoom" in chrome to 500% for _effect_.


Now, take your time to peruse the code in `/test` and `/lib`,
and _ask_ any questions by opening GitHub Issues:
https://github.com/dwyl/hits-phoenix/issues


### Run the Tests

You

```elixir
mix test
```

If you want to run the tests with coverage, copy-paste the following command
into your terminal:

```elixir
mix cover
```
If you want to view the coverage in a web browser:

```elixir
mix cover && open cover/excoveralls.html
```

# _Implementation_




### Assumptions / Prerequisites

+ [x] Elixir installed: https://github.com/dwyl/learn-elixir#how
+ [x] Basic knowledge/understanding of Elixir syntax:
https://elixir-lang.org/crash-course.html
+ [x] Basic understanding of Phoenix:
https://github.com/dwyl/learn-phoenix-framework

## Create New Phoenix App


```sh
mix phx.new hits
```

##

```sh

```







## Research & Background Reading

We found the following links/articles/posts _useful_
when learning how to build this mini-project:

### Plug (_the Elixir HTTP Library_)

+ Plug Docs: https://hexdocs.pm/plug/readme.html (_the official Plug docs_)
+ Plug Conn (_connection struct specific_) Docs:
https://hexdocs.pm/plug/Plug.Conn.html
(_the are feature-complete but no practical/usage examples!_)
+ Understanding Plug (Phoenix Blog): https://hexdocs.pm/phoenix/plug.html
+ Elixir School Plug:
https://elixirschool.com/en/lessons/specifics/plug/
+ Getting started with Plug in Elixir:
http://www.brianstorti.com/getting-started-with-plug-elixir
(_has a good/simple example of "Plug.Builder"_)
+ Elixir Plug unveiled:
https://medium.com/@kansi/elixir-plug-unveiled-bf354e364641
+ Building a web framework from scratch in Elixir:
https://codewords.recurse.com/issues/five/building-a-web-framework-from-scratch-in-elixir
+ Testing Plugs: https://robots.thoughtbot.com/testing-elixir-plugs

### SHA Cryptographic Hash Functions in Elixir/Erlang

+ Cryptographic hash functions in Elixir by [@djm](https://github.com/djm):
https://www.djm.org.uk/posts/cryptographic-hash-functions-elixir-generating-hex-digests-md5-sha1-sha2/

### Mix Tasks

+ How to create your own Mix Tasks:
http://joeyates.info/2015/07/25/create-a-mix-task-for-an-elixir-project/


### Compact sub-string syntax

```elixir
iex> "1test2" == "test"
false
iex> "1test2" =~ "test"
true
```
