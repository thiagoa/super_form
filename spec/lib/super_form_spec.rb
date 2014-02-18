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
    let!(:dummy) { form_with_fields }

    it 'creates virtus attributes' do
      expect(dummy).to respond_to(:name)
      expect(dummy).to respond_to(:name=)
      expect(dummy).to respond_to(:ball)
      expect(dummy).to respond_to(:ball=)
      expect(dummy).to respond_to(:car)
      expect(dummy).to respond_to(:car=)
      expect(dummy).to respond_to(:email)
      expect(dummy).to respond_to(:email=)
      expect(dummy).to respond_to(:phone)
      expect(dummy).to respond_to(:phone=)
    end

    describe 'form instance fields' do
      it 'has the right number of fields' do
        expect(dummy.fields.length).to eq 5
      end

      it 'has field values which are the same as the form attributes' do
        dummy.attributes = {
          name:  'Thiago',
          ball:  "Let's have it",
          car:   "Let's drive it",
          email: 'findme@athome.com',
          phone: '12345'
        }
        expect(dummy.field(:name).value).to eq dummy.name
        expect(dummy.field(:ball).value).to eq dummy.ball
        expect(dummy.field(:car).value).to eq dummy.car
        expect(dummy.field(:email).value).to eq dummy.email
        expect(dummy.field(:phone).value).to eq dummy.phone
      end
    end

    it 'defines fieldsets which contain form fields' do
      general = dummy.fieldset(:general)
      expect(general.fields).to eq({
        name: dummy.field(:name)
      })

      toys = dummy.fieldset(:toys)
      expect(toys.fields).to eq ({
        ball: dummy.field(:ball),
        car:  dummy.field(:car)
      })
    end

    it 'uses :default fieldset for fields defined outside a fieldset' do
      default = dummy.fieldset(:default)
      expect(default.fields).to eq ({
        email: dummy.field(:email),
        phone: dummy.field(:phone)
      })
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
