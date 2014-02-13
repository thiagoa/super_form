require 'validates_email_format_of'

module Field
  class Email < Base
    def inject_validations
      @container.validates name, length: { maximum: 155 }
      @container.validates name, email_format: { 
        message: I18n.t('activemodel.errors.messages.email'),
        allow_nil: true,
        allow_blank: true
      }

      if options[:uniqueness]
        unless options[:uniqueness].is_a?(Hash) && options[:uniqueness][:model]
          raise Field::Error, "Must specify a model to validate uniqueness"
        end

        required = { 
          case_sensitive: false, 
          attribute:      name, 
          allow_nil:      true, 
          allow_blank:    true
        }

        @container.validates name, uniqueness: options[:uniqueness].merge(required)
        options.reject! { |k| k == :uniqueness }
      end

      super
    end
  end
end
