# Hits Elixir

![hits-dwyl-teal-banner](https://user-images.githubusercontent.com/194400/30136430-d1b2c2b8-9356-11e7-9ed5-3d84f6e44066.png)

<div align="center">

[![Build Status](https://img.shields.io/travis/dwyl/hits-elixir.svg?style=flat-square)](https://travis-ci.org/dwyl/hits-elixir)
[![Inline docs](http://inch-ci.org/github/dwyl/hits-elixir.svg?style=flat-square)](http://inch-ci.org/github/dwyl/hits-elixir)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/hits-elixir/master.svg?style=flat-square)](http://codecov.io/github/dwyl/hits-elixir?branch=master)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/dwyl/hits-elixir.svg?style=flat-square)](https://beta.hexfaktor.org/github/dwyl/hits-elixir)
[![HitCount](http://hits.dwyl.io/dwyl/hits-elixir.svg)](https://github.com/dwyl/hits-elixir)

</div>

<br />
Elixir implementation of: https://github.com/dwyl/hits

## Why?

Because _Elixir_ == :heart:!! see:
[github.com/dwyl/**learn-elixir#why**](https://github.com/dwyl/learn-elixir#why)

## _What_?

A basic "web counter". see: https://github.com/dwyl/hits#what


### Assumptions / Prerequisites

+ [x] Elixir installed: https://github.com/dwyl/learn-elixir#how
+ [x] Basic knowledge/understanding of Elixir syntax:
https://elixir-lang.org/crash-course.html


## _How_?

To _run_ the app on your localhost follow these 3 easy steps:

### 1. Clone/Download the Code

```
git clone https://github.com/dwyl/hits-elixir.git && cd hits-elixir
```

### 2. Install the Dependencies

Install dependencies and create necessary directories (_to store the data_):

```
mix deps.get && mkdir -p logs/agents
```

### 3. Run the App

```
mix run --no-halt
```

That's it! <br />


Visit: http://localhost:8080/ (_in your web browser_)

![hits-homepage](https://user-images.githubusercontent.com/194400/30294516-3dc31aca-9735-11e7-9e07-29a74e7c6bf0.png)

Or visit _any_ endpoint that includes `.svg` in the url,
e.g: http://localhost:8080/yourname/project.svg

![hits-example-badge](https://user-images.githubusercontent.com/194400/30294601-915b28b2-9735-11e7-8c56-c3ea6f414ded.png)

Refresh the page a few times and watch the count go up!

![hit-count-42](https://user-images.githubusercontent.com/194400/30295139-7db6c008-9737-11e7-9098-9488319e1271.png)

> note: I've increased the "zoom" in chrome to 500% for _effect_.


Now, take your time to peruse the code in `/test` and `/lib`,
and _ask_ any questions by opening GitHub Issues:
https://github.com/dwyl/hits-elixir/issues


### Run the Tests

You

```elixir
mix test
```

If you want to run the tests with coverage, copy-paste the following command
into your terminal:

```elixir
MIX_ENV=test mix do coveralls.json
```
If you want to view the coverage in a web browser:

```elixir
MIX_ENV=test mix coveralls.html && open cover/excoveralls.html
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

+ http://elixir-recipes.github.io/strings/checking-if-strings-contain-substring

### Generate Random Strings in Elixir

```
:rand.uniform(n)
```

+ https://stackoverflow.com/questions/38778054/how-to-generate-a-random-number-in-elixir

### Unix Timestamp in Elixir

```elixir
iex> DateTime.utc_now |> DateTime.to_unix
1486035766

iex> System.system_time(:second)
1486035766

iex> System.system_time(:millisecond)
1504975995312
```

+ http://michal.muskala.eu/2017/02/02/unix-timestamps-in-elixir-1-4.html
