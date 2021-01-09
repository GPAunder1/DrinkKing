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

  $('#closebtn').on("click", function(){
    change_map_zoom_and_center(14);
  });

});

function make_toast_info(shop){
  $('#toast .name').text(shop.name);
  $('#toast .address').text(shop.address);
  $('#toast .phone_number').text(shop.phone_number);
  $('#toast .opening_now').text(shop.opening_now);
  $('#toast .rating').text(shop.rating);
  $('#toast .recommend_drink').text(shop.recommend_drink);
  $('#toast .promotion').html(get_shop_page(shop.fb_url));

  make_review_info(shop.reviews);
  make_menu_info(shop.menu);
}

function get_shop_page(fb_url){
  // var content = `<iframe src="https://www.facebook.com/plugins/page.php?href=https%3A%2F%2Fwww.facebook.com%2FNSYSU.MISxCAMP%2F&tabs=timeline&small_header=true&adapt_container_width=true&hide_cover=false&show_facepile=true&appId=4091447374251579" width="100%" height="100%" scrolling="no" frameborder="0" allowfullscreen="true" allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share"></iframe>`
  var content = `<iframe src="https://www.facebook.com/plugins/page.php?href=${fb_url}&tabs=timeline&small_header=true&adapt_container_width=true&hide_cover=false&show_facepile=true&appId=4091447374251579" width="100%" height="100%" scrolling="no" frameborder="0" allowfullscreen="true" allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share"></iframe>`
  return content;
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
