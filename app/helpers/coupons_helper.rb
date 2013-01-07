module CouponsHelper
  def column_to_proper_desc(col)
    case col
      when :title
        'Input a heading for your coupon that draws the user\'s attention'
      when :description
        'Input a clear description describing your coupon'
      when :type
        'Select the type of coupon you want from the dropdown menu'
      when :life_type
        'Select a shelf life from the dropdown menu'
      when :percent_off
        'Input a percentage off value (1-100%) for your coupon'
      when :money_off
        'Input a money off integer $ for your coupon'
      when :expiration_date
        'Input a valid expiration date'
      when :expires_after
        'Input a valid integer for the shelf life (in days) of the coupon'
      when :get_one_type
        'Select the proper buy-one get-one type from the dropdown menu'
      when :discount_desc
        'Select the type of discount-off coupon (money/percent) from the dropdown menu'
      when :get_money_off
        'Input the amount of money off for a buy-one get-one money off coupon'
      when :get_percent_off
        'Input the percent off for a buy-one get-one percent off coupon'
    end
  end
end
