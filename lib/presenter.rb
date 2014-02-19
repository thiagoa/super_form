require 'delegate'
require 'active_support/inflector'

module Presenter
  autoload :CPF,        'presenter/cpf'
  autoload :CNPJ,       'presenter/cnpj'
  autoload :Telephone,  'presenter/telephone'
  autoload :Password,   'presenter/password'
  autoload :PersonType, 'presenter/person_type'

  class Base < SimpleDelegator
    def self.map(params)
      params.each { |p| setup_attribute(p) }
    end

    def self.use(*presenters)
      params = presenters.each_with_object({}) do |id, p|
        p[id] = id
      end

      map params
    end

    private

    def self.setup_attribute(params)
      attribute, presenter = params
      method = "#{presenter}_presenter"

      def_presenter_accessor(presenter, method)
      def_attribute_reader(attribute, method)
    end

    def self.def_presenter_accessor(presenter, method)
      attr_writer method

      define_method(method) do
        instance_variable_get(:"@#{method}") ||
          self.class.find_presenter(presenter)
      end
    end

    def self.def_attribute_reader(attribute, presenter_method)
      define_method(attribute) do
        presenter = send(presenter_method)
        presenter.value = __getobj__.send(attribute)
        presenter.output
      end
    end

    def self.find_presenter(name)
      base_class = name.to_s.capitalize.camelize
      Object.const_get("Presenter::#{base_class}").new
    end
  end

  class Each
    attr_accessor :value

    def initialize(value = nil)
      self.value = value
    end

    def output
      value
    end

    def to_s
      output
    end
  end
end
