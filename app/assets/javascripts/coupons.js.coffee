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
    if $(this).val() == "Discount"
      removeActive($(this))
      $('#discount').addClass('active')
      $('#discount').slideDown("fast")
    else if $(this).val() == "Free Giveaway"
      removeActive($(this))
    else if $(this).val() == "Buy-one get-one"
      removeActive($(this))
    else if $(this).val() == "First time customer"
      removeActive($(this))
    else if $(this).val() == "Birthday"
      removeActive($(this))
  $("#discount_select_type").change ->
    if $(this).val() == ""
      $('.active_discount').slideUp("fast")
    if $(this).val() == "Money Off"
      $('#coupon_percent_off').val('')
      $('.active_discount').slideUp("fast")
      $("#money_off").slideDown("fast")
      $("#money_off").addClass("active_discount")
    else if $(this).val() == "Percent Off"
      $('#coupon_money_off').val('')
      $('.active_discount').slideUp("fast")
      $("#percent_off").slideDown("fast")
      $("#percent_off").addClass("active_discount")

removeActive = (obj) ->
  unless obj.hasClass('active')
    $('.active select').val('')
    $('.active input').val('')
    $('.active').slideUp("fast")
    $('.active').removeClass('active')
