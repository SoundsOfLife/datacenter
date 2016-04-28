var map = new BMap.Map("l-map");          // 创建地图实例
var point = new BMap.Point(116.403694,39.927552);  // 创建点坐标
var  mapStyle ={
    features: ["road", "building","water","land"],//隐藏地图上的poi
    style : "dark"  //设置地图风格为高端黑
};
map.setMapStyle(mapStyle);
map.centerAndZoom(point, 15);                 // 初始化地图，设置中心点坐标和地图级别
map.enableScrollWheelZoom();
map.addControl(new BMap.NavigationControl());  //添加默认缩放平移控件

var myIcon1 = new BMap.Icon("./img/accident1.png", new BMap.Size(32,32));
var myIcon2 = new BMap.Icon("./img/accident2.png", new BMap.Size(32,32));
var myIcon3 = new BMap.Icon("./img/accident3.png", new BMap.Size(32,32));
var myIcon4 = new BMap.Icon("./img/accident4.png", new BMap.Size(32,32));
var myIcon5 = new BMap.Icon("./img/accident5.png", new BMap.Size(32,32));

// 创建CityList对象，并放在citylist_container节点内
var myCl = new BMapLib.CityList({container : "citylist_container", map : map});
// 给城市点击时，添加相关操作
myCl.addEventListener("cityclick", function(e) {
    // 修改当前城市显示
    document.getElementById("curCity").innerHTML = e.name;
    // 点击后隐藏城市列表
    document.getElementById("cityList").style.display = "none";
});
// 给“更换城市”链接添加点击操作
document.getElementById("curCityText").onclick = function() {
    var cl = document.getElementById("cityList");
    if(cl.style.display == "none"){
        cl.style.display = "";
    }else{
        cl.style.display = "none";
    }
};
// 给城市列表上的关闭按钮添加点击操作
document.getElementById("popup_close").onclick = function() {
    var cl = document.getElementById("cityList");
    if (cl.style.display == "none") {
        cl.style.display = "";
    } else {
        cl.style.display = "none";
    }
};