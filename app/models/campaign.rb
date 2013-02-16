class Campaign
  include Ripple::Document
  include RippleExtensions

  TIME_ALLOWANCE = 1.hour

  attr_accessor :start_time, :end_time

  before_validation :validate_stores
  before_validation :generate_dates, :if => :time_changed?
  after_validation :validate_start_end, :validate_in_the_future, :validate_not_overlapping_times, :if => :time_changed?

  property :name,        String,  presence: true
  property :description, String,  presence: true
  property :start_date,  Time,    presence: true
  property :end_date,    Time,    presence: true
  property :inactive,    Boolean, default: false
  property :owner_id,    String,  index: true

  many :campaign_stores

  def has_store?(key)
    self.campaign_stores.detect { |store| store.store_id == key }
  end

  def deactivated?
    self.inactive?
  end

  def deactivate!
    self.inactive = true
    self.save!
  end

  def owner
    Owner.find(self.owner_id)
  end

  def past?
    now = Time.zone.now
    self.start_date < now && self.end_date < now
  end

  def starts_recently_or_in_future?
    start_date >= TIME_ALLOWANCE.ago
  end

  def ends_in_future?
    Time.current < end_date
  end

  def time_changed?
    self.new_record? || (self.start_date.present? && self.end_date.present? && [self.start_date_changed?, self.end_date_changed?].any?)
  end

  protected

  def time_range
    start_date..end_date
  end

  private

  def validate_stores
    errors.add :base, "Can't run a campaign without a store" and raise_error! if self.campaign_stores.blank?
  end

  def validate_in_the_future
    validate_starts_recently_or_in_future and return if start_date_changed? || self.new_record?
    validate_ends_in_future if end_date_changed? || self.new_record?
  end

  def validate_starts_recently_or_in_future
    add_time_travel_error unless starts_recently_or_in_future?
  end

  def validate_ends_in_future
    add_time_travel_error unless ends_in_future?
  end

  def validate_start_end
    errors.add :end_date, "must be after Start Time" and raise_error! if self.start_date >= self.end_date
  end

  def validate_not_overlapping_times
    overlap_error = "Cannot create campaign. You have already created a campaign for this time frame.
                     Either edit your other campaigns based on the times you entered, or use different times."
    self.owner.campaigns.detect do |campaign|
      next if campaign == self || campaign.deactivated? || campaign.past?

      errors.add :base, overlap_error and raise_error! if overlapping?(campaign)
    end
  end

  def add_time_travel_error
    time_travel_fail = "Cannot create campaign. You are trying to create a campaign in a
                        time frame that has already passed us by."
    errors.add :base, time_travel_fail and raise_error!
  end

  def overlapping?(campaign)
    campaign.time_range.begin <= time_range.end &&
      time_range.begin <= campaign.time_range.end
  end

  def generate_dates
    invalid_time_message if %w(start_date end_date start_time end_time).detect { |a| self.send(a).blank? }
    s_date = self.start_date.to_date.to_s.try(:+, " #{self.start_time}")
    e_date = self.end_date.to_date.to_s.try(:+, " #{self.end_time}")
    begin
      self.start_date = s_date.to_time.to_s
      self.end_date   = e_date.to_time.to_s
    rescue ArgumentError, NoMethodError
      invalid_time_message
    end
  end

  def invalid_time_message
    errors.add :base, "Input a valid set of times" and raise_error!
  end
end
