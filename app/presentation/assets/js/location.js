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
/*
如果之後shop那頁要重新整理:
1.這個改成function去呼叫 or 寫個if else條件判斷有沒session或localstorage了
2.呼叫完之後件立個cookie或localstorage去存經緯度
3.之後呼叫前先判斷有沒有存了，沒有的話才呼叫，然後去submit shop.slim裡面的form
*/
