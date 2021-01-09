$(document).ready(function(){
  // $('#toast').toast('show');

  $('#listrow').hide();
  $('#menu_panel').hide();
  $('#review_panel').hide();

  $('#listbtn').click(function(){
    $('#maprow').hide();
    $('#listrow').show();
    $('#mapbtn').removeClass('active');
    $('#listbtn').addClass('active');
  });

  $('#mapbtn').click(function(){
    $('#maprow').show();
    $('#listrow').hide();
    $('#listbtn').removeClass('active');
    $('#mapbtn').addClass('active');
  });

  $('#menubtn').click(function(){
    $('#menu_panel').show("slide", {
      direction: "right"
    }, 500);
  })

  $('#reviewbtn').click(function(){
    $('#review_panel').show("slide", {
      direction: "right"
    }, 500);
  })

  $('#menubackbtn').click(function(){
    $('#menu_panel').hide("slide", {
      direction: "right"
    }, 500);
  })

  $('#reviewbackbtn').click(function(){
    $('#review_panel').hide("slide", {
      direction: "right"
    }, 500);
  })
});

function make_toast_info(shop){
  $('#toast .name').text(shop.name);
  $('#toast .address').text(shop.address);
  $('#toast .phone_number').text(shop.phone_number);
  $('#toast .opening_now').text(shop.opening_now);
  $('#toast .rating').text(shop.rating);
  $('#toast .recommend_drink').text(shop.recommend_drink);
  $('#toast .promotion').html(get_shop_page(shop.name));
  // get_shop_page(shop.name);
  make_review_info(shop.reviews);
  make_menu_info(shop.menu);
}
function get_shop_page(shop_name){
  // var content="<div class='fb-page' data-href='https://www.facebook.com/NSYSUPhotoClub/' data-tabs='timeline' data-width='200' data-height='400' data-small-header='false' data-adapt-container-width='true' data-hide-cover='false' data-show-facepile='true'><blockquote cite='https://www.facebook.com/NSYSUPhotoClub/' class='fb-xfbml-parse-ignore'><a href='https://www.facebook.com/NSYSUPhotoClub/'>中山大學攝影社　NSYSU PHOTO CLUB</a></blockquote></div>"
  var content="<div id='fb-root'></div> <script async='1' defer='1' crossorigin='anonymous' src='https://connect.facebook.net/zh_TW/sdk.js#xfbml=1&amp;version=v9.0' nonce='Clfj5AXE'></script><div class='fb-page' data-href='https://www.facebook.com/NSYSUPhotoClub/' data-small-header='true' data-height='295' data-adapt-container-width='1' data-hide-cover='true' data-show-facepile='1' data-show-posts='1'><blockquote cite='https://www.facebook.com/kebuke2008/' class='fb-xfbml-parse-ignore'><a href='https://www.facebook.com/kebuke2008/'>可不可熟成紅茶</a></blockquote></div>"
  return content
}
function make_review_info(reviews){
  $('#review_info').text("");

  reviews.forEach((review, i) => {
    author = '<div>' + review.author + ' - ' + review.relative_time + '</div>';
    rating = '<div>' + "&#9733".repeat(review.rating) + '</div>'
    content ='<div>' + review.content + '</div>';
    output = author + rating + content + '</br>';
    $('#review_info').append(output);
  });
}

function make_menu_info(menu){
  $('#menu_info').text("");

  menu.forEach((drink, i) => {
    var output = '<tr>' +
                 '<td>' + drink.name + '<br/>' + drink.english_name + '</td>' +
                 // '<td>' + drink.english_name + '</td>' +
                 '<td>' + drink.price + '</td>' +
                 '</tr>';

    $('#menu_info').append(output);
  });
}
