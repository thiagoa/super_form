require 'spec_helper'
require 'super_form'

class ParentForm
  include SuperForm
end

class ChildForm
  include SuperForm

  field :empty, Field::Text, presence: true
end

describe Field::Form do
  context 'when creating a form field isolatedly' do
    before do
      @field = Field::Form.new(:fake)
      @field.form_class = ChildForm
    end

    it 'stores the child form as the field attribute' do
      expect(@field.attribute).to eq ChildForm
    end
  end

  context 'when the form field has a container' do
    before do
      field = Field::Form.new(:child_form)
      field.form_class = ChildForm
      field.setup_container(ParentForm)

      @parent_form = ParentForm.new
    end

    describe '#inject_attributes' do
      it 'injects virtus attributes into the parent form' do
        expect(@parent_form).to respond_to :child_form=
        expect(@parent_form).to respond_to :child_form
      end

      it 'returns an instance of child form as the default value' do
        expect(@parent_form.child_form).to be_instance_of(ChildForm)
      end
    end

    describe '#inject validations' do
      it 'forces the parent object to validate the child object' do
        @parent_form.save
        expect(@parent_form.errors[:base]).to eq(['Invalid child_form'])
      end
    end
  end

  describe '#[]' do
    before do
      proxy = Field::Form[ChildForm]
      @field = proxy.factory(:name)
    end

    it 'creates a form instance' do
      expect(@field).to be_instance_of(Field::Form)
    end

    it 'stores the child form into the form_class attribute' do
      expect(@field.form_class).to eq ChildForm
    end
  end
end
