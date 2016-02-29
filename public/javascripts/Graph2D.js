////////////////////////////////////////////////////////
// apply singleton pattern to create Graph of visits
////////////////////////////////////////////////////////
var Graph2d = (function(){
    var singleton;

    function createSingleton(){
        var container = document.getElementById('graph');
        var dataset = new vis.DataSet(visits);
        var groups = new vis.DataSet();
        groups.add({
            id: 0,
            content: "CGI scores",
        });
	    var options = {
            start: graph_start_format(visits[0].x),
            end: graph_end_format(visits[visits.length - 1].x),
            dataAxis: {
                left: {
                    format: graph_dataAxis_left_format,
                    range: { min: 0, max: 8 }
                }
            },
            drawPoints: {
                size: 10,
                style: 'circle',
            },
            graphHeight: 250,
            legend: {
                enabled: true,
                left: {
                    visible: true,
                    position: 'top-right'
                }
            },
            maxHeight: 350,
            sort: true,
            // set granulized dates
            timeAxis: {
                scale: 'day',
                step: 3,
            },
            width: 1000,
            shaded: {
               orientation: 'bottom'
            },
        };

        return new vis.Graph2d(container, dataset, groups, options);
    };

    return {
        getInstance: function () {
            if(! singleton){
                singleton = createSingleton();
            }
            return singleton;
        }
    }
})();

var graph2d = Graph2d.getInstance();
