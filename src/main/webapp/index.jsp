<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>社交媒体大数据的交通感知分析平台</title>
	<link rel="stylesheet" type="text/css" href="./css/style.css">
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=A4749739227af1618f7b0d1b588c0e85"></script>
    <!-- 加载百度地图样式信息窗口 -->
    <script type="text/javascript" src="http://api.map.baidu.com/library/SearchInfoWindow/1.5/src/SearchInfoWindow_min.js"></script>
    <link rel="stylesheet" href="http://api.map.baidu.com/library/SearchInfoWindow/1.5/src/SearchInfoWindow_min.css" />
    <!-- 加载城市列表 -->
    <script type="text/javascript" src="http://api.map.baidu.com/library/CityList/1.2/src/CityList_min.js"></script>
</head>
<body>
	<div id="l-map"></div>

    <div id="legend">
        <img src="WEB-INF/jsp/img/legend.png" alt="legend">
    </div>

    <div class="select-time">
        <form action="index.jsp" method="get">
            <!-- <input type="text"></input> -->
            <select id="option" name="name" onchange="show(this.value)">
                <option value="00to07.json">4月2日00:00-08:00</option>
                <option value="08to09.json">4月2日08:00-10:00</option>
                <option value="10to11.json">4月2日10:00-12:00</option>
                <option value="12to13.json">4月2日12:00-14:00</option>
                <option value="14to15.json">4月2日14:00-16:00</option>
                <option value="16to17.json">4月2日16:00-18:00</option>
                <option value="18to19.json">4月2日18:00-20:00</option>
                <option value="20to21.json">4月2日20:00-22:00</option>
                <option value="22to23.json">4月2日22:00-24:00</option>
                <option value="wholeday.json">4月2日全天</option>
                <option value="Shanghai.json">上海外滩踩踏事故演示数据</option>
                <option value="realtime.json">实时数据</option>
            </select>
            <input type="submit" value="载入" id="ok">
        </form>
    </div>

    <div class="event-list">
        <ul id="show">
            <script type="text/javascript">
                function show(str){
                    $.ajax(
                            {
                                type:"GET",
                                url:"/com/controller/resolveJson",
                                data:"json="+str,
                                success:function(data){
                                    var arr = eval(data);
                                    var count = arr.length;
                                    var content = "";
                                    for(var i = 0;i < count;i++){
                                        var temp = arr[i];
                                        content += "<li>\n";
                                        content += '<a href="#" onclick="$.doOrder(this)" class="event" data-place="'+arr.data.place +'" data-context="'+temp.data.context+'" data-res="'+temp.data+'" data-piece="'+ temp.data.piece +'" data-time="' + temp.data.time +'">' + '\n';
                                        content += '<p class="address"' + temp.data.place + '</p>'+'\n';
                                        content += "</a>" + "\n";
                                        content += "</li>" + "\n";
                                    }
                                    document.getElementById("show").innerHTML = content;
                                }
                            }
                    );
                }
            </script>
        </ul>
    </div>

    <!-- 城市列表 -->
    <div class="sel_container">
        当前城市：<strong id="curCity">北京市</strong> [<a id="curCityText" href="javascript:void(0)">更换城市</a>]
    </div>
    <div class="map_popup" id="cityList" style="display: none">
        <div class="popup_main">
            <div class="title">城市列表</div>
            <div class="cityList" id="citylist_countainer"></div>
            <button id="popup_close"></button>
        </div>
    </div>

    <div class="event-present">
        <div class="event-all" id="event_all">
            <p>交通快报</p>
            <script type="text/javascript">
                for(var a = 0;a < count;a++){
                    var temp = data_json[i];


                    var createDiv = document.createElement("div");
                    createDiv.calssName = "event-content";
                    var createP = document.createElement("p");
                    createP.innerHTML = "";
                    createDiv.appendChild(createP);
                    document.getElementById("event_all").appendChild(createDiv);
                }
            </script>
        </div>
    </div>

    <script type="text/javascript" src="main.js"></script>
    <script type="text/javascript" src="jquery-1.12.0.min.js"></script>
    <script type="text/javascript">
        var clientHeight = $(window).height();
        var $map = $('#l-map');
        var mapHeight = clientHeight - 60;
        $map.css('height',mapHeight + 'px');

        $('#legend').css('bottom','65px');

        $.doOrder = function (tag){
            var place = $(tag).attr("data-place");
            var piece = $(tag).attr("data-piece");
            var context = $(tag).attr("data-context");
            var res = $(tag).attr("data-res");
            var time = $(tag).attr("data-time");
            if(res == "*"){
                res = "其他";
            }
            // 创建地址解析器实例
            var myGeo = new BMap.Geocoder();
            // 将地址解析结果显示在地图上,并调整地图视野
            myGeo.getPoint(place, function(point){
                if(point){
                    var temp;
                    if(piece == 1){
                        var marker = new BMap.Marker(point,{icon:myIcon4});
                        temp = "路况";
                    }else if(piece == 2){
                        var marker = new BMap.Marker(point,{icon:myIcon3});
                        temp = "事故";
                    }else if(piece == 3){
                        var marker = new BMap.Marker(point,{icon:myIcon2});
                        temp = "施工";
                    }else if(piece == 4){
                        var marker = new BMap.Marker(point,{icon:myIcon1});
                        temp = "封路";
                    }else{
                        var marker = new BMap.Marker(point,{icon:myIcon5});
                        temp = "其他";
                    }
                    map.addOverlay(marker);
                    marker.addEventListener("click",getAttr);
                    function getAttr(){
                        var infoWin = new BMap.InfoWindow('<dl>' +
                                '<dt>内容</dt>' +
                                '<dd>' + context + '</dd>' +
                                '<dt>地点</dt>' +
                                '<dd>' + place + '</dd>' +
                                '<dt>类型</dt>' +
                                '<dd>' + temp + '</dd>' +
                                '<dt>时间</dt>' +
                                '<dd>' + time + '</dd>' +
                                '<dt>描述</dt>' +
                                '<dd>' + res + '</dd>',
                                {width:350,title:"详细信息"});
                        map.openInfoWindow(infoWin,point);
                    };
                };
            });
        };

        $('.event').trigger("onclick");
        $(function(){
            $('.event').click(function(e){
                e.preventDefault();
                var time    = $(this).data('time');
                var res     = $(this).data('res');
                var place   = $(this).data('place');
                var piece   = $(this).data('piece');
                var context = $(this).data("context");
                if(res == "*"){
                    res = "其他";
                }
                // 创建地址解析器实例
                var myGeo = new BMap.Geocoder();
                // 将地址解析结果显示在地图上,并调整地图视野
                myGeo.getPoint(place, function(point){
                    if (point) {
                        map.centerAndZoom(point, 16);
                        var temp = "";
                        if(piece == 1){
                            //var marker = new BMap.Marker(point,{icon:myIcon4});
                            temp = "路况";
                        }else if(piece == 2){
                            var marker = new BMap.Marker(point,{icon:myIcon3});
                            //temp = "事故";
                        }else if(piece == 3){
                            var marker = new BMap.Marker(point,{icon:myIcon2});
                            //temp = "施工";
                        }else if(piece == 4){
                            //var marker = new BMap.Marker(point,{icon:myIcon1});
                            temp = "封路";
                        }else{
                            //var marker = new BMap.Marker(point,{icon:myIcon5});
//                            for(var i = 0;i < piece.length;i++){
//                                switch(piece[i]){
//                                    case 1:
//                                        temp += " 路况";
//                                        break;
//                                    case 2:
//                                        temp += " 事故";
//                                        break;
//                                    case 3:
//                                        temp += " 施工";
//                                        break;
//                                    case 4:
//                                        temp += " 封路";
//                                        break;
//                                    default:
//                                        temp = "其他";
//                                }
//                            }
                            temp = "其他";
                        }
                        //map.addOverlay(marker);
                        var infoWin = new BMap.InfoWindow('<dl>' +
                                '<dt>内容</dt>' +
                                '<dd>' + context + '</dd>' +
                                '<dt>地点</dt>' +
                                '<dd>' + place + '</dd>' +
                                '<dt>类型</dt>' +
                                '<dd>' + temp + '</dd>' +
                                '<dt>时间</dt>' +
                                '<dd>' + time + '</dd>' +
                                '<dt>描述</dt>' +
                                '<dd>' + res + '</dd>',
                                {width:350,title:"详细信息"});
                        map.openInfoWindow(infoWin,map.getCenter());
                    }else{
                        alert("您选择地址没有解析到结果!");
                    }
                });
            });

            $('.event-content').eq(0).addClass('in');
            switchEventContent();
            function switchEventContent() {
                $('.event-content').eq(0).removeClass('in').addClass('out')
                        .end().eq(1).addClass('in');
                setTimeout(function() {
                    $('.event-content').eq(0).removeClass('out').appendTo('.event-all');
                    switchEventContent();
                }, 2500);
            };
        });

        var filename = document.getElementById("filename").getAttribute("value");
        var obj      = document.getElementById("option");
        var len      = obj.options.length;
        for(var i = 0;i < len;i++){
            if(obj.options[i].getAttribute("value") == filename){
                obj.options[i].selected = true;
                break;
            }
        }
    </script>
</body>
</html>