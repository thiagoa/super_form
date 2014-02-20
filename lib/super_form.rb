require 'active_support/concern'
require 'active_model'
require 'virtus'
require 'super_form/fieldable'
require "super_form/version"

autoload :UniquenessValidator, 'uniqueness_validator'

module SuperForm
  extend ActiveSupport::Concern

  include ActiveModel::Model
  include Fieldable

  included do
    include Virtus.model

    class_eval &SuperForm.callbacks
    class_eval &SuperForm.constructor
  end

  def self.constructor
    Proc.new do
      alias_method :original_initializer, :initialize

      def initialize(*args)
        setup
        original_initializer(*args)
      end
    end
  end

  def self.callbacks
    Proc.new do
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
    def setup(&block)
      @setup = block if block
      @setup
    end

    def model_name
      ActiveModel::Name.new(self, nil, to_s.gsub(/Form$/, ''))
    end
  end
end
