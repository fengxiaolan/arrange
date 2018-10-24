
/* 鼠标特效 */
var a_idx = 0;
jQuery(document).ready(function($) {
  $("body").click(function(e) {
    var a = new Array("❤富强❤","❤民主❤","❤文明❤","❤和谐❤","❤自由❤","❤平等❤","❤公正❤","❤法治❤","❤爱国❤","❤敬业❤","❤诚信❤","❤友善❤");
    var $i = $("<span></span>").text(a[a_idx]);
    a_idx = (a_idx + 1) % a.length;
    var x = e.pageX,
      y = e.pageY;
    $i.css({
      "z-index": 999999999999999999999999999999999999999999999999999999999999999999999,
      "top": y - 20,
      "left": x,
      "position": "absolute",
      "font-weight": "bold",
      "color": "rgb("+~~(255*Math.random())+","+~~(255*Math.random())+","+~~(255*Math.random())+")"
    });
    $("body").append($i);
    $i.animate({
        "top": y - 180,
        "opacity": 0
      },
      1500,
      function() {
        $i.remove();
      });
  });
});



// 生成目录索引列表
function GenerateContentList()
{
  var mainContent = $('#cnblogs_post_body');
  var h2_list = $('#cnblogs_post_body h2');//如果你的章节标题不是h2,只需要将这里的h2换掉即可
  if(mainContent.length < 1)
    return;

  if(h2_list.length>0)
  {
    var content = '<a name="_labelTop"></a>';
    content += '<div id="navCategory">';
    content += '<p style="font-size:18px"><b>目录</b></p>';
    content += '<ul>';
    for(var i=0; i<h2_list.length; i++)
    {
      var go_to_top = '<div style="text-align: right"><a href="#_labelTop">Return Top</a><a name="_label' + i + '"></a></div>';
      $(h2_list[i]).before(go_to_top);
      var h3_list = $(h2_list[i]).nextAll("h3");
      var li3_content = '';
      for(var j=0; j<h3_list.length; j++)
      {
        var tmp = $(h3_list[j]).prevAll('h2').first();
        if(!tmp.is(h2_list[i]))
          break;
        var li3_anchor = '<a name="_label' + i + '_' + j + '"></a>';
        $(h3_list[j]).before(li3_anchor);
        li3_content += '<li><a href="#_label' + i + '_' + j + '">' + $(h3_list[j]).text() + '</a></li>';
      }
      var li2_content = '';
      if(li3_content.length > 0)
        li2_content = '<li><a href="#_label' + i + '">' + $(h2_list[i]).text() + '</a><ul>' + li3_content + '</ul></li>';
      else
        li2_content = '<li><a href="#_label' + i + '">' + $(h2_list[i]).text() + '</a></li>';
      content += li2_content;
    }
    content += '</ul>';
    content += '</div><p>&nbsp;</p>';
    if($('#cnblogs_post_body').length != 0 )
    {
      $($('#cnblogs_post_body')[0]).prepend(content);
    }
  }
  $(mainContent[0]).prepend(qqinfo);
}
GenerateContentList();




//扫一扫侧边栏
$(".btn-myRewards").hover(function(){
  $(".myRewards").css("width","240px");
})
$(".myRewards").mouseleave(function(){
  $(".myRewards").css("width","0");
})
$(".myRewards-main").mouseleave(function(){
  $(".myRewards").css("width","0");
})

$(".not-full li:first").hover(function(){
  $(this).addClass("myR-on").siblings().removeClass("myR-on");
  $(".myRewards-account").html("支付宝打赏");
  $(".myRewards-code img").attr("src","http://images.cnblogs.com/cnblogs_com/yinn/1078847/o_zhifubao.png");
})

$(".not-full li:last").hover(function(){
  $(this).addClass("myR-on").siblings().removeClass("myR-on");
  $(".myRewards-account").html("关注公众号");
  $(".myRewards-code img").attr("src","http://images.cnblogs.com/cnblogs_com/yinn/1089307/o_gzhao.jpg");
})
$(".not-full li:nth-child(2)").hover(function(){
  $(this).addClass("myR-on").siblings().removeClass("myR-on");
  $(".myRewards-account").html("微信打赏");
  $(".myRewards-code img").attr("src","http://images.cnblogs.com/cnblogs_com/yinn/1078832/o_weixin.png");
})



//返回顶部

$(function() {
  // hide #back-top first
  $("#back-top").hide();
  // fade in #back-top
  $(window).scroll(function() {
    if ($(this).scrollTop() > 500) {
      $('#back-top').fadeIn();
    } else {
      $('#back-top').fadeOut();
    }
  });
  // scroll body to 0px on click
  $('#back-top a').click(function() {
    $('body,html').animate({
      scrollTop: 0
    }, 800);
    return false;
  });
});

