require 'field/form_proxy'

module Field
  class Form < Base
    extend FormProxy

    attr_accessor :form_class

    def inject_attributes
      @container.attribute @name, attribute, default: attribute.new
    end

    def inject_validations
      @container.class_eval %Q{
        method = "__ensure_valid_#{name.to_s}__"
        validate method

        define_method method do
          unless send('#{name}').send(:valid?)
            errors.add(:base, "Invalid #{name.to_s}")
          end
        end
      }
    end

    def attribute
      @form_class
    end
  end
end
