class Coupon
  include Ripple::Document

  COUPON_TYPES = ['Discount', 'Free Giveaway', 'Buy-one get-one', 'First time use', 'Birthday']
  DISCOUNT_TYPES = ['Money Off', 'Percent Off']
  COUPON_LIFE = ['Absolute', 'Expiration Date', 'Expiration After Obtaining']
  GET_ONE_TYPES = ['Free', 'Percent Off', 'Money Off', 'Equal or Less Value']

  after_validation :check_proper_types

  property :title,           String, presence: true
  property :description,     String, presence: true
  property :type,            String, presence: true #the type of coupon COUPON_TYPES
  property :discount_desc,   String  #describe the type of Discount coupon (Money Off/Percent Off)
  property :life_type,       String  #the coupon life type COUPON_LIFE
  property :expiration_date, Time    #'Expiration Date' coupon life value
  property :money_off,       Money   #Discount coupon type money off
  property :percent_off,     Integer #Discount coupon type percent off
  property :expires_after,   Integer #'Expiration After' coupon life value
  property :get_one_type,    String  #The 'Buy-one get-one' coupon type - GET_ONE_TYPES
  property :get_money_off,   Money   #Buy-one get-one coupon money off value
  property :get_percent_off, Integer #Buy-one get-one coupon percent off value
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

  private

  def check_proper_types
    case self.type
    when 'Discount'
      unless DISCOUNT_TYPES.include?(self.discount_desc)
        self.errors.add(:discount_desc, 'not a valid discount coupon type')
        raise Ripple::DocumentInvalid, self
      end
      unless self.money_off.present? || self.precent_off.present?
        self.errors.add(:type, 'discount coupon requires a valid money off or percent off value.')
        raise Ripple::DocumentInvalid, self
      end
    when 'Free Giveaway'
    when 'Buy-one get-one'
    when 'First time use'
    when 'Birthday'
    end
  end
end
