# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#area_code, #number1, #number2').autotab_magic().autotab_filter('numeric')
  $('#owner_allow_phone_contact').change ->
    if this.checked
      $('#allow_contact').append('We will be contacting you by phone soon.')
      $('#allow_contact').addClass('alert')
    else
      $('#allow_contact').removeClass('alert').empty()
