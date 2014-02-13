require 'spec_helper'
require 'super_form'

module Field
  class Null < Base; end
end

class DummyForm
  include SuperForm

  fieldset :general do
    field :name, Field::Text, presence: true
  end

  fieldset :toys do
    field :ball, Field::Null
    field :car,  Field::Text
  end

  field :email, Field::Text
  field :phone, Field::Text, length: { minimum: 4 }

  before_validation :validation_callback_call
  after_validation :validation_callback_call

  before_save :save_callback_call
  after_save :save_callback_call

  def validation_callback_call; end
  def save_callback_call; end

  def persist!; end
end

describe SuperForm do
  let(:dummy_form) { DummyForm.new }

  it 'creates virtus attributes' do
    expect(dummy_form).to respond_to(:name)
    expect(dummy_form).to respond_to(:name=)
    expect(dummy_form).to respond_to(:ball)
    expect(dummy_form).to respond_to(:ball=)
    expect(dummy_form).to respond_to(:car)
    expect(dummy_form).to respond_to(:car=)
  end

  it 'defines fieldsets which contain field ids' do
    general = dummy_form.fieldset(:general)
    expect(general.fields).to eq Set.new([:name])

    toys = dummy_form.fieldset(:toys)
    expect(toys.fields).to eq Set.new([:ball, :car])
  end

  it 'assigns the form to the fieldsets' do
    expect(dummy_form.fieldset(:general).form).to eq dummy_form
    expect(dummy_form.fieldset(:toys).form).to eq dummy_form
  end

  it 'uses the default fieldset when a field is defined outside a fieldset' do
    expect(dummy_form.fieldset(:default).fields).to eq Set.new([:email, :phone])
  end

  it 'is ready for validation' do
    expect(dummy_form).to_not be_valid
    expect(dummy_form.errors[:name]).to eq ["can't be blank"]
    expect(dummy_form.errors[:phone]).to eq ["is too short (minimum is 4 characters)"]
  end

  it 'is never persisted' do
    expect(dummy_form.persisted?).to be_false
  end

  it 'triggers callbacks for validation' do
    dummy_form.name = 'Dummy'
    dummy_form.phone = '12345'

    expect(dummy_form).to receive(:validation_callback_call).twice
    dummy_form.valid?
  end

  it 'triggers callbacks for save' do
    dummy_form.name = 'Dummy'
    dummy_form.phone = '12345'

    expect(dummy_form).to receive(:save_callback_call).twice
    dummy_form.save
  end

  it 'calls the persisted! method when saving a valid form' do
    dummy_form.name  = 'Dummy'
    dummy_form.phone = '12345'
    expect(dummy_form).to receive(:persist!).once
    dummy_form.save
  end
end
