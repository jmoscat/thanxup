class Owner < ActiveRecord::Base
  PREFIXES = ["Mr.", "Miss", "Mrs.", "Ms."]
  SUFFIXES = ["Jr.", "Sr.", "II", "III", "IV"]
  DEFAULT_COUNTRY_CODE = '1'

  has_attached_file :logo, :styles => { medium: "300x300>", thumb: "100x100>", avatar: "105x50" }

  before_validation :create_phone_number, on: :create
  before_save :update_stripe, :unless => proc { |obj| obj.validations_to_skip.present? and obj.validations_to_skip.include?('stripe') }
  before_destroy :cancel_subscription
  after_create :send_owner_mail

  validates :email, :first_name, :last_name, :company_name, :city, :state,
    :phone_number, :prefix, presence: true

  validates :password, :password_confirmation, presence: true, if: :password

  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
    :remember_me, :approved, :first_name, :company_name, :city,
    :state, :phone_number, :allow_phone_contact, :logo, :last_name,
    :suffix, :prefix, :area_code, :number1, :number2, :zip_code,
    :address, :country, :extension, :country_code, :stripe_token,
    :coupon, :customer_id, :last_4_digits

  attr_accessor :country_code, :area_code, :number1,
    :number2, :extension, :stripe_token, :coupon, :validations_to_skip

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

  def update_stripe
    return if email.include?('@example.com') and not Rails.env.production?
    if customer_id.nil?
      if stripe_token.blank?
        raise "Stripe token not present. Can't create account."
      end
      if coupon.blank?
        customer = Stripe::Customer.create(
          :email => email,
          :description => company_name,
          :card => stripe_token,
          :plan => 'thanxup'
        )
      else
        customer = Stripe::Customer.create(
          :email => email,
          :description => company_name,
          :card => stripe_token,
          :coupon => coupon,
          :plan => 'thanxup'
        )
      end
    else
      customer = Stripe::Customer.retrieve(customer_id)
      if stripe_token.present?
        customer.card = stripe_token
      end
      customer.email = self.email
      customer.description = self.company_name
      customer.plan = 'thanxup'
      customer.save
    end
    self.last_4_digits = customer.active_card.last4
    self.customer_id = customer.id
    self.stripe_token = nil
  rescue Stripe::StripeError => e
    errors.add :base, "#{e.message}."
    self.stripe_token = nil
    false
  end

  def cancel_subscription
    unless customer_id.nil?
      customer = Stripe::Customer.retrieve(customer_id)
      unless customer.nil? or customer.respond_to?('deleted') or customer.subscription.blank?
        if customer.subscription.try(:status) =~ /(active|trialing)/
          customer.cancel_subscription
        end
      end
    end
  rescue Stripe::StripeError => e
    errors.add :base, "Unable to cancel your subscription. #{e.message}."
    false
  end

  def remove_stripe_info
    unless customer_id.nil?
      customer = Stripe::Customer.retrieve(customer_id)
      customer.delete
      self.clear_stripe_info!
    end
  rescue Stripe::StripeError => e
    errors.add :base, "Unable to remove your account. #{e.message}."
    false
  end

  def clear_stripe_info!
    self.last_4_digits       = nil
    self.stripe_token        = nil
    self.customer_id         = nil
    self.validations_to_skip = ["stripe"]
    self.save!
  end

  private

  def create_phone_number
    [:area_code, :number1, :number2].each { |var| self.errors.add(:phone_number, 'invalid phone number') and return if self.send(var).blank? }
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
