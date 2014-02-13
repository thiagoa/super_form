require 'cpf'
require 'cpf_validator'

module Field
  class CPF < Base
    def inject_validations
      @container.validates name, cpf: true

      if options[:uniqueness]
        unless options[:uniqueness].is_a?(Hash) && options[:uniqueness][:model]
          raise Field::Error, "Must specify a model to validate uniqueness"
        end

        required = { 
          attribute:   name, 
          allow_nil:   true, 
          allow_blank: true
        }

        options[:uniqueness].merge!(required)
        @container.validates name, uniqueness: options[:uniqueness]

        options.reject! { |k| k == :uniqueness }
      end

      super
    end

    def attribute
      ::Attribute::CPF
    end
  end
end
