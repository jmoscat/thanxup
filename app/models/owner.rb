# == Schema Information
#
# Table name: owners
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  remember_created_at    :datetime
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  suffix                 :string(255)
#  prefix                 :string(255)
#  company_name           :string(255)
#  city                   :string(255)
#  state                  :string(255)
#  country                :string(255)
#  address                :string(255)
#  zip_code               :string(255)
#  phone_number           :string(255)
#  allow_phone_contact    :boolean          default(FALSE), not null
#  approved               :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  logo_file_name         :string(255)
#  logo_content_type      :string(255)
#  logo_file_size         :integer
#  logo_updated_at        :datetime
#  customer_id            :string(255)
#  last_4_digits          :string(255)
#

class Owner < ActiveRecord::Base
  PREFIXES             = ["Mr.", "Miss", "Mrs.", "Ms."]
  SUFFIXES             = ["Jr.", "Sr.", "II", "III", "IV"]
  DEFAULT_COUNTRY_CODE = '1'

  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :recoverable

  attr_accessible :email, :password, :password_confirmation,
    :remember_me, :approved, :first_name, :company_name, :city,
    :state, :phone_number, :allow_phone_contact, :logo, :last_name,
    :suffix, :prefix, :area_code, :number1, :number2, :zip_code,
    :address, :country, :extension, :country_code, :stripe_token,
    :coupon, :customer_id, :last_4_digits

  attr_accessor :country_code, :area_code, :number1,
    :number2, :extension, :stripe_token, :coupon, :validations_to_skip

  has_attached_file :logo, :styles => { medium: "300x300>", thumb: "100x100>", avatar: "105x50" }

  before_validation :create_phone_number, on: :create
  before_update :update_stripe, :unless => proc { |obj| obj.validations_to_skip.present? and obj.validations_to_skip.include?('stripe') }
  before_destroy :cancel_subscription
  after_create :send_owner_mail

  validates :first_name, :last_name, :city, :state, :prefix, :address, :zip_code, presence: true
  validates :company_name, :phone_number, presence: true, uniqueness: true

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
      return if stripe_token.blank?
      if coupon.blank?
        customer = Stripe::Customer.create(
          :email       => email,
          :description => company_name,
          :card        => stripe_token,
          :plan        => 'thanxup'
        )
      else
        customer = Stripe::Customer.create(
          :email       => email,
          :description => company_name,
          :card        => stripe_token,
          :coupon      => coupon,
          :plan        => 'thanxup'
        )
      end
    else
      customer             = Stripe::Customer.retrieve(customer_id)
      customer.card        = stripe_token if stripe_token.present?
      customer.email       = self.email
      customer.description = self.company_name
      customer.plan        = 'thanxup'
      customer.save
    end
    self.last_4_digits = customer.active_card.last4
    self.customer_id   = customer.id
    self.stripe_token  = nil
  rescue Stripe::StripeError => e
    errors.add :base, "#{e.message}."
    self.stripe_token = nil
    false
  end

  def enable_subscription!
    unless self.customer_id.blank?
      customer = Stripe::Customer.retrieve(customer_id)
      customer.update_subscription :plan => 'thanxup'
    end
  end

  def subscribed?
    unless self.customer_id.blank?
      customer = Stripe::Customer.retrieve(customer_id)
      customer.subscription.try(:status) =~ /(active|trialing)/
    end
  end

  def cancel_subscription
    unless customer_id.nil?
      customer = Stripe::Customer.retrieve(customer_id)
      unless customer.nil? or customer.respond_to?('deleted') or customer.subscription.blank?
        customer.cancel_subscription if subscribed?
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
    self.last_4_digits = self.stripe_token = self.customer_id = nil
    self.validations_to_skip = ["stripe"]
    self.save!
  end

  def stripe_setup?
    self.customer_id.present? && self.last_4_digits.present?
  end

  private

  def create_phone_number
    [:area_code, :number1, :number2].each { |var| self.errors.add(:phone_number, 'invalid phone number') and return if self.send(var).blank? }
    self.country_code = self.country_code.blank? ? DEFAULT_COUNTRY_CODE : self.country_code
    self.phone_number = Phoner::Phone.new(number: "#{self.number1}#{self.number2}",
                                                  area_code: "#{self.area_code}",
                                                  country_code: "#{self.country_code}",
                                                  extension: "#{self.extension}").format("+ %c (%a)-%f-%l %x")
    self.errors.add(:phone_number, 'invalid phone number') unless Phoner::Phone.valid? self.phone_number || self.us_phone?
  end

  def us_phone?
    self.phone_number[2] == "1" && self.phone_number.length >= 18
  end
end
