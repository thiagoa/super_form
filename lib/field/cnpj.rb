require 'cnpj'
require 'cnpj_validator'

module Field
  class CNPJ < Base
    def add_validations(klass, options)
      klass.validates name, cnpj: true

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
      ::Attribute::CNPJ
    end

    def output
      ::CNPJ.new(value).formatted
    end
  end
end
