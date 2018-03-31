# frozen_string_literal: true

module DDPlugin
  # The registry is responsible for keeping track of all loaded plugins.
  class Registry
    # Returns the shared {DDPlugin::Registry} instance, creating it if none
    # exists yet.
    #
    # @return [DDPlugin::Registry] The shared plugin registry
    def self.instance
      @instance ||= new
    end

    # @api private
    def initialize
      @identifiers_to_classes = Hash.new { |h, k| h[k] = {}.dup }
      @classes_to_identifiers = Hash.new { |h, k| h[k] = {}.dup }
    end

    # Registers the given class as a plugin.
    #
    # @param [Class] root_class The root class of the class to register
    #
    # @param [Class] klass The class to register
    #
    # @param [Symbol] identifiers One or more symbols identifying the class
    #
    # @return [void]
    def register(root_class, klass, *identifiers)
      identifiers.map(&:to_sym).each do |identifier|
        @classes_to_identifiers[root_class][klass] ||= []

        @identifiers_to_classes[root_class][identifier] = klass
        @classes_to_identifiers[root_class][klass] << identifier
      end
    end

    # @param [Class] root_class The root class of the class to find the
    #   identifiers for
    #
    # @param [Class] klass The class to get the identifiers for
    #
    # @return [Array<Symbol>] The identifiers for the given class
    def identifiers_of(root_class, klass)
      @classes_to_identifiers[root_class] ||= {}
      @classes_to_identifiers[root_class].fetch(klass, [])
    end

    # Finds the class that is a descendant of the given class and has the given
    # identifier.
    #
    # @param [Class] root_class The root class of the class to return
    #
    # @param [Symbol] identifier The identifier of the class to return
    #
    # @return [Class, nil] The class with the given identifier
    def find(root_class, identifier)
      identifier = identifier.to_sym
      @identifiers_to_classes[root_class] ||= {}
      @identifiers_to_classes[root_class][identifier]
    end

    # Returns all classes that are registered descendants of the given class.
    #
    # @param [Class] root_class The root class of the class to return
    #
    # @return [Enumerable<Class>] A collection of registered classes
    def find_all(root_class)
      @identifiers_to_classes[root_class] ||= {}
      @identifiers_to_classes[root_class].values.uniq
    end
  end
end
