[![Build Status](https://travis-ci.org/ddfreyne/ddplugin.png)](https://travis-ci.org/ddfreyne/ddplugin)
[![Code Climate](https://codeclimate.com/github/ddfreyne/ddplugin.png)](https://codeclimate.com/github/ddfreyne/ddplugin)
[![Coverage Status](https://coveralls.io/repos/ddfreyne/ddplugin/badge.png?branch=master)](https://coveralls.io/r/ddfreyne/ddplugin)
[![Inline docs](http://inch-ci.org/github/ddfreyne/ddplugin.png)](http://inch-ci.org/github/ddfreyne/ddplugin)

# ddplugin

*ddplugin* is a library for managing plugins.

Designing a library so that third parties can easily extend it greatly improves its usefulness. *ddplugin* helps solve this problem using *plugins*, which are classes of a certain type and with a given identifier (Ruby symbol).

This code was extracted from Nanoc, where it has been in production for years.

## Use case

Many projects can make use of plugins. Here are a few examples:

* a **text processing library** with *filters* such as `colorize-syntax`, `markdown` and `smartify-quotes`.

* an **image processing library** with *filters* such as `resize`, `desaturate` and `rotate`.

* a **database driver abstraction** with *connectors* such as `postgres`, `sqlite3` and `mysql`.

* a **document management system** with *data sources* such as `filesystem` and `database`.

In *ddplugin*, the filters, connectors and data sources would be *plugin types*, while the actual plugins, such as `markdown`, `rotate`, `postgres` and `database` would be *plugins*.

A typical way to use plugins would be to store the plugin names in a configuration file, so that the actual plugin implementations can be discovered at runtime.

## Requirements

*ddplugin* requires Ruby 2.1 or higher.

## Versioning

*ddplugin* adheres to [Semantic Versioning 2.0.0](http://semver.org).

## Installation

If your library where you want to use *ddplugin* has a gemspec, add *ddplugin* as a runtime dependency to the gemspec:

```ruby
spec.add_runtime_dependency 'ddplugin', '~> 1.0'
```

If you use Bundler instead, add it to the `Gemfile`:

```ruby
gem 'ddplugin', '~> 1.0'
```

## Usage

Plugin type are classes that extend `DDPlugin::Plugin`:

```ruby
class Filter
  extend DDPlugin::Plugin
end

class DataSource
  extend DDPlugin::Plugin
end
```

To define a plugin, create a class that inherits from the plugin type and sets the identifier:

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

To find a plugin of a given type and with a given identifier, call `.named` on the plugin type, passing an identifier:

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

To get all plugins of a given type, call `.all` on the plugin type:

```ruby
Filter.all
# => [ ERBFilter, HamlFilter ]

DataSource.all
# => [ FilesystemDataSource, PostgresDataSource ]
```

To get the identifier of a plugin, call `.identifier`:

```ruby
Filter.named(:erb).identifier
# => :erb

PostgresDataSource.identifier
# => :postgres
```

## Development

Pull requests and issues are greatly appreciated.

When you submit a pull request, make sure that your change is covered by tests, and that the `README` and [YARD](http://yardoc.org/) source code documentation are still up-to-date.

To run the tests, execute `rake`:

```
% rake
```

## Contact

*ddplugin* is written by Denis Defreyne <denis.defreyne@stoneship.org>
