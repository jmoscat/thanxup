require 'ripple'

class Store
  include Ripple::Document
  property :name,                 String, presence: true
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
  many :coupons

  def owner
    Owner.find(owner_id.to_i)
  end

  def owner=(owner)
    self.owner_id = owner.id.to_s
  end

  def coupons
    Coupon.find_by_index('store_id', self.key)
  end
end
