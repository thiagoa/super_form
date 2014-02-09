require 'virtus'
require 'cnpj'

module Attribute
  class CNPJ < Virtus::Attribute
    def coerce(value)
      ::CNPJ.new(value).stripped
    end
  end
end
