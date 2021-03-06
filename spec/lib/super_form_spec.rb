require 'super_form'
require 'field/bare'
require 'spec_helper'

describe SuperForm do
  it 'includes the Fieldable module' do
    form = Class.new { include SuperForm }
    expect(form.ancestors).to include SuperForm::Fieldable
  end

  it 'runs the setup method when instantiated' do
    form = Class.new do
      include SuperForm
      attr_reader :test_setup

      setup { @test_setup = 'it worked' }
    end

    expect(form.new.test_setup).to eq('it worked')
  end

  it 'is never persisted' do
    form = form_with_fields
    form.name = 'Thiago'
    form.save

    expect(form.persisted?).to be_false
    expect(form_with_no_fields.persisted?).to be_false
  end

  describe 'ActiveModel naming' do
    context 'when the class name method returns nil' do
      it 'relies on to_s to guess the model name' do
        form = Class.new { include SuperForm }

        expect(form).to receive(:name)
        expect(form).to receive(:to_s)

        form.model_name
      end

      it 'returns the correct model name' do
        form = Class.new { include SuperForm }
        form.stub(:to_s).and_return('InexistentForm')

        expect(form.model_name.name).to eq 'Inexistent'
      end
    end

    context 'when the class name method returns the class name' do
      it 'uses the name method to guess the model name' do
        form = Class.new { include SuperForm }
        form.stub(:name).and_return 'InexistentForm'

        expect(form).to receive(:name)

        form.model_name
      end

      it 'returns the correct model name' do
        form = Class.new { include SuperForm }
        form.stub(:name).and_return('InexistentForm')

        expect(form.model_name.name).to eq 'Inexistent'
      end
    end
  end

  context 'when fields and fieldsets are defined' do
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

    instance_eval(&block) if block_given?
  end.new
end

def form_with_no_fields
  Class.new do
    include SuperForm
  end.new
end
