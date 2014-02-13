require 'spec_helper'
require 'telephone'

describe Telephone do
  it "returns true if valid" do
    valid_numbers = ['8436429999', '(84) 1111-1111', '8498741122']

    valid_numbers.each do |number|
      telephone = Telephone.new(number)
      expect(telephone).to be_valid
    end
  end

  it "returns false if not valid" do
    invalid_numbers = ['843649999', '843 aaa', 'aaa 1234 $%']

    invalid_numbers.each do |number|
      telephone = Telephone.new(number)
      expect(telephone).to_not be_valid
    end
  end

  it "returns a stripped number" do
    telephone = Telephone.new('(84) 3642-9999')
    expect(telephone.stripped).to eq('8436429999')
  end

  it "returns a formatted number" do
    telephone = Telephone.new('84 3642-9999')
    expect(telephone.formatted).to eq('(84) 3642-9999')
  end
end
