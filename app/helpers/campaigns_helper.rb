module CampaignsHelper
  def campaign_column_to_proper_desc(col)
    case col
      when :name
        'Input a name for your campaign that is unique to help keep your campaigns managed'
      when :description
        'Input a clear description describing your campaign'
      when :start_date
        'Input a valid start time for your campaign'
      when :end_date
        'Input a valid end time for your campaign'
    end
  end
end
