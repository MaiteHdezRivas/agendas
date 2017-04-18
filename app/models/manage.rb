class Manage < ActiveRecord::Base

  # Relations
  belongs_to :user
  belongs_to :holder

  # Validations
  # validates_uniqueness_of :holder_id, scope: :user_id, message: I18n.t('backend.participants_uniqueness')

  def self.set_manages_same_holders(user_id)
    holder_ids = Holder.by_manages(user_id).ids
    Manage.where(holder_id: holder_ids).includes(:user)
  end
end
