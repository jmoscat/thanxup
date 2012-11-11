class Owner < ActiveRecord::Base
  after_create :send_owner_mail

  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
    :remember_me, :approved, :name, :company_name, :city,
    :state, :phone_number

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  def send_owner_mail
    ThanxupMailer.new_owner_waiting_for_approval(self).deliver
  end
end
