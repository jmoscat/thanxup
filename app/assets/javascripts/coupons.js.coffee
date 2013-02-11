# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(".datepicker").datepicker
    format: "yyyy-mm-dd"
    weekStart: 1
    autoclose: true
  $('.timepicker').timepicker()
  $('#coupon_type').change ->
    if $(this).val() == ""
      removeActive($(this))
    else if $(this).val() == "Discount"
      removeActive($(this))
      $('#discount').addClass('active')
      $('#discount').slideDown('fast')
    else if $(this).val() == "Free Giveaway"
      removeActive($(this))
      $('#free').addClass('active')
      $('#free').slideDown('fast')
    else if $(this).val() == "Buy-one get-one"
      removeActive($(this))
      $('#buy_get').addClass('active')
      $('#buy_get').slideDown('fast')
    else if $(this).val() == "First time use"
      removeActive($(this))
      $('#free').addClass('active')
      $('#free').slideDown('fast')
    else if $(this).val() == "Birthday"
      removeActive($(this))
      $('#birthday').addClass('active')
      $('#birthday').slideDown('fast')
      if $('#coupon_life_type').val() == 'Expiration Date'
        removeActiveLife($('#coupon_life_type'))
        $("#coupon_life_type option[value='Expiration Date']").prop('disabled', true)
        $("#coupon_life_type").val('')
      $("#coupon_life_type option[value='Expiration Date']").prop('disabled', true)
  $('#coupon_discount_desc').change ->
    if $(this).val() == ""
      hideActiveDiscount()
    else if $(this).val() == "Money Off"
      hideActiveDiscount()
      $('#money_off').slideDown('fast')
      $('#money_off').addClass('active_discount')
    else if $(this).val() == "Percent Off"
      hideActiveDiscount()
      $('#percent_off').slideDown('fast')
      $('#percent_off').addClass('active_discount')
  $('#coupon_life_type').change ->
    if $(this).val() == ""
      removeActiveLife($(this))
    else if $(this).val() == "Absolute"
      removeActiveLife($(this))
      $('#absolute').addClass('active_life')
      $('#absolute').slideDown('fast')
    else if $(this).val() == "Expiration Date"
      removeActiveLife($(this))
      if $('#coupon_type').val() == "Birthday"
        $("#coupon_life_type option[value='Expiration Date']").prop('disabled', true)
        $("#coupon_life_type").val('')
      else
        $('#expiration_date').addClass('active_life')
        $('#expiration_date').slideDown('fast')
    else if $(this).val() == "Expiration After Obtaining"
      removeActiveLife($(this))
      $('#expires_after').addClass('active_life')
      $('#expires_after').slideDown('fast')
  $('#coupon_get_one_type').change ->
    if $(this).val() == ""
      hideActiveDiscount()
    else if $(this).val() == "Money Off"
      hideActiveDiscount()
      $('#get_one_money').slideDown('fast')
      $('#get_one_money').addClass('active_discount')
    else if $(this).val() == "Percent Off"
      hideActiveDiscount()
      $('#get_one_percent').slideDown('fast')
      $('#get_one_percent').addClass('active_discount')
    else if $(this).val() == "Equal or Less Value"
      hideActiveDiscount()
      $('#get_equal').slideDown('fast')
      $('#get_equal').addClass('active_discount')
    else if $(this).val() == "Free"
      hideActiveDiscount()
      $('#get_free').slideDown('fast')
      $('#get_free').addClass('active_discount')

removeActive = (obj) ->
  undoRestricted()
  unless obj.hasClass('active')
    $('#warning-span').remove() if $('#warning-span').length > 0
    deepHideActiveDiscount()
    $('.active select').val('')
    $('.active input').val('')
    $('.active').slideUp('fast')
    $('.active').removeClass('active')

removeActiveLife = (obj) ->
  undoRestricted()
  unless obj.hasClass('active_life')
    $('#warning-span').remove() if $('#warning-span').length > 0
    $('.active_life select').val('')
    $('.active_life input').val('')
    $('.active_life').slideUp('fast')
    $('.active_life').removeClass('active_life')

hideActiveDiscount = ->
  undoRestricted()
  $('.active_discount').children().val('') if $('.active_discount').length > 0
  $('.active_discount').slideUp('fast')
  $('.active_discount').addClass('hide')
  $('.active_discount').removeClass('active_discount')

deepHideActiveDiscount = ->
  undoRestricted()
  $('.active_discount').children().children().val('') if $('.active_discount').length > 0
  $('.active_discount').slideUp('fast')
  $('.active_discount').addClass('hide')
  $('.active_discount').removeClass('active_discount')

undoRestricted = ->
  if $('#coupon_type').val() != 'Birthday' && $("#coupon_life_type option[value='Expiration Date']").attr('disabled') == 'disabled'
    $("#coupon_life_type option[value='Expiration Date']").prop('disabled', false)
