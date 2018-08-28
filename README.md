[![Build Status](https://travis-ci.org/GeoffWilliams/puppet-filemagic.svg?branch=master)](https://travis-ci.org/GeoffWilliams/puppet-filemagic)
# filemagic

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with filemagic](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Do you like files?  Do you like magic?  If so, this is the module for you!  Puppet is a great language but out-of-the-box it expects and demands that you do things _The Puppet Way_ which isn't always possible.

Take for example the following situations:
* Your maintaining a fleet of brownfield production machines with an unknown state
* You must follow your installation orders and they say to edit, not replace files
* Files shared between multiple 'owners' e.g., modules, people, programs, etc
* You don't want to fully template a file in order to receive upstream fixes
* You need to do really simple edit(s)!

## Features

### Planned
* Make a file 'sandwich' (insert data into a point inside the file)
* Un-make a file 'sandwich'
* Delete
* Comment (not *ML)

### Implemented

#### fm_append
* Append data to a file
* Un-append data to a file
* Specify `match_start` - The first line of input to append from, for cases where some data already exists

#### fm_gsub
* Replace a regular expression
* Delete a regular expression

#### fm_prepend
* Prepend data to a file
* Un-prepend data to a file
* Specify `match_end` - The last line of input to prepend to, for cases where some data already exists

#### fm_replace
* Find and replace lines of data in a file
* Un-replace (delete) matching lines
* Matches all instances of the `match` regexp and replaces/deletes as requested

## Setup
* There is no setup and FileMagic is cross platform!  Please [create an issue](https://github.com/GeoffWilliams/puppet-filemagic/issues/new) if you find this not to be the case.

## Usage
See reference and examples

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
