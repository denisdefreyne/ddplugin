# encoding: utf-8

require 'helper'

class DDPlugin::PluginTest < Minitest::Test

  class IdentifierSample
    extend DDPlugin::Plugin
  end

  class NamedSample
    extend DDPlugin::Plugin
  end

  class AllSample
    extend DDPlugin::Plugin
  end

  def test_identifier
    klass = Class.new(IdentifierSample)
    assert_nil klass.identifier

    klass.identifier :foo
    assert_equal :foo, klass.identifier

    klass.identifier :bar
    assert_equal :foo, klass.identifier
  end

  def test_identifiers
    klass = Class.new(IdentifierSample)
    assert_empty klass.identifiers

    klass.identifiers :foo1, :foo2
    assert_equal [ :foo1, :foo2 ], klass.identifiers

    klass.identifiers :bar1, :bar2
    assert_equal [ :foo1, :foo2, :bar1, :bar2 ], klass.identifiers
  end

  def test_named
    klass = Class.new(NamedSample)
    klass.identifier :named_test

    assert_nil NamedSample.named(:unknown)
    assert_equal klass, NamedSample.named(:named_test)
  end

  def test_all
    klass1 = Class.new(AllSample)
    klass1.identifier :one

    klass2 = Class.new(AllSample)
    klass2.identifier :two

    assert_equal [ klass1, klass2 ], AllSample.all
  end

end
