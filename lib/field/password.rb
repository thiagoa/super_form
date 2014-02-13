module Field
  class Password < Base
    def inject_attributes
      @container.attribute :"#{name}_confirmation", String

      super
    end

    def add_validations
      @container.validates name, presence: true, if: ->(f){ !f.to_param }
      @container.validates name, confirmation: true, if: ->(f){ !f.to_param }
      @container.validates name, length: { minimum: 5, maximum: 15 }, allow_blank: true

      super
    end
  end
end
