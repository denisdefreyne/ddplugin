# encoding: utf-8

module DDPlugin

  # The class responsible for keeping track of all loaded plugins.
  class Registry

    # Returns the shared {PluginRegistry} instance, creating it if none exists
    # yet.
    #
    # @return [DDPlugin::Registry] The shared plugin registry
    def self.instance
      @instance ||= self.new
    end

    # Creates a new plugin registry. This should usually not be necessary; it
    # is recommended to use the shared instance (obtained from
    # {DDPlugin::Registry.instance}).
    def initialize
      @identifiers_to_classes = {}
      @classes_to_identifiers = {}
    end

    # Registers the given class as a plugin.
    #
    # @param [Class] superclass The superclass of the plugin
    #
    # @param [Class, String] class_or_name The class to register, or a string,
    #   in which case it will be automatically converted to a proper class.
    #
    # @param [Symbol] identifiers One or more symbols identifying the class
    #
    # @return [void]
    def register(superclass, class_or_name, *identifiers)
      @identifiers_to_classes[superclass] ||= {}
      @classes_to_identifiers[superclass] ||= {}

      identifiers.each do |identifier|
        @identifiers_to_classes[superclass][identifier.to_sym] = class_or_name
        (@classes_to_identifiers[superclass][name_for_class(class_or_name)] ||= []) << identifier.to_sym
      end
    end

    # @param [Class] superclass The superclass of the plugin
    #
    # @param [Class] klass The class to get the identifiers for.
    #
    # @return [Array<Symbol>] An array of identifiers for the given class
    def identifiers_of(superclass, klass)
      (@classes_to_identifiers[superclass] || {})[name_for_class(klass)] || []
    end

    # Finds the plugin that is a subclass of the given class and has the given
    # name.
    #
    # @param [Class] klass The class of the plugin to return
    #
    # @param [Symbol] name The name of the plugin to return
    #
    # @return [Class, nil] The plugin with the given name
    def find(klass, name)
      @identifiers_to_classes[klass] ||= {}
      resolve(@identifiers_to_classes[klass][name.to_sym], klass)
    end

    # Returns all plugins of the given class.
    #
    # @param [Class] klass The class of the plugin to return
    #
    # @return [Enumerable<Class>] A collection of class plugins
    def find_all(klass)
      @identifiers_to_classes[klass] ||= {}
      res = {}
      @identifiers_to_classes[klass].each_pair { |k,v| res[k] = resolve(v, k) }
      res
    end

    # Returns a list of all plugins. The returned list of plugins is an array
    # with array elements in the following format:
    #
    #   { :class => ..., :superclass => ..., :identifiers => ... }
    #
    # @return [Array<Hash>] A list of all plugins in the format described
    def all
      plugins = []
      @identifiers_to_classes.each_pair do |superclass, submap|
        submap.each_pair do |identifier, klass|
          # Find existing plugin
          existing_plugin = plugins.find do |p|
            p[:class] == klass && p[:superclass] == superclass
          end

          if existing_plugin
            # Add identifier to existing plugin
            existing_plugin[:identifiers] << identifier
            existing_plugin[:identifiers] = existing_plugin[:identifiers].sort_by { |s| s.to_s }
          else
            # Create new plugin
            plugins << {
              :class       => klass,
              :superclass  => superclass,
              :identifiers => [ identifier ]
            }
          end
        end
      end

      plugins
    end

  protected

    def resolve(class_or_name, klass)
      if class_or_name.is_a?(String)
        class_or_name.scan(/\w+/).inject(Kernel) do |memo, part|
          memo.const_get(part)
        end
      else
        class_or_name
      end
    end

    def name_for_class(klass)
      klass.to_s.sub(/^(::)?/, '::')
    end

  end

end
