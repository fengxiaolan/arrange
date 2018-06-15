
/**
 * @Created by chinaWiserv
 * @User : lisiqin
 * @Date : 2018/5/29
 * @Describe : 无.
 */
(function() {
    require(['jquery', 'vue','swiper','util'], function ($, Vue, Swiper, u) {
        new Vue({
            el: '#bamboo',
            data:{
                bannerList:[],                //轮播图列表
                secImgList:[],                //页面图片模块列表
                secWorksList:[],              //作品列表
                id:'',                        //活动id
                status: 1,                    //是否可以报名的状态
                worksSort:'',
                isSign:'',
            },
            methods:{
                /** 获取轮播图 **/
                getBanner:function () {
                    var _self = this;
                    var $d = $.Deferred();
                    $.get('/portal/cycle/bambooBanner?pageSize=5',function (d) {
                        if(d.code === '200'){
                            var list =  d.body.datas;
                            _self.bannerList = list;
                        }
                        $d.resolve();
                    });
                    return $d.promise();
                },

                /*计算轮播图的宽度与高度*/
                getBannerWH:function(){
                    var _w = $(window).width();
                    var _h = (25*_w/96).toFixed(2);
                    var $el = $('.banner .swiper-slide');
                    $el.css('height',_h);
                },

                /*轮播图链接的跳转*/
                bannerLink:function (e) {
                    var url = $(e.target).parent().attr('data-url');
                    if(url !== undefined){
                        var flag = url.indexOf('//');
                        if(flag === -1){
                            location.href = '//'+url;
                        }else{
                            location.href = url;
                        }
                    }

                },

                /*视频轮播*/
                videoHandle:function($this){
                    var reg = $('.banner .swiper-slide').length <4;
                    var $video = $this['$el'].find('.swiper-slide.swiper-slide-active').find('video');
                    var le = $video.length;
                    if(le > 0){
                        $this.autoplay.stop();
                        $video[0].play();
                        $video[0].addEventListener('ended', function () {
                            //$this.slideNext();
                            if(reg){
                                $video[0].play();
                            } else{
                                if($this['$el'].is(":hover")){
                                    $this['$el'].trigger('mouseenter');
                                }else{
                                    $this['$el'].trigger('mouseout');
                                }
                            }
                        }, false);
                    }
                },

                /** 获取页面上的模块 **/
                getSection:function (id) {
                    var _self = this;
                    var $d = $.Deferred();
                    $.get('/portal/activity/bamboo/'+id,function (res) {
                        if(res.code == '200'){
                            var d = res.body;
                            _self.secImgList = d.activity.bambooActivityRelations;
                            _self.status = d.activity.status;
                            _self.isSign = d.activity.isSign;
                            _self.worksSort = d.activity.worksSort;
                            if(d.works && d.works.length>0){
                                d.works.map(function (v) {
                                    _self.secWorksList.push({
                                        id:v.id,
                                        logoUrl:v.logoUrl,
                                        title:v.name,
                                        author:(JSON.parse(v.authors))[0].name
                                    });
                                })
                            }
                        }
                        $d.resolve();
                    },'json');
                    return $d.promise();
                },

                /** 页面上的模块排序 **/
                sortSection:function () {
                    var aDiv = document.getElementsByClassName('sec-item');
                    var arr = [];
                    for(var i=0;i<aDiv.length;i++) {
                        arr.push(aDiv[i]);  //aDiv是元素的集合，并不是数组，所以不能直接用数组的sort进行排序。
                    }
                    arr.sort(function(a,b){
                        return a.getAttribute('data-id') - b.getAttribute('data-id')
                    });
                    for(var i=0;i<arr.length;i++) {
                        document.getElementById('bamboo').appendChild(arr[i]); //将排好序的元素，重新塞到body里面显示。
                    }
                },

                /** 点击立即报名时判断是否登录 **/
                checkLogin:function () {
                    var _self = this;
                    isLogin(function () {
                        if(_self.status ===1){
                            window.location.href='bamboo-register.html?id='+_self.id;
                        }
                    });
                }
            },
            created:function () {
                // this.sortSection();
            },
            mounted:function () {
                var _self = this;
                this.getBanner().then(function () {
                    _self.$nextTick(function() {
                        var sw = new Swiper('.banner', {
                            loop:true,
                            autoplay: {
                                delay: 10000,
                                stopOnLastSlide: false,
                                disableOnInteraction: false,
                            },
                            speed:800,
                            pagination: {
                                el: '.banner-pagi',
                                clickable: true,
                            },
                            on:{
                                slideChangeTransitionStart: function(){
                                    setTimeout(function(){_self.videoHandle(sw);},100);
                                },
                            }
                        });
                        /*当广告少于两个时，停止自动轮播,因为是loop,所以是小于4*/
                        var reg = $('.banner .swiper-slide').length <4;
                        if(reg){
                            sw.autoplay.stop();
                        }
                        /*鼠标进入，轮播停止*/
                        sw.el.onmouseenter = function() {
                            sw.autoplay.stop();
                            _self.videoHandle(sw);
                        };
                        /*鼠标离开，轮播开始*/
                        sw.el.onmouseout = function() {
                            if(!reg){
                                sw.autoplay.start();
                            }
                        };
                        _self.getBannerWH();
                    });

                });
                _self.id = u.getUrlParam('id');
                this.getSection(_self.id).then(function () {
                    _self.$nextTick(function() {
                        _self.sortSection();
                    })
                });
            }

        })
    })
})();
