require 'telephone'

module Presenter
  class Telephone < Each
    def output
      ::Telephone.new(value).formatted
    end
  end
end
