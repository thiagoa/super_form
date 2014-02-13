require 'person_type'

module Field
  class PersonType < Base
    def attribute
      ::Attribute::PersonType
    end
  end
end
