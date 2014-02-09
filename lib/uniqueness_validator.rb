class UniquenessValidator < ActiveRecord::Validations::UniquenessValidator
  def setup(klass)
    super
    @klass = options[:model] if options[:model]
  end

  def validate_each(record, attribute, value)
    # UniquenessValidator can't be used outside of ActiveRecord instances, here
    # we return the exact same error, unless the 'model' option is given.
    if ! options[:model] && ! record.class.ancestors.include?(ActiveRecord::Base)
      raise ArgumentError, "Unknown validator: 'UniquenessValidator'"

    # If we're inside an ActiveRecord class, and `model` isn't set, use the
    # default behaviour of the validator.
    elsif ! options[:model]
      super

    # Custom validator options. The validator can be called in any class, as
    # long as it includes `ActiveModel::Validations`. You can tell the validator
    # which ActiveRecord based class to check against, using the `model`
    # option. Also, if you are using a different attribute name, you can set the
    # correct one for the ActiveRecord class using the `attribute` option.
    else
      record_org, attribute_org = record, attribute

      attribute = options[:attribute].to_sym if options[:attribute]

      if options[:model]
        record = options[:model].new(attribute => value)
      else
        model_name = options.fetch(:model_name) { record_org.class.to_s.downcase.split('::').last.gsub(/form$/, '') }
        record = record_org.send(model_name)
      end
      record = record_org.send(options[:model].to_s.downcase)

      super

      if record.errors[attribute_org].any?
        record_org.errors.add(attribute_org, :taken,
          options.except(:case_sensitive, :scope).merge(value: value))
      end
    end
  end
end
