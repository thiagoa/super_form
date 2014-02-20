module Field
  class Base
    attr_accessor :name
    attr_accessor :options
    attr_accessor :form

    def self.factory(*args)
      new(*args)
    end

    def initialize(name, options = {})
      @name    = name
      @options = options
    end

    def setup_container(container)
      @container = container

      if Helper.container_is_virtus?(container)
        inject_attributes
      end

      inject_validations
    end

    def attribute
      String
    end

    def inject_attributes
      @container.attribute @name, attribute
    end

    def inject_validations
      if @options.any?
        @container.send(:validates, @name, @options)
      end
    end

    def value
      @form.send(name) if @form
    end

    def presenter_class
      nil
    end
  end

  module Helper
    def self.container_is_virtus?(container)
      defined?(Virtus::Model::Core) &&
        container.ancestors.include?(Virtus::Model::Core)
    end
  end

  class Proxy
    def initialize(options, &setup)
      @options = options
      @setup   = setup
    end

    def factory(name, options = {})
      @setup.call(name, options, self)
    end

    def method_missing(id, *args)
      @options[id] || super
    end

    def respond_to_missing?(method_name, include_private = false)
      @options.key? method_name
    end
  end
end
