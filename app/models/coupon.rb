class Coupon
  include Ripple::Document

  COUPON_TYPES = ['Discount', 'Free Giveaway', 'Buy-one get-one', 'First time customer']

  property :title,       String
  property :description, String
  property :type,        String
  property :start_date,  Time
  property :end_date,    Time
  property :money_off,   Float
  property :percent_off, Integer
  property :enabled,     Boolean
  property :store_id,    String,  index: true

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
