class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unless CPF.new(value).valid?
      default_message = I18n.t('activemodel.errors.messages.cpf', 'invalid CPF', default: 'invalid CPF')
      record.errors[attribute] << (options[:message] || default_message)
    end
  end
end
