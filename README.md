[![Build Status](https://travis-ci.org/GeoffWilliams/puppet-filemagic.svg?branch=master)](https://travis-ci.org/GeoffWilliams/puppet-filemagic)
# filemagic

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with filemagic](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Do you like files?  Do you like magic?  If so, this is the module for you!  Puppet is a great language but out-of-the-box it expects and demands that you do things _The Puppet Way_ which isn't always possible.

Take for example the following situations:
* Your maintaining a fleet of brownfield production machines with an unknown state
* You must follow your installation orders and they say to edit, not replace files
* Files shared between multiple 'owners' e.g., modules, people, programs, etc
* You need to do really simple edit(s)!

## Features

### Planned
* Append data to a file
* Un-append data to a file
* Make a file 'sandwich' (insert data into a point inside the file)
* Un-make a file 'sandwich'
* Find and replace
* Delete
* Comment (not *ML)

### Implemented

#### fm_prepend
* Prepend lines to a file
* Un-prepend lines to a file

## Setup
* There is no setup and FileMagic is cross platform!  Please [create an issue](https://github.com/GeoffWilliams/puppet-filemagic/issues/new) if you find this not to be the case.


## Usage

This section is where you describe how to customize, configure, and do the
fancy stuff with your module here. It's especially helpful if you include usage
examples and code samples for doing things with your module.

## Reference
[generated documentation](https://rawgit.com/GeoffWilliams/puppet-filemagic/master/doc/index.html).

Reference documentation is generated directly from source code using [puppet-strings](https://github.com/puppetlabs/puppet-strings).  You may regenerate the documentation by running:

```shell
bundle exec puppet strings
```


The documentation is no substitute for reading and understanding the module source code, and all users should ensure they are familiar and comfortable with the operations this module performs before using it.

## Limitations

* Not supported by Puppet, Inc.
* Not intended for use with 'large' files - entire file to be edited is presently read into memory

## Development

PRs accepted :)

## Testing
This module supports testing using [PDQTest](https://github.com/declarativesystems/pdqtest).


Test can be executed with:

```
bundle install
make
```


See `.travis.yml` for a working CI example
