class Coupon
  include Ripple::Document

  COUPON_TYPES = ['Discount', 'Free Giveaway', 'Buy-one get-one', 'First time use', 'Birthday']
  DISCOUNT_TYPES = ['Money Off', 'Percent Off']
  COUPON_LIFE = ['Absolute', 'Expiration Date', 'Expiration After Obtaining']
  GET_ONE_TYPES = ['Free', 'Percent Off', 'Money Off', 'Equal or Less Value']

  after_validation :validate_coupon

  property :title,           String, presence: true
  property :description,     String, presence: true
  property :type,            String, presence: true #the type of coupon COUPON_TYPES
  property :discount_desc,   String  #describe the type of Discount coupon (Money Off/Percent Off)
  property :life_type,       String, presence: true  #the coupon life type COUPON_LIFE
  property :expiration_date, Time    #'Expiration Date' coupon life value
  property :money_off,       Money   #Discount coupon type money off
  property :percent_off,     Integer #Discount coupon type percent off
  property :expires_after,   Integer #'Expiration After' coupon life value
  property :get_one_type,    String  #The 'Buy-one get-one' coupon type - GET_ONE_TYPES
  property :get_money_off,   Money   #Buy-one get-one coupon money off value
  property :get_percent_off, Integer #Buy-one get-one coupon percent off value
  property :store_id,        String, index: true

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

  def validate_coupon
    validate_inclusion(:type, COUPON_TYPES)
    validate_inclusion(:life_type, COUPON_LIFE)
    case self.type
      when 'Discount'
        validate_presence(:discount_desc)
        validate_inclusion(:discount_desc, DISCOUNT_TYPES)
        case self.discount_desc
          when 'Percent Off'
            validate_presence(:percent_off)
            validate_numericality(:percent_off)
          when 'Money Off'
            validate_presence(:money_off)
            validate_numericality(:money_off)
        end
      when 'Buy-one get-one'
        validate_presence(:get_one_type)
        validate_inclusion(:get_one_type, GET_ONE_TYPES)
        case self.get_one_type
          when 'Percent Off'
            validate_presence(:get_percent_off)
            validate_numericality(:get_percent_off)
          when 'Money Off'
            validate_presence(:get_money_off)
            validate_numericality(:get_money_off)
        end
    end
    case self.life_type
      when 'Expiration Date'
        validate_presence(:expiration_date)
        validate_date_format(:expiration_date)
      when 'Expiration After Obtaining'
        validate_presence(:expires_after)
        validate_numericality(:expires_after)
    end
  end

  def validate_presence(attribute)
    self.errors.add(attribute, "can't be blank") and ripple_raise! if self.send(attribute).blank?
  end

  def validate_numericality(attribute)
    self.errors.add(attribute, "must be a number (integer)") and ripple_raise! unless parse_raw_value_as_an_integer(self.send(attribute))
  end

  def validate_inclusion(attribute, obj_in)
    self.errors.add(attribute, "must be from selected list") and ripple_raise! unless obj_in.include?(self.send(attribute))
  end

  def parse_raw_value_as_an_integer(raw_value)
    raw_value.to_i if raw_value.to_s =~ /\A[+-]?\d+\Z/
  end

  def validate_date_format(attribute)
    self.errors.add(attribute, "must be proper date (YYYY-MM-DD)") and ripple_raise! unless self.send(attribute).is_a?(Time)
  end

  def ripple_raise!
    raise Ripple::DocumentInvalid, self
  end
end
