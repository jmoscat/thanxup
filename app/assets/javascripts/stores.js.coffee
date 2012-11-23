# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('select#store_country').change (event) ->
    select_wrapper = $('#store_state_wrapper')

    $('select', select_wrapper).attr('disabled', true)

    country = $(this).val()

    url = "/stores/subregion_options?parent_region=#{country}"
    select_wrapper.load(url, ->
      $(this).children(':first').unwrap()
      $("[data-pop-over]").popover({placement: 'right', trigger: 'hover'})
    )

  $("[data-pop-over]").popover({placement: 'right', trigger: 'hover'})
