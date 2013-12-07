# encoding: utf-8

module DDPlugin

  # The registry is responsible for keeping track of all loaded plugins.
  class Registry

    # Returns the shared {DDPlugin::Registry} instance, creating it if none
    # exists yet.
    #
    # @return [DDPlugin::Registry] The shared plugin registry
    def self.instance
      @instance ||= self.new
    end

    # @api private
    def initialize
      @identifiers_to_classes = Hash.new { |h,k| h[k] = {}.dup }
      @classes_to_identifiers = Hash.new { |h,k| h[k] = {}.dup }
    end

    # Registers the given class as a plugin.
    #
    # @param [Class] superclass The superclass of the plugin
    #
    # @param [Class] klass The class to register
    #
    # @param [Symbol] identifiers One or more symbols identifying the class
    #
    # @return [void]
    def register(superclass, klass, *identifiers)
      identifiers.each do |identifier|
        @classes_to_identifiers[superclass][klass] ||= []

        @identifiers_to_classes[superclass][identifier] = klass
        @classes_to_identifiers[superclass][klass] << identifier
      end
    end

    # @param [Class] superclass The superclass of the plugin
    #
    # @param [Class] klass The class to get the identifiers for.
    #
    # @return [Array<Symbol>] An array of identifiers for the given class
    def identifiers_of(superclass, klass)
      @classes_to_identifiers[superclass] ||= {}
      @classes_to_identifiers[superclass].fetch(klass, [])
    end

    # Finds the plugin that is a subclass of the given class and has the given
    # identifier.
    #
    # @param [Class] klass The class of the plugin to return
    #
    # @param [Symbol] identifier The identifier of the plugin to return
    #
    # @return [Class, nil] The plugin with the given identifier
    def find(klass, identifier)
      @identifiers_to_classes[klass] ||= {}
      @identifiers_to_classes[klass][identifier]
    end

    # Returns all plugins of the given class.
    #
    # @param [Class] klass The class of the plugin to return
    #
    # @return [Enumerable<Class>] A collection of class plugins
    def find_all(klass)
      @identifiers_to_classes[klass] ||= {}
      @identifiers_to_classes[klass].values
    end

  end

end
