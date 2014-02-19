require 'cnpj'

module Presenter
  class CNPJ < Each
    def output
      ::CNPJ.new(value).formatted
    end
  end
end
