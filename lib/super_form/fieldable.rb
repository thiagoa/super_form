require 'active_support/concern'
require 'active_model'
require 'field'

module SuperForm
  module Fieldable
    extend ActiveSupport::Concern
    include ActiveModel::Model

    def fields
      @fields ||= self.class.fields.each_with_object({}) do |field, f|
        f[field.name] = field.dup
        f[field.name].form = self
      end
    end

    def field(name)
      fields.fetch(name)
    end

    def fieldsets
      @fieldsets ||= self.class.fieldsets.each_with_object({}) do |fieldset, f|
        id, fields = fieldset

        fields.each_with_object(f) do |field|
          (f[id] ||= Fieldset.new(id)) << self.field(field)
        end
      end
    end

    def fieldset(id)
      fieldsets.fetch(id)
    end

    module ClassMethods
      def field(field_id, field_class, options = {})
        field = field_class.factory(field_id, options)
        add_field(field)
      end

      def fields
        @fields ||= []
      end

      def fieldset(id)
        open_fieldset(id)
        yield
        close_fieldset
      end

      def fieldsets
        @fieldsets ||= {}
      end

      private

      def add_field(field)
        field.setup_container(self)

        fields << field
        current_fieldset << field.name
      end

      def open_fieldset(id)
        @current = id
        fieldsets[@current] ||= []
      end

      def close_fieldset
        @current = nil
      end

      def current_fieldset
        fieldsets[@current] || open_fieldset(:default)
      end
    end
  end
end
