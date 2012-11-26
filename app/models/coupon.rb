class Coupon
  include Ripple::Document

  COUPON_TYPES = ['Discount', 'Free Giveaway', 'Buy-one get-one', 'First time customer', 'Birthday']
  DISCOUNT_TYPES = ['Money Off', 'Percent Off']
  COUPON_LIFE = ['Absolute', 'Expiration Date', 'Expiration After Obtaining']

  property :title,           String
  property :description,     String
  property :type,            String
  property :life_type,       String
  property :expiration_date, Time
  property :money_off,       Float
  property :percent_off,     Integer
  property :expires_after,   Integer
  property :enabled,         Boolean
  property :store_id,        String,  index: true

  def discount?
    self.type == 'Discount'
  end

  def giveaway?
    self.type == 'Free Giveaway'
  end

  def buy_one_get_one?
    self.type == 'Buy-one get-one'
  end

  def first_time?
    self.type == 'First time customer'
  end
end
