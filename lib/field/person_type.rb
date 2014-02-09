require 'person_type'

module Field
  class PersonType < Base
    def attribute
      ::Attribute::PersonType
    end

    def output
      ::PersonType.new(value).description
    end
  end
end
