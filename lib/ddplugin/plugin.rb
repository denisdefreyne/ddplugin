# encoding: utf-8

module DDPlugin

  # A module that contains class methods for plugins. It provides functions
  # for setting identifiers, registering plugins and finding plugins. Plugin
  # classes should extend this module.
  module Plugin

    # @overload identifiers(*identifiers)
    #
    #   Sets the identifiers for this plugin.
    #
    #   @param [Array<Symbol>] identifiers A list of identifiers to assign to
    #     this plugin.
    #
    #   @return [void]
    #
    # @overload identifiers
    #
    #   @return [Array<Symbol>] The identifiers for this plugin
    def identifiers(*identifiers)
      if identifiers.empty?
        DDPlugin::Registry.instance.identifiers_of(self.superclass, self)
      else
        register(self, *identifiers)
      end
    end

    # @overload identifier(identifier)
    #
    #   Sets the identifier for this plugin.
    #
    #   @param [Symbol] identifier An identifier to assign to this plugin.
    #
    #   @return [void]
    #
    # @overload identifier
    #
    #   @return [Symbol] The first identifier for this plugin
    def identifier(identifier=nil)
      if identifier
        self.identifiers(identifier)
      else
        DDPlugin::Registry.instance.identifiers_of(self.superclass, self).first
      end
    end

    # Registers the given class as a plugin with the given identifier.
    #
    # @param [Class, String] class_or_name The class to register, or a
    #   string containing the class name to register.
    #
    # @param [Array<Symbol>] identifiers A list of identifiers to assign to
    #   this plugin.
    #
    # @return [void]
    def register(class_or_name, *identifiers)
      # Find plugin class
      klass = self
      klass = klass.superclass while klass.superclass.respond_to?(:register)

      # Register
      registry = DDPlugin::Registry.instance
      registry.register(klass, class_or_name, *identifiers)
    end

    # @return [Hash<Symbol, Class>] All plugins of this type, with keys
    #   being the identifiers and values the plugin classes
    def all
      DDPlugin::Registry.instance.find_all(self)
    end

    # Returns the plugin with the given name (identifier)
    #
    # @param [String] name The name of the plugin class to find
    #
    # @return [Class] The plugin class with the given name
    def named(name)
      DDPlugin::Registry.instance.find(self, name)
    end

  end

end
