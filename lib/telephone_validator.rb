class TelephoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unless Telephone.new(value).valid?
      default_message = I18n.t('activemodel.errors.messages.telephone', default: 'invalid telephone')
      record.errors[attribute] << (options[:message] || default_message)
    end
  end
end
