module Field
  class Form < Base
    attr_accessor :form_class
    attr_accessor :container

    def self.[](form_class)
      extra = {
        form_class:  form_class,
        field_class: self
      }

      Proxy.new(extra) do |name, options, proxy|
        field = proxy.field_class.new(name, options)
        field.form_class = proxy.form_class
        field
      end
    end

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
