require "super_form/version"
require 'super_form/fieldset'
require 'field'
require 'attribute'
require 'virtus'
require 'active_model'

autoload :UniquenessValidator, 'uniqueness_validator'

module SuperForm
  def self.included(klass)
    klass.include Virtus.model
    klass.include ActiveModel::Conversion
    klass.include ActiveModel::Validations
    klass.extend  ActiveModel::Naming
    klass.extend  ActiveModel::Callbacks
    klass.extend  ClassMethods

    add_callbacks(klass)
    add_constructor(klass)
  end

  def self.add_constructor(klass)
    klass.class_eval do
      alias_method :original_initializer, :initialize

      def initialize(*args)
        setup
        original_initializer(*args)
      end
    end
  end

  def self.add_callbacks(klass)
    klass.class_eval do
      alias_method :ar_valid?, :valid?

      def valid?
        run_callbacks :validation do
          ar_valid?
        end
      end

      define_model_callbacks :validation, :save
    end
  end

  def setup
    if self.class.setup
      instance_eval(&self.class.setup)
    end
  end

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

  def persisted?
    false
  end

  def save
    if valid?
      run_callbacks :save do
        persist!
      end
      true
    else
      false
    end
  end

  def persist!; end

  private

  module ClassMethods
    def fieldset(id)
      open_fieldset(id)
      yield
      close_fieldset
    end

    def field(field_id, field_class, options = {})
      field = field_class.factory(field_id, options)
      field.setup_container(self)

      add_field(field)
    end

    def setup(&block)
      @setup = block if block
      @setup
    end

    def fieldsets
      @fieldsets ||= {}
    end

    def fields
      @fields ||= []
    end

    def model_name
      ActiveModel::Name.new(self, nil, to_s.gsub(/Form$/, ''))
    end

    private

    def add_field(field)
      fields << field
      current_fieldset << field.name
    end

    def current_fieldset
      fieldsets[@current] || open_fieldset(:default)
    end

    def open_fieldset(id)
      @current = id
      fieldsets[@current] ||= []
    end

    def close_fieldset
      @current = nil
    end
  end
end
