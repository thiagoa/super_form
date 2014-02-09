require "super_form/version"

require 'field'
require 'attribute'
require 'virtus'
require 'active_support/inflector'
require 'active_support/concern'
require 'active_model'

autoload :UniquenessValidator, 'uniqueness_validator'

module SuperForm
  def self.included(klass)
    virtus = if @virtus_options
      Virtus.model(@virtus_options)
    else
      Virtus.model
    end

    klass.include virtus
    klass.include ActiveModel::Conversion
    klass.include ActiveModel::Validations
    klass.extend  ActiveModel::Naming
    klass.extend  ActiveModel::Callbacks
    klass.extend  ClassMethods

    add_callbacks(klass)
    add_constructor(klass)

    klass.send(:attr_reader, :fieldsets)

    @virtus_options = nil
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

  def self.base(virtus_options = {})
    @virtus_options = virtus_options
    Form
  end

  def setup
    initialize_fields
    instance_eval(&self.class.setup) if self.class.setup
  end

  def persisted?
    false
  end

  def fields
    @fields
  end

  def field(name)
    if self.class.form?(name)
      send(name)
    else
      @fields.fetch(name)
    end
  end

  def form?
    true
  end

  def form_label
    self.class.name.to_s.gsub(/Form$/, '').humanize
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

  private

  def initialize_fields
    @fields = {}
    @fieldsets = {}

    # take care of branches here
    self.class.fields.each do |id, field|
      if self.class.form?(id)
        @fields[id] = field

        fieldset = self.class.child_form_fieldsets[id]
        (@fieldsets[fieldset] ||= []) << @fields[id]
      else
        @fields[id] = field.dup
        (@fieldsets[field.fieldset] ||= []) << @fields[id]
      end
    end
  end

  module ClassMethods
    def setup(&block)
      @setup = block if block
      @setup
    end

    def form?(field_id = nil)
      field_id.nil? ? true : child_form_fieldsets.has_key?(field_id)
    end

    # fieldset may be extracted as a domain object
    def fieldset(id)
      initialize_fieldset(id)
      yield
      close_fieldset
    end

    def child_form_fieldsets
      @child_form_fieldsets ||= {}
    end

    # take care of branches here
    def field(name, field_class, options = {})
      if field_class.ancestors.include? SuperForm
        child_form_fieldsets[name] = current_fieldset_name
        attribute name, field_class

        define_method(name) do
          var   = :"@#{name.to_s}"
          value = instance_variable_get(var)

          unless value
            value = instance_variable_set(var, field_class.new)
          end

          value
        end

        create_child_validation(name)
        field = name
      else
        field = field_class.new(name, current_fieldset_name)

        field.add_validations(self, options)
        field.add_attributes(self, options)

        alias_method :"original_#{name.to_s}=", "#{name}="

        define_method "#{name}=" do |value|
          field = self.field(name)
          field.value = value if field

          send "original_#{name.to_s}=", value
        end
      end

      fields[name] = field
    end

    def fields
      @fields ||= {}
    end

    private

    def initialize_fieldset(id)
      @current = id
    end

    def close_fieldset
      @current = nil
    end

    def current_fieldset_name
      @current ||= default_fieldset_name
    end

    def default_fieldset_name
      :general
    end

    def create_child_validation(name)
      validate :"ensure_valid_#{name.to_s}"

      define_method "ensure_valid_#{name.to_s}" do
        unless send(name).send(:valid?)
          errors.add(:base, "Invalid #{name.to_s}")
        end
      end
    end
  end
end
