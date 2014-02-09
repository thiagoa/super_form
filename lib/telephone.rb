class Telephone
  FORMAT = /\A(\d{2})(\d{4})(\d{4})\Z/

  attr_accessor :number

  def initialize(number)
    @number = number
  end

  def stripped
    @number.gsub /[^\d]/, ''
  end

  def formatted
    stripped.gsub FORMAT, "(\\1) \\2-\\3"
  end

  def valid?
    stripped.match FORMAT
  end

  def to_s
    formatted
  end
end
