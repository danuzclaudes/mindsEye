// http://stackoverflow.com/questions/30211605
$('document').ready(function () {
    ////////////////////////////////////////////////////////
    // register graph and time-line with onDrag() event
    ////////////////////////////////////////////////////////
    graph2d.on('rangechange', onDragGraph);
    timeline.on('rangechange', onDragTimeLine);

    ////////////////////////////////////////////////////////
    // access all cycles/points on graph and register listeners
    ////////////////////////////////////////////////////////
    // console.log($('svg')[0].children.length);
    var arr = Array.prototype.slice.call($('svg')[0].children);
    // console.log(arr[0].nodeName);
    // http://stackoverflow.com/questions/10024866
    var circles = arr.filter(function (entry){
        return entry.nodeName !== "path";
    });

    // register mouseover function on each cycle point;
    registerMouseOverPoints(circles);
});
