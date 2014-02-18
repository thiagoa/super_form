require 'super_form'
require 'spec_helper'

describe Field::FormArray do
  context 'when creating a form collection field' do
    it 'assigns an array of child forms to the field attribute' do
      child_form = Class.new { include SuperForm }

      field = Field::FormArray.new(:fake)
      field.form_class = child_form

      expect(field.attribute).to eq Array[child_form]
    end
  end

  context 'when the form field has a container' do
    before do
      @child_form = Class.new do
        include SuperForm

        field :name, Field::Text, presence: true
      end

      parent_form = Class.new { include SuperForm }

      field = Field::FormArray.new(:child_form)
      field.form_class = @child_form
      field.setup_container(parent_form)

      @parent_form = parent_form.new
    end

    describe '#inject_attributes' do
      it 'injects attributes into the parent form' do
        expect(@parent_form).to respond_to :child_form=
        expect(@parent_form).to respond_to :child_form
        expect(@parent_form.child_form).to eq []
      end
    end

    describe '#inject validations' do
      it 'forces the parent object to validate the child object' do
        @parent_form.child_form = [@child_form.new, @child_form.new, @child_form.new]
        @parent_form.save
        errors = [
          'Invalid child_form on row 1',
          'Invalid child_form on row 2',
          'Invalid child_form on row 3'
        ]
        expect(@parent_form.errors[:base]).to eq(errors)
      end
    end
  end

  describe '#[]' do
    before do
      @child_form = Class.new { include SuperForm }
      proxy = Field::FormArray[@child_form]

      @field = proxy.factory(:name)
    end

    it 'creates a form instance' do
      expect(@field).to be_instance_of(Field::FormArray)
    end

    it 'stores the child form into the form_class attribute' do
      expect(@field.form_class).to eq @child_form
    end
  end
end
