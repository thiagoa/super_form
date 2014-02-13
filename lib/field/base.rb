module Field
  class Base
    attr_accessor :name
    attr_reader   :value

    def self.factory(*args)
      new(*args)
    end

    def initialize(name, options = {})
      @name    = name
      @options = options
    end

    def setup_container(container)
      @container = container

      inject_attributes
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
