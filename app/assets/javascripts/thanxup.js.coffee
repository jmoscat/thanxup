# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $(".carousel").carousel()
  $('#country_code, #area_code, #number1, #number2, #extension').autotab_magic().autotab_filter('numeric')

  $('select.country_select').change (event) ->
    select_wrapper = $('#wrapper')

    $('select', select_wrapper).attr('disabled', true)

    country = $(this).val()
    model = $('select.country_select')[0].getAttribute('data')

    url = "/thanxup/subregion_options?parent_region=#{country}&model=#{model}"
    select_wrapper.load(url, ->
      $(this).children(':first').unwrap()
      $("[data-pop-over]").popover({placement: 'right', trigger: 'hover'})
    )

  $("[data-pop-over]").popover({placement: 'right', trigger: 'hover'})
