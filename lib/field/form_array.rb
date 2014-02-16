require 'field/form_proxy'

module Field
  class FormArray < Base
    extend FormProxy

    attr_accessor :form_class

    def inject_attributes
      @container.attribute @name, attribute
    end

    def inject_validations
      @container.class_eval %Q{
        method = "__ensure_valid_#{name.to_s}__"
        validate method

        define_method method do
          #{name}.each_with_index do |form, i|
            unless form.send(:valid?)
              errors.add(:base, "Invalid #{name.to_s} on row \#\{i + 1\}")
            end
          end
        end
      }
    end

    def attribute
      Array[@form_class]
    end
  end
end
