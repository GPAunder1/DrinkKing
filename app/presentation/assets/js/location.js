navigator.geolocation.getCurrentPosition(function(position) {
  set_submit_form(position.coords.latitude, position.coords.longitude);
});

function set_submit_form(latitude,longitude){
  LONGITUDE = longitude;
  LATITUDE = latitude;

  $("input[name='latitude']").val(latitude);
  $("input[name='longitude']").val(longitude);

  console.log(latitude);
  console.log(longitude);
}
