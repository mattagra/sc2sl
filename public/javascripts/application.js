$('a[data-popup]').live('click', function(e) {
  console.log("opening popup");
  window.open($(this)[0].href, $(this).html(), $(this).attr("data-popup") );
  //window.open($(this)[0].href );
  e.preventDefault();
});
var profiles =
{

  windowStandard:
  {
    height:500,
    width:400,
    center:1
  }

        

};
$(function()
{
  $(".popupwindow").popupwindow(profiles);
});



