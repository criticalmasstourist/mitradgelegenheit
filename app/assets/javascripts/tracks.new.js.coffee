$(document).ready ->
  map = L.map('map').setView([52.517, 13.364], 12)
  L.tileLayer('http://{s}.tiles.mapbox.com/v3/dahoo.k3dh2bke/{z}/{x}/{y}.png',->
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18
  ).addTo(map)