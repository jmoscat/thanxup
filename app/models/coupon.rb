require 'ripple'

class Coupon
  include Ripple::Document
  property :title,       String,  presence: true
  property :description, String,  presence: true
  property :type,        String,  presence: true
  property :start_date,  Time,    presence: true
  property :end_date,    Time,    presence: true
  property :money_off,   Float,   presence: true
  property :percent_off, Integer, presence: true
  property :enabled,     Boolean, presence: true
  property :store_id,    String,  index: true
end
