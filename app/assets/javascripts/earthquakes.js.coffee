$ ->
  mapOptions =
    center: new google.maps.LatLng $('#map_center_x').val(), $('#map_center_y').val()
    zoom: 8
    mapTypeId: google.maps.MapTypeId.TERRAIN

  map = new google.maps.Map $("#map")[0], mapOptions

  $('.earthquake').each (i, earthquake) ->
    new google.maps.Marker
      map: map
      position: new google.maps.LatLng(
        parseFloat($(earthquake).find('.lat').text(), 10),
        parseFloat($(earthquake).find('.lon').text(), 10)
      )

