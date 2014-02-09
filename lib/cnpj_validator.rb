class CnpjValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unless CNPJ.new(value).valid?
      default_message = I18n.t('activemodel.errors.messages.cnpj', 'invalid CNPJ', default: 'invalid CNPJ')
      record.errors[attribute] << (options[:message] || default_message)
    end
  end
end
