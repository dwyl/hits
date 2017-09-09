# Example

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
git clone https://github.com/nelsonic/hits-elixir.git && cd hits-elixir
```

### 2. Install the Dependencies

```
mix deps.get
```

### 3. Run the App

```
mix run --no-halt
```

That's it! <br />

Now, take your time to peruse the code in `/test` and `/lib`,
and _ask_ any questions by opening GitHub Issues:
https://github.com/nelsonic/hits-elixir/issues


## Research & Background Reading

We found the following links/articles/posts _useful_ 
when learning how to build this mini-project:

### Plug (_the Elixir HTTP Libirary_)

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

### SHA Cryptographic Hash Functions

+ Cryptographic hash functions in Elixir by [@djm](https://github.com/djm):
https://www.djm.org.uk/posts/cryptographic-hash-functions-elixir-generating-hex-digests-md5-sha1-sha2/

### Mix Tasks

+ How to create your own Mix Tasks:
http://joeyates.info/2015/07/25/create-a-mix-task-for-an-elixir-project/
