require 'person_type'

module Presenter
  class PersonType < Each
    def output
      ::PersonType.new(value).description
    end
  end
end
