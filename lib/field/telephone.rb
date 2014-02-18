require 'telephone'
require 'telephone_validator'

module Field
  class Telephone < Base
    def inject_validations
      @container.validates name, telephone: true

      super
    end

    def attribute
      ::Attribute::Telephone
    end
  end
end
