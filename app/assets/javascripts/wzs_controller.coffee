$ ->
  $('.wz-select').change ->
    year = $('#wz-select-year').val()
    month = $('#wz-select-month').val()
    window.location.href = '/wzs?year=' + year + '&month=' + month

  $("tbody.clickable tr").click ->
    $(@).toggleClass('clicked')
    if $("tbody.clickable tr.clicked").length > 0
      $(".wz-create").text('Stwórz WZ z dzisiaj')
      $(".wz-create").removeAttr('disabled')
    else
      $(".wz-create").text('Zaznacz zamówienia')
      $(".wz-create").attr('disabled', 'disabled')

  $(".wz-create").click ->
    path = '/wzs'
    orders = []
    $.map $("tbody.clickable tr.clicked"), ( el, i ) ->
      orders.push([$(el).attr('id'), $(el).find('td').last().find('select').val()])

    $.post(path, {orders: orders}, () ->)
      .success ->
        window.location = '/wzs'

  $(".edit-wz").click (e) ->
    e.preventDefault()
    parent = $(@).closest(".wz")
    parent.find("span.wz-description").addClass('hidden')
    parent.find(".edit-wz").addClass('hidden')
    parent.find("input#wz_description").removeClass('hidden')
    parent.find(".save-wz").removeClass('hidden')

  $(".save-wz").click (e) ->
    e.preventDefault()

    parent = $(@).closest(".wz")
    id = parent.data('wz-id')
    description = parent.find("input#wz_description").val()

    parent.find("span.wz-description").removeClass('hidden')
    parent.find(".edit-wz").removeClass('hidden')
    parent.find("input#wz_description").addClass('hidden')
    parent.find(".save-wz").addClass('hidden')

    $.ajax
      url: "wzs/" + id,
      data: 'description=' + description
      type: 'PUT',
      success: (response) ->
        if description == ''
          parent.find("span.wz-description").html('')
        else
          parent.find("span.wz-description").html("Opis: " + description)
      error: (response) ->
        console.log('errorrr')
