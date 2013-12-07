[![Build Status](https://travis-ci.org/ddfreyne/ddplugin.png)](https://travis-ci.org/ddfreyne/ddplugin)
[![Code Climate](https://codeclimate.com/github/ddfreyne/ddplugin.png)](https://codeclimate.com/github/ddfreyne/ddplugin)
[![Coverage Status](https://coveralls.io/repos/ddfreyne/ddplugin/badge.png?branch=master)](https://coveralls.io/r/ddfreyne/ddplugin)

# ddplugin

*DDPlugin* allows you to define *plugins*, which are classes with identifiers, inheriting from a abstract plugin class.

This code was extracted from nanoc, where it has been in production for years.

## Installation

```
gem install ddplugin
```

## Usage

Load *DDPlugin*:

```ruby
require 'ddplugin'
```

Define the plugin types:

```ruby
class Filter
  extend DDPlugin::Plugin
end

class DataSource
  extend DDPlugin::Plugin
end
```

Define plugins (concrete implementations of these plugin types):

```ruby
class ERBFilter < Filter
  identifier :erb
end

class HamlFilter < Filter
  identifier :haml
end

class FilesystemDataSource < DataSource
  identifier :filesystem
end

class PostgresDataSource < DataSource
  identifier :postgres
end
```

Find plugins of a given type and with a given identifier:

```ruby
Filter.named(:erb)
# => ERBFilter
Filter.named(:haml)
# => HamlFilter
DataSource.named(:filesystem)
# => FilesystemDataSource
DataSource.named(:postgres)
# => PostgresDataSource
```

Get all plugins of a given type:

```ruby
Filter.all
# => [ ERBFilter, HamlFilter ]
DataSource.all
# => [ FilesystemDataSource, PostgresDataSource ]
```

Get identifier of a plugin:

```ruby
Filter.named(:erb).identifier
# => :erb
```
