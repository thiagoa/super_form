require 'virtus'

module Attribute
  class Telephone < Virtus::Attribute
    def coerce(value)
      ::Telephone.new(value).stripped if value
    end
  end
end
