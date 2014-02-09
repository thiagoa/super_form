require 'cpf'
require 'cpf_validator'

module Field
  class CPF < ::Field::Base
    def add_validations(klass, options)
      klass.validates name, cpf: true

      if options[:uniqueness]
        unless options[:uniqueness].is_a?(Hash) && options[:uniqueness][:model]
          raise Field::Error, "Must specify a model to validate uniqueness"
        end

        required = { 
          attribute:   name, 
          allow_nil:   true, 
          allow_blank: true
        }

        klass.validates name, uniqueness: options[:uniqueness].merge(required)
        options.reject! { |k| k == :uniqueness }
      end

      super
    end

    def attribute
      ::Attribute::CPF
    end

    def output
      ::CPF.new(value).formatted
    end
  end
end
