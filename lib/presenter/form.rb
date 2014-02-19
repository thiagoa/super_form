module Presenter
  class Form < Base
    def self.factory(form)
      presenters = form.fields.each_with_object({}) do |field, p|
        name, field = field
        p[name] = field.presenter_class if field.presenter_class
      end

      presenter_class = Class.new(Base) do
        map presenters

        def self.__name__
          'form'
        end
      end

      presenter_class.new(form)
    end
  end
end
