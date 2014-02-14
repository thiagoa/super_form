require 'super_form'
require 'spec_helper'

describe Field::Form do
  context 'when creating a form field isolatedly' do
    it 'assigns the child form to the field attribute' do
      child_form = Class.new { include SuperForm }

      field = Field::Form.new(:fake)
      field.form_class = child_form

      expect(field.attribute).to eq child_form
    end
  end

  context 'when the form field has a container' do
    before do
      @child_form = Class.new do
        include SuperForm

        field :name, Field::Text, presence: true

        def self.model_name
          ActiveModel::Name.new(self, nil, 'anonymous')
        end
      end

      parent_form = Class.new { include SuperForm }

      field = Field::Form.new(:child_form)
      field.form_class = @child_form
      field.setup_container(parent_form)

      @parent_form = parent_form.new
    end

    describe '#inject_attributes' do
      it 'injects virtus attributes into the parent form' do
        expect(@parent_form).to respond_to :child_form=
        expect(@parent_form).to respond_to :child_form
      end

      it 'returns an instance of child form as the default value' do
        expect(@parent_form.child_form).to be_instance_of(@child_form)
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
      @child_form = Class.new { include SuperForm }
      proxy = Field::Form[@child_form]

      @field = proxy.factory(:name)
    end

    it 'creates a form instance' do
      expect(@field).to be_instance_of(Field::Form)
    end

    it 'stores the child form into the form_class attribute' do
      expect(@field.form_class).to eq @child_form
    end
  end
end
