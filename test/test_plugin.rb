# frozen_string_literal: true

require 'helper'

class PluginTest < Minitest::Test
  class IdentifierSample
    extend DDPlugin::Plugin
  end

  class NamedSample
    extend DDPlugin::Plugin
  end

  class AllSample
    extend DDPlugin::Plugin
  end

  class InheritanceSample
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

  def test_identifier_with_string
    klass = Class.new(IdentifierSample)
    assert_nil klass.identifier

    klass.identifier 'asdf'
    assert_equal :asdf, klass.identifier
  end

  def test_identifiers
    klass = Class.new(IdentifierSample)
    assert_empty klass.identifiers

    klass.identifiers :foo1, :foo2
    assert_equal %i[foo1 foo2], klass.identifiers

    klass.identifiers :bar1, :bar2
    assert_equal %i[foo1 foo2 bar1 bar2], klass.identifiers
  end

  def test_identifiers_with_string
    klass = Class.new(IdentifierSample)
    assert_empty klass.identifiers

    klass.identifiers 'foo1', 'foo2'
    assert_equal %i[foo1 foo2], klass.identifiers

    klass.identifiers 'bar1', 'bar2'
    assert_equal %i[foo1 foo2 bar1 bar2], klass.identifiers
  end

  def test_root
    superklass = Class.new(InheritanceSample)
    superklass.identifier :super

    subklass = Class.new(superklass)
    subklass.identifiers :sub, :also_sub

    assert_equal superklass, InheritanceSample.named(:super)
    assert_equal subklass, InheritanceSample.named(:sub)

    assert_equal :sub, subklass.identifier
    assert_equal %i[sub also_sub], subklass.identifiers

    assert_equal InheritanceSample, superklass.root_class
    assert_equal InheritanceSample, subklass.root_class
  end

  def test_named
    klass = Class.new(NamedSample)
    klass.identifier :named_test

    assert_nil NamedSample.named(:unknown)
    assert_equal klass, NamedSample.named(:named_test)
  end

  def test_named_with_string
    klass = Class.new(NamedSample)
    klass.identifier :named_test

    assert_nil NamedSample.named('unknown')
    assert_equal klass, NamedSample.named('named_test')
  end

  def test_all
    klass1 = Class.new(AllSample)
    klass1.identifier :one

    klass2 = Class.new(AllSample)
    klass2.identifier :two

    assert_equal [klass1, klass2], AllSample.all
  end

  def test_all_with_multiple_identifiers
    parent_class = Class.new { extend DDPlugin::Plugin }

    klass1 = Class.new(parent_class)
    klass1.identifier :one_a
    klass1.identifier :one_b

    klass2 = Class.new(parent_class)
    klass2.identifier :two

    assert_equal [klass1, klass2], parent_class.all
  end
end
