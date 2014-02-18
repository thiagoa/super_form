module SuperForm
  class Fieldset
    include Enumerable

    attr_reader :id, :fields

    def initialize(id)
      @id     = id
      @fields = {}
    end

    def add_field(field)
      @fields[field.name] = field
    end

    def <<(field)
      add_field(field)
    end

    def field(field_id)
      @fields[field_id]
    end

    def [](field_id)
      field(field_id)
    end

    def each(&block)
      @fields.each { |field_id| block.call(field_id) }
    end
  end
end
