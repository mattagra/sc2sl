//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_self
//= require jquery.popupwindow
//= require dddropdownpanel

$('.carousel').carousel({
  interval: 2000
})

$('a[data-popup]').live('click', function(e) {
  console.log("opening popup");
  var left = screen.width/2
  var top = screen.height/2
  
  window.open($(this)[0].href, $(this).html(), $(this).attr("data-popup")+ ',top = ' + top + ',left = ' + left );
  //window.open($(this)[0].href );
  e.preventDefault();
});
var profiles =
{

  windowStandard:
  {
    height:500,
    width:400,
    centerBrowser:1
  },
  
  windowCenter:
	{
		height:200,
		width:250,
		center:1
	}

        

};

$(document).ready(function() {
  $(".popupwindow").popupwindow(profiles);
});





