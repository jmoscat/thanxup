class Store
  include Ripple::Document
  attr_accessor :area_code, :number1, :number2
  before_validation :create_phone_number
  after_validation :check_if_exists

  property :name,                 String, presence: true
  property :description,          String, presence: true
  property :city,                 String, presence: true
  property :state,                String, presence: true
  property :country,              String, presence: true
  property :address,              String, presence: true
  property :zip_code,             String, presence: true
  property :contact_email,        String, presence: true
  property :contact_phone_number, String, presence: true
  property :qr_code,              String
  property :type,                 String, presence: true
  property :owner_id,             String, index: true

  def owner
    Owner.find(owner_id.to_i)
  end

  def owner=(owner)
    self.owner_id = owner.id.to_s
  end

  def available_coupons
    Coupon.find_by_index('store_id', self.key)
  end

  private

  def create_phone_number
    self.contact_phone_number = "#{self.area_code}-#{self.number1}-#{self.number2}"
  end

  def check_if_exists
    if Store.find_by_index('owner_id', self.owner_id).collect { |store| store.name }.include?(self.name)
      self.errors.add(:name, 'already exists')
      raise Ripple::DocumentInvalid, self
    end
  end
end
