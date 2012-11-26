# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(".datepicker").datepicker
    format: "yyyy-mm-dd"
    weekStart: 1
    autoclose: true
  $('#coupon_type').change ->
    if $(this).val() == ""
      removeActive($(this))
    else if $(this).val() == "Discount"
      removeActive($(this))
      $('#discount').addClass('active')
      $('#discount').slideDown('fast')
    else if $(this).val() == "Free Giveaway"
      removeActive($(this))
    else if $(this).val() == "Buy-one get-one"
      removeActive($(this))
    else if $(this).val() == "First time customer"
      removeActive($(this))
    else if $(this).val() == "Birthday"
      removeActive($(this))
      $('#birthday').addClass('active')
      $('#birthday').slideDown('fast')
      removeActiveLife($('#coupon_life select'))
      $('#coupon_life select').val('Absolute')
      $('#absolute').addClass('active_life')
      $('#absolute').slideDown('fast')
  $('#discount_select_type').change ->
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
      removeBirthday($(this))
    else if $(this).val() == "Absolute"
      removeActiveLife($(this))
      $('#absolute').addClass('active_life')
      $('#absolute').slideDown('fast')
    else if $(this).val() == "Expiration Date"
      removeActiveLife($(this))
      removeBirthday($(this))
      $('#expiration_date').addClass('active_life')
      $('#expiration_date').slideDown('fast')
    else if $(this).val() == "Expiration After Obtaining"
      removeActiveLife($(this))
      removeBirthday($(this))
      $('#expires_after').addClass('active_life')
      $('#expires_after').slideDown('fast')

removeActive = (obj) ->
  unless obj.hasClass('active')
    hideActiveDiscount()
    $('.active select').val('')
    $('.active input').val('')
    $('.active').slideUp('fast')
    $('.active').removeClass('active')

removeActiveLife = (obj) ->
  unless obj.hasClass('active_life')
    $('.active_life select').val('')
    $('.active_life input').val('')
    $('.active_life').slideUp('fast')
    $('.active_life').removeClass('active_life')

hideActiveDiscount = ->
  $('.active_discount').children().children().val('') if $('.active_discount').length > 0
  $('.active_discount').slideUp('fast')
  $('.active_discount').addClass('hide')
  $('.active_discount').removeClass('active_discount')

removeBirthday = (obj) ->
  if $('#birthday').hasClass('active')
    $('#coupon_type').val('')
    removeActive(obj)
