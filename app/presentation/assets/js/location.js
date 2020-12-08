navigator.geolocation.getCurrentPosition(function(position) {
  do_something(position.coords.latitude, position.coords.longitude);
});

function do_something(latitude,longitude){
  console.log("latitude:",latitude)
  console.log("longitude",longitude)
}
