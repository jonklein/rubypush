# RubyPush

A Ruby implementation of the Push 3 programming language for evolutionary computation (http://faculty.hampshire.edu/lspector/push3-description.html).

## Description

RubyPush is a version of the Push programming language for evolutionary computation, and the PushGP genetic programming system, implemented in Ruby. More information about Push and PushGP can be found at http://hampshire.edu/lspector/push.html.

## Command-Line Usage

The RubyPush gem is typically incorporated into other applications, but the command-line "rubypush" script lets you test out  programs from the command-line.

```
rubypush [push-program]
```

Example: 

```
rubypush '(1 2 integer.+)'
```