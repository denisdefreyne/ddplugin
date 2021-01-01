# frozen_string_literal: true

require_relative 'lib/ddplugin/version'

Gem::Specification.new do |s|
  s.name        = 'ddplugin'
  s.version     = DDPlugin::VERSION
  s.homepage    = 'http://github.com/ddfreyne/ddplugin/'
  s.summary     = 'Plugins for Ruby apps'
  s.description = 'Provides plugin management for Ruby projects'

  s.author  = 'Denis Defreyne'
  s.email   = 'denis.defreyne@stoneship.org'
  s.license = 'MIT'

  s.required_ruby_version = '>= 2.5'

  s.files              = Dir['[A-Z]*'] +
                         Dir['{lib,test}/**/*'] +
                         ['ddplugin.gemspec']
  s.require_paths      = ['lib']

  s.rdoc_options     = ['--main', 'README.md']
  s.extra_rdoc_files = ['LICENSE', 'README.md', 'NEWS.md']
end
