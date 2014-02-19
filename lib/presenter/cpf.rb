require 'cpf'

module Presenter
  class CPF < Each
    def output
      ::CPF.new(value).formatted
    end
  end
end
