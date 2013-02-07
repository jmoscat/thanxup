class Campaign
  include Ripple::Document

  START_TIME_ALLOWANCE = 1.hour

  attr_accessor :start_time, :end_time

  before_validation :validate_stores
  after_validation :validate_start_end, :validate_in_the_future, :validate_not_overlapping_times, :if => :time_changed?

  property :name,        String,  presence: true
  property :description, String,  presence: true
  property :start_date,  Time,    presence: true
  property :end_date,    Time,    presence: true
  property :inactive,    Boolean, default: false
  property :owner_id,    String,  index: true

  many :campaign_stores

  def deactivated?
    self.inactive?
  end

  def deactivate!
    self.inactive = true
    save!
  end

  def owner
    Owner.find(self.owner_id)
  end

  def past?
    now = Time.zone.now
    start_time < now && end_time < now
  end

  def starts_recently_or_in_future?
    start_time >= Date.today
  end

  def ends_in_future?
    Time.current < end_time
  end

  def time_changed?
    self.new_record? || (self.start_time.present? && self.end_time.present? && [self.start_time_changed?, self.end_time_changed?].any?)
  end

  protected

  def time_range
    start_time..end_time
  end

  private

  def validate_stores

  end

  def validate_in_the_future
    validate_starts_recently_or_in_future and return if start_time_changed? || self.new_record?
    validate_ends_in_future if end_time_changed? || self.new_record?
  end

  def validate_starts_recently_or_in_future
    add_time_travel_error unless starts_recently_or_in_future?
  end

  def validate_ends_in_future
    add_time_travel_error unless ends_in_future?
  end

  def validate_start_end
    errors.add :end_time, "must be after Start Time" and raise_error! if self.start_time >= self.end_time
  end

  def validate_not_overlapping_times
    overlap_error = "Cannot create campaign. You have already created a campaign for this time frame.
                     Either edit your other campaigns based on the times you entered, or use different times."
    self.owner.campaigns.detect do |campaign|
      next if campaign == self || campaign.deactivated? || campaign.past?

      errors.add(:base, overlap_error) and raise_error! if overlapping?(campaign)
    end
  end

  def add_time_travel_error
    time_travel_fail = "Cannot create currency sale. You are trying to create a currency sale in a
                        time frame that has already passed us by."
    errors.add :base, time_travel_fail and raise_error!
  end

  def overlapping?(campaign)
    campaign.time_range.begin <= time_range.end &&
      time_range.begin <= campaign.time_range.end
  end

  def raise_error!
    raise Ripple::DocumentInvalid, self
  end
end
