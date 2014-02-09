require 'virtus'

module Attribute
  class PersonType < Virtus::Attribute
    def coerce(value)
      ::PersonType.new(value).value
    end
  end
end
