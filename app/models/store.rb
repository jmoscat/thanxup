class Store
  include Ripple::Document
  attr_accessor :country_code, :area_code, :number1, :number2, :extension
  before_validation :create_phone_number
  after_validation :check_if_exists

  DEFAULT_COUNTRY_CODE = '1'

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
    self.country_code = self.country_code.blank? ? DEFAULT_COUNTRY_CODE : self.country_code
    self.contact_phone_number = Phoner::Phone.new(number: "#{self.number1}#{self.number2}",
                                                  area_code: "#{self.area_code}",
                                                  country_code: "#{self.country_code}",
                                                  extension: "#{self.extension}").format("+ %c (%a)-%f-%l %x")
    unless Phoner::Phone.valid? self.contact_phone_number
      self.errors.add(:contact_phone_number, 'invalid phone number') and raise_error!
    end
  end

  def check_if_exists
    if Store.find_by_index('owner_id', self.owner_id).collect { |store| store.name }.include?(self.name)
      self.errors.add(:name, 'already exists') and raise_error!
    end
  end
end
