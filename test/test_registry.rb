# encoding: utf-8

require 'helper'

class DDPlugin::RegistryTest < Minitest::Test

  class Filter
    extend DDPlugin::Plugin
  end

  class FooFilter < Filter
    identifier :foo
  end

  class BarFilter < Filter
    identifier :bar
  end

  def test_named
    assert_equal FooFilter, Filter.named(:foo)
    assert_equal BarFilter, Filter.named(:bar)
    assert_nil Filter.named(:lksdaffhdlkashlgkskahf)
  end

  def test_register
    FooFilter.send(:identifier, :foozzz)

    registry = DDPlugin::Registry.instance
    filter = registry.find(Filter, :foozzz)

    assert_equal FooFilter, filter
  end

end
