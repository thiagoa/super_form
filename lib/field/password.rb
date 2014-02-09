module Field
  class Password < Base
    def add_attributes(klass, options)
      klass.attribute :"#{name}_confirmation", String

      super
    end

    def add_validations(klass, options)
      klass.validates name, presence: true, if: ->(f){ !f.to_param }
      klass.validates name, confirmation: true, if: ->(f){ !f.to_param }
      klass.validates name, length: { minimum: 5, maximum: 15 }, allow_blank: true

      super
    end

    def output
      nil
    end
  end
end
