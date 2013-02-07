module Ripple #module to extend functionality to ripple gem (ORM)
  def raise_error!
    raise Ripple::DocumentInvalid, self
  end

  def validate_presence(attribute)
    self.errors.add(attribute, "can't be blank") and raise_error! if self.send(attribute).blank?
  end

  def validate_numericality(attribute)
    self.errors.add(attribute, "must be a number (integer)") and raise_error! unless parse_raw_value_as_an_integer(self.send(attribute))
  end

  def validate_inclusion(attribute, obj_in)
    self.errors.add(attribute, "must be from selected list") and raise_error! unless obj_in.include?(self.send(attribute))
  end

  def parse_raw_value_as_an_integer(raw_value)
    raw_value.to_i if raw_value.to_s =~ /\A[+-]?\d+\Z/
  end

  def validate_date_format(attribute)
    self.errors.add(attribute, "must be proper date (YYYY-MM-DD)") and raise_error! unless self.send(attribute).is_a?(Time)
  end
end
