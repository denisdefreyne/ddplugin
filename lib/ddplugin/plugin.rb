# encoding: utf-8

module DDPlugin

  # A module that contains class methods for plugins. It provides functions
  # for setting identifiers and finding plugins. Plugin classes should extend
  # this module.
  module Plugin

    # @overload identifiers(*identifiers)
    #
    #   Sets the identifiers for this class.
    #
    #   @param [Array<Symbol>] identifiers A list of identifiers to assign to
    #     this class.
    #
    #   @return [void]
    #
    # @overload identifiers
    #
    #   @return [Array<Symbol>] The identifiers for this class
    def identifiers(*identifiers)
      root_class = self
      root_class = root_class.superclass while root_class.superclass.respond_to?(:identifiers)

      if identifiers.empty?
        DDPlugin::Registry.instance.identifiers_of(root_class, self)
      else
        registry = DDPlugin::Registry.instance
        registry.register(root_class, self, *identifiers)
      end
    end

    # @overload identifier(identifier)
    #
    #   Sets the identifier for this class.
    #
    #   @param [Symbol] identifier The identifier to assign to this class.
    #
    #   @return [void]
    #
    # @overload identifier
    #
    #   @return [Symbol] The first identifier for this class
    def identifier(identifier=nil)
      if identifier
        self.identifiers(identifier)
      else
        self.identifiers.first
      end
    end

    # @return [Enumerable<Class>] All classes of this type
    def all
      DDPlugin::Registry.instance.find_all(self)
    end

    # @param [Symbol] identifier The identifier of the class to find
    #
    # @return [Class] The class with the given identifier
    def named(identifier)
      DDPlugin::Registry.instance.find(self, identifier)
    end

  end

end
