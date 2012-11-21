class Coupon
  include Ripple::Document
  property :title,       String
  property :description, String
  property :type,        String
  property :start_date,  Time
  property :end_date,    Time
  property :money_off,   Float
  property :percent_off, Integer
  property :enabled,     Boolean
  property :store_id,    String,  index: true
end
