require 'spec_helper'
require 'person_type'

describe PersonType do
  describe '#valid?' do
    it "returns false when person type is invalid" do
      invalid_values = %w{one two three four 3244}

      invalid_values.each do |value|
        person = PersonType.new(value)
        expect(person).to_not be_valid
      end
    end

    it "returns true when person type is valid" do
      valid_values = [PersonType::NATURAL, PersonType::LEGAL]

      valid_values.each do |value|
        person = PersonType.new(value)
        expect(person).to be_valid
      end
    end
  end

  describe "#value" do
    context "with a valid value" do
      it "returns the value" do
        person = PersonType.new(PersonType::LEGAL)
        expect(person.value).to eq PersonType::LEGAL
      end
    end

    context "with an invalid value" do
      it "returns nil" do
        person = PersonType.new('bossal')
        expect(person.value).to be_nil
      end
    end
  end

  describe '#description' do
    it 'returns "Natural person" when value is "natural"' do
      person = PersonType.new(PersonType::NATURAL)
      expect(person.description).to eq 'Natural person'
    end

    it 'returns "Legal entity" when value is "legal"' do
      person = PersonType.new(PersonType::LEGAL)
      expect(person.description).to eq 'Legal entity'
    end

    it 'returns a default description otherwise' do
      person = PersonType.new('bossal')
      expect(person.description('Bossal')).to eq 'Bossal'
    end
  end

  describe '.to_collection' do
    it "returns an array with the collection" do
      expect(PersonType.to_collection).to eq [
        ['Natural person', PersonType::NATURAL],
        ['Legal entity',   PersonType::LEGAL],
      ]
    end
  end
end
