require 'super_form'
require 'presenter'

describe Presenter::Form do
  it 'outputs each field according to its defined presenter class' do
    field_class_with_presenter_class = Class.new(Field::Base) do
      def presenter_class
        Class.new(Presenter::Each) do
          def self.__name__
            'anonymous'
          end

          def output
            'formatted output'
          end
        end
      end
    end

    field_class_without_presenter_class = Class.new(Field::Base)

    form_class = Class.new do
      include SuperForm

      add_field(field_class_with_presenter_class.new(:with_presenter))
      add_field(field_class_without_presenter_class.new(:without_presenter))
    end

    form = form_class.new(
      with_presenter:    'unformatted output',
      without_presenter: 'unformattable'
    )

    presenter = Presenter::Form.factory(form)

    expect(presenter.with_presenter).to eq('formatted output')
    expect(presenter.without_presenter).to eq('unformattable')
  end
end
