# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  setTimeout ->
    $(".alert").fadeOut(500)
  , 1500

  $('.datepicker').datepicker({
    format: 'dd-mm-yyyy',
    autoclose: true,
    language: 'pl'
  });

  $('.metal-select').change ->
    year = $('#order-select-year').val()
    month = $('#order-select-month').val()
    window.location.href = '/metal_orders/delivered_with_wz?year=' + year + '&month=' + month

  $('.furniture-select').change ->
    year = $('#order-select-year').val()
    month = $('#order-select-month').val()
    window.location.href = '/furniture_orders/delivered_with_wz?year=' + year + '&month=' + month

  $('.search_tag').keyup ->
    query = $(@).val()
    if query.length > 2
      $(".main-body").hide()
      $.get('/search', {query: query}, () ->
      ).success (result) ->
        $(".search-results").html(result['content'])
        $(".search-results").show()
    else if query.length == 0
      $(".search-results").hide()
      $(".main-body").show()
