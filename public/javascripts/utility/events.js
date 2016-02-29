function onDragGraph(range){
    // utility function of reaction to drag/zoom-in/out 2d-graph
    // console.log('rangechange', range);
    // timeline.setWindow({
    timeline.setOptions({
        start: range.start,
        end: range.end,
    });
}

function onDragTimeLine(range){
    // utility function of reaction to drag/zoon-in/out timeline
    graph2d.setOptions({
        start: range.start,
        end: range.end,
    });
}

function registerMouseOverPoints(circles){
    // register each point on 2d graph with mouse-over event
    // function scope:
    // http://stackoverflow.com/questions/6077357
    $.each(circles, function(index, value){
        $(value).mouseover(function () {
            showModal(value, index);
        });
    });
}

function showModal(circle, index){
    // display patient notes when mouse is over point on 2d graph
    // http://stackoverflow.com/questions/18690355
    $(document).ready(function(){
        var eid = $('#dialog');
        var blurb = visits[index].notes;

        console.log("mouse hovin "+ index);
        eid.css({"height":"100px", "background-color":"wheat", "padding":"10px",});
        eid.html(blurb);

        eid.dialog({
            autoOpen:false,
            title:"Visit Note on " + visits[index].x,
            show: "fade",
            hide: "fade",
            width: 500, //orig defaults: width: 300, height: auto
            buttons: {
                OK: function() {
                    $(this).dialog('close');
                }
            }
        }); // END eid.dialog
        eid.dialog('open');
    });  // END $(document).ready
}
