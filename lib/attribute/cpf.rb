require 'virtus'

module Attribute
  class CPF < Virtus::Attribute
    def coerce(value)
      ::CPF.new(value).stripped
    end
  end
end
