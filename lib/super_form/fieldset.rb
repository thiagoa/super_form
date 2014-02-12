require 'set'

module SuperForm
  class Fieldset
    include Enumerable
    
    attr_reader   :id, :fields
    attr_accessor :form

    def initialize(id)
      @id     = id
      @fields = Set.new
    end

    def <<(field_id)
      @fields << field_id
    end

    def [](field_id)
      @fields[field_id]
    end
    
    def each(&block)
      @fields.each { |field_id| block.call(field_id) }
    end
  end
end
