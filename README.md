<!-- README.md -->
# debian\_bind

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with debian\_bind](#setup)
    * [Beginning with debian\_bind](#beginning-with-debian_bind)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Wrapper for "thias-bind" puppet module to ease poor Debian/Ubuntu support.
Hopefully, this is just a temporary stopgap measure until support is improved.

## Setup

### Beginning with debian\_bind

Include the `debian_bind` class.
```
include ::debian_bind
```

## Usage

See [Reference](#reference) for details.

## Reference

The only class is `::debian_bind` and it's parameters are a concatenation of those in the "thias-bind" class [`::bind`](https://github.com/thias/puppet-bind/blob/0.5.3/manifests/init.pp) and the resource [`::bind::server::conf`](https://github.com/thias/puppet-bind/blob/0.5.3/manifests/server/conf.pp).
See the corresponding manifests or their [README](https://github.com/thias/puppet-bind/blob/0.5.3/README.md) for documentation.

## Limitations

Only supports Debian and Ubuntu.

## Development

Check it out at [github.com/bodhidigital/puppet-debian_bind](https://github.com/bodhidigital/puppet-debian_bind).

<!-- vim: set ts=2 sw=2 et syn=markdown: -->
