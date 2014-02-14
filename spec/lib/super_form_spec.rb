require 'super_form'
require 'field/bare'
require 'spec_helper'

describe SuperForm do
  it 'is never persisted' do
    expect(form_with_fields.persisted?).to be_false
  end

  context 'when no fieldset is defined' do
    it 'returns no fieldsets' do
      expect(form_with_no_fields.fieldsets).to eq({})
    end
  end

  context 'when fieldsets and fields are defined' do
    let(:dummy) { form_with_fields }

    it 'creates virtus attributes' do
      expect(dummy).to respond_to(:name)
      expect(dummy).to respond_to(:name=)
      expect(dummy).to respond_to(:ball)
      expect(dummy).to respond_to(:ball=)
      expect(dummy).to respond_to(:car)
      expect(dummy).to respond_to(:car=)
    end

    it 'defines fieldsets which contain field ids' do
      general = dummy.fieldset(:general)
      expect(general.fields).to eq Set.new([:name])

      toys = dummy.fieldset(:toys)
      expect(toys.fields).to eq Set.new([:ball, :car])
    end

    it 'assigns the form object to the fieldset objects' do
      expect(dummy.fieldset(:general).form).to eq dummy
      expect(dummy.fieldset(:toys).form).to eq dummy
    end

    it 'uses :default fieldset for fields defined outside a fieldset' do
      default_fieldset = dummy.fieldset(:default)
      expect(default_fieldset.fields).to eq Set.new([:email, :phone])
    end

    it 'is ready for validation' do
      expect(dummy).to_not be_valid
      expect(dummy.errors[:name]).to eq ["can't be blank"]
      expect(dummy.errors[:phone]).to eq ["is too short (minimum is 4 characters)"]
    end

    it 'calls persisted! when a valid form is saved' do
      dummy.name  = 'Dummy'
      dummy.phone = '12345'

      expect(dummy).to receive(:persist!).once
      dummy.save
    end
  end

  context 'when callbacks are defined' do
    it 'triggers callbacks for save' do
      dummy = form_with_fields do
        before_save :callback_call
        after_save :callback_call
      end

      dummy.name = 'Dummy'
      dummy.phone = '12345'

      expect(dummy).to receive(:callback_call).twice
      dummy.save
    end

    it 'triggers callbacks for validation' do
      dummy = form_with_fields do
        before_validation :callback_call
        after_validation :callback_call
      end

      dummy.name = 'Dummy'
      dummy.phone = '12345'

      expect(dummy).to receive(:callback_call).twice
      dummy.valid?
    end
  end

  def form_with_fields(&block)
    Class.new do
      include SuperForm

      fieldset :general do
        field :name, Field::Text, presence: true
      end

      fieldset :toys do
        field :ball, Field::Bare
        field :car,  Field::Text
      end

      field :email, Field::Text
      field :phone, Field::Text, length: { minimum: 4 }

      def self.model_name
        ActiveModel::Name.new(self, nil, 'anonymous')
      end

      instance_eval(&block) if block_given?
    end.new
  end

  def form_with_no_fields
    Class.new do
      include SuperForm
    end
  end
end
