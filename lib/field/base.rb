module Field
  class Base
    attr_accessor :name
    attr_reader   :value

    def self.factory(*args)
      new(*args)
    end

    def initialize(name, options)
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

    private

    def inject_attributes
      @container.attribute @name, attribute
    end

    def inject_validations
      if @options.any?
        @container.send(:validates, @name, @options)
      end
    end
  end
    end
  end
end
