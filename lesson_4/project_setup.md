# Project Setup

This project doesn't have a template to download; instead, we'll be creating everything from scratch.

### Requirements

1. Install all dependencies and create project structure.

### Implementation

Follow these steps to setup a new project:

  1. Create a directory on your computer for the project.
  2. Create a `Gemfile` within that directory, and within it, add the `pg` gem as a dependency.
  3. Run `bundle install` to install the pg gem.
  4. Create a file called `expense` to contain the application.
  5. Add `#! /usr/bin/env` ruby to the top of expense. This is known as a "hash-bang", and it allows a shell program to execute the script using the Ruby interpreter.
  6. Add the execute permission to the file `expense` with the terminal command `chmod +x expense`.
  7. Require the pg gem within `expense` (but after the hash-bang).
  8. Add code to `expense` to print out "Hello World".
  9. Make sure that expense can be successfully run by typing `./expense` at the command prompt. You should see something like this:

  ```ruby
  $ ./expense
  Hello World
  ```
