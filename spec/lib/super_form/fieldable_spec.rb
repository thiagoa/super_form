require 'spec_helper'
require 'super_form/fieldable'
require 'field/bare'

describe SuperForm::Fieldable do
  context 'when no fieldset is defined' do
    it 'returns no fieldsets' do
      expect(class_with_no_fields.fieldsets).to eq({})
    end
  end

  context 'when fields and fieldsets are defined' do
    let(:dummy) { class_with_fields }

    it 'has the right number of fields' do
      expect(dummy.fields.length).to eq 5
    end

    it 'has field values which are the same as the form attributes' do
      dummy.name  = 'Thiago'
      dummy.ball  = "Let's have it"
      dummy.car   = "Let's drive it"
      dummy.email = "findme@athome.com"
      dummy.phone = '12345'

      expect(dummy.field(:name).value).to eq dummy.name
      expect(dummy.field(:ball).value).to eq dummy.ball
      expect(dummy.field(:car).value).to eq dummy.car
      expect(dummy.field(:email).value).to eq dummy.email
      expect(dummy.field(:phone).value).to eq dummy.phone
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
  end
end

def class_with_fields(&block)
  Class.new do
    include SuperForm::Fieldable

    attr_accessor :name, :ball, :car, :email, :phone

    fieldset :general do
      field :name, Field::Text, presence: true
    end

    fieldset :toys do
      field :ball, Field::Bare
      field :car,  Field::Text
    end

    field :email, Field::Text
    field :phone, Field::Text, length: { minimum: 4 }

    instance_eval(&block) if block_given?
  end.new
end

def class_with_no_fields
  Class.new do
    include SuperForm::Fieldable
  end
end
