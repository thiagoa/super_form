require 'spec_helper'
require 'super_form'
require 'active_model'

module Field
  class Null < Base; end
end

class DummyForm
  include SuperForm
end

describe SuperForm do
  before(:all) do
    DummyForm.class_eval do
      fieldset :general do
        field :name, Field::Text, presence: true
      end

      fieldset :toys do
        field :ball, Field::Null
        field :car,  Field::Text
      end
    end

    @dummy_form = DummyForm.new
  end

  context 'when a field is defined at class level' do
    before(:all) { @fields = DummyForm.fields }
    
    it 'stores the basic field objects at class level' do
      expect(@fields.fetch(:name)).to be_instance_of Field::Text
      expect(@fields.fetch(:ball)).to be_instance_of Field::Null
      expect(@fields.fetch(:car)).to be_instance_of Field::Text
    end

    it 'assigns the fieldset to the field' do
      expect(@fields.fetch(:name).fieldset).to eq :general
      expect(@fields.fetch(:ball).fieldset).to eq :toys
      expect(@fields.fetch(:car).fieldset).to eq :toys
    end
  end

  context 'when a form object is created' do
    before(:each) { @dummy_form = DummyForm.new }

    # this can get better, but for now it's ok
    it 'creates virtus attributes' do
      expect(@dummy_form).to respond_to(:name)
      expect(@dummy_form).to respond_to(:name=)
      expect(@dummy_form).to respond_to(:ball)
      expect(@dummy_form).to respond_to(:ball=)
      expect(@dummy_form).to respond_to(:car)
      expect(@dummy_form).to respond_to(:car=)
    end

    it 'assigns the fieldset id to the field' do
      expect(@dummy_form.field(:name).fieldset).to eq :general
      expect(@dummy_form.field(:ball).fieldset).to eq :toys
      expect(@dummy_form.field(:car).fieldset).to eq :toys
    end

    it 'defines fieldsets containing the bundled fields' do
      general = @dummy_form.fieldsets.fetch(:general)

      expect(general.first).to be_instance_of Field::Text
      expect(general.first.name).to eq :name

      toys = @dummy_form.fieldsets.fetch(:toys)

      expect(toys.first).to be_instance_of Field::Null
      expect(toys.first.name).to eq :ball

      expect(toys.last).to be_instance_of Field::Text
      expect(toys.last.name).to eq :car
    end

    it 'fieldsets fields are the same instance of fields' do
      @dummy_form.fieldsets.each do |id, fields|
        fields.each do |field|
          expect(field).to eq @dummy_form.field(field.name)
        end
      end
    end

    it 'is ready for validation' do
      expect(@dummy_form).to_not be_valid
      expect(@dummy_form.errors[:name]).to eq ["can't be blank"]
    end

    context 'when assigning a new attribute' do
      it 'assigns the value of the attribute to the field' do
        pending
      end
    end
  end
end
