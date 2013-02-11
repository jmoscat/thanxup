class Owner < ActiveRecord::Base
  PREFIXES = ["Mr.", "Miss", "Mrs.", "Ms."]
  SUFFIXES = ["Jr.", "Sr.", "II", "III", "IV"]
  DEFAULT_COUNTRY_CODE = '1'

  has_attached_file :logo, :styles => { medium: "300x300>", thumb: "100x100>", avatar: "105x50" }

  attr_accessor :country_code, :area_code, :number1, :number2, :extension

  before_validation :create_phone_number

  after_create :send_owner_mail

  validates :email, :password, :password_confirmation,
    :first_name, :last_name, :company_name, :city, :state,
    :phone_number, :prefix, :area_code, :number1,
    :number2, :presence => true

  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
    :remember_me, :approved, :first_name, :company_name, :city,
    :state, :phone_number, :allow_phone_contact, :logo, :last_name,
    :suffix, :prefix, :area_code, :number1, :number2, :zip_code,
    :address, :country, :extension, :country_code

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

  def stores
    Store.find_by_index('owner_id', self.id.to_s)
  end

  def campaigns
    Campaign.find_by_index('owner_id', self.id.to_s).reject { |campaign| campaign.inactive? }
  end

  def name
    "#{self.prefix} #{self.first_name} #{self.last_name}"
  end

  private

  def create_phone_number
    self.country_code = self.country_code.blank? ? DEFAULT_COUNTRY_CODE : self.country_code
    self.phone_number = Phoner::Phone.new(number: "#{self.number1}#{self.number2}",
                                                  area_code: "#{self.area_code}",
                                                  country_code: "#{self.country_code}",
                                                  extension: "#{self.extension}").format("+ %c (%a)-%f-%l %x")
    unless Phoner::Phone.valid? self.phone_number
      self.errors.add(:phone_number, 'invalid phone number')
    end
  end
end
