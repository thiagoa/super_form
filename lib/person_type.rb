class PersonType
  TYPES = [NATURAL = 'natural_person', LEGAL = 'legal_entity']

  attr_writer :value

  def self.description(value, default = '')
    description = case value
    when NATURAL then 'Natural person'
    when LEGAL then 'Legal entity'
    else default
    end

    I18n.t(value, default: description)
  end

  def self.descriptions
    TYPES.each_with_object({}) do |type, hash| 
      hash[type] = description(type) 
    end
  end

  def self.to_collection
    descriptions.map { |k, v| [v, k] }
  end

  def initialize(value)
    @value = value
  end

  def value
    @value if valid?
  end

  def description(default = '')
    self.class.description(@value, default)
  end

  def valid?
    TYPES.include? @value
  end

  def to_s
    value
  end

  class Attribute < Virtus::Attribute
    def coerce(value)
      ::PersonType.new(value).value
    end
  end
end
