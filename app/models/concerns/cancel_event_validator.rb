class CancelEventValidator < ActiveModel::Validator
  def validate(event)
    return unless !event.canceled_at.nil? && event.status != 'accepted'
    event.errors.add(:canceled_at, I18n.translate('backend.cancel_only_accepted'))
  end
end
