module Field
  class Base
    attr_accessor :name
    attr_accessor :form
    attr_accessor :value
    attr_reader   :fieldset

    def initialize(name, fieldset)
      @name     = name
      @fieldset = fieldset
    end

    def add_attributes(klass, options)
      klass.attribute name, self.attribute
    end

    def add_validations(klass, options)
      if options.any?
        klass.send(:validates, name, options)
      end
    end

    def form?
      false
    end

    def attribute
      String
    end

    def output
      value
    end
  end
end
