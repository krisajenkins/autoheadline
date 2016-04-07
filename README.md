# AutoHeadline - A HackerNews Headline Generator

Written for June 2015's [West London Hack Night](http://www.meetup.com/West-London-Hack-Night/).

[See it live here](http://krisajenkins.github.io/autoheadline/).

## Building

You'll need Elm 0.16, make and lessc. Then just run `make` in the top-level
directory and the files are built into `dist/`.

## Directory Structure

`src/App.elm`

Generic app wiring. This file will probably look about the same in every Elm app you'll write.

`src/Markov.elm`

A library for making Markov chains.

`src/Rest.elm`

Everything to do with REST & JSON.

`src/Types.elm`

The datatypes the define our app, and some (pure) functions for manipulating them.

`src/State.elm`

App starting state `(Model, Effects Action)`, and the `Action` handlers.

`src/View.elm`

Rendering functions.
