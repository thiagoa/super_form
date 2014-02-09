require 'telephone'
require 'telephone_validator'

module Field
  class Telephone < Base
    def add_validations(klass, options)
      klass.validates name, telephone: true

      super
    end

    def attribute
      ::Attribute::Telephone
    end

    def output
      return unless value
      ::Telephone.new(value).formatted
    end
  end
end
