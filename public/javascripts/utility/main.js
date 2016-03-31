/**
 * Retrieve backend db through AJAX and Return JSONs as data of Graph/TimeLine
 */
var ajaxMedicationsDone = false,  // flag if ajax to retrieve medications done
    ajaxVisitsDone = false,
    prescriptions = [],  // dataset for Time-line
    visits = [];  // dataset for 2D Graph
console.log("Retrieving all data...");

/**
 * Set up Time-line data and options by medications from a visit.
 * The AJAX call should retrieve all medications records related to
 * the patient, instead of only one visit
 * Documentation: http://visjs.org/docs/timeline/
 * @id      id of drug          required
 * @content name of medicine    required
 * @start   start date of drug
 * @group   group of medicine
 */
$.ajax({
    type: 'GET',
    dataType: 'json',
    // url: '/visit/84f22a76e57ab37dde3af8ec5e21f670/medications',
    url: '/patient/'+ $('#user-id').attr("class") +'/medications',
    success: function(return_obj, status, jqXHR) {
        // BZ: must deserialize from string to JSON objects
        // prescriptions = jQuery.parseJSON(return_obj);
        prescriptions = return_obj;
        // create a DataSet of medications
        var dataset = new vis.DataSet();
        for (var i = 0; i < prescriptions.length; i++) {
            dataset.add({
                id: prescriptions[i].id,
                content: prescriptions[i].content,
                group: prescriptions[i].group,
                start: prescriptions[i].start,
                end: prescriptions[i].end,
                type: prescriptions[i].type == 'point' ? 'point' : ''
            });
        }
        Timeline.getInstance().setItems(dataset);

        // configuration for the Timeline
        var timeRange = Timeline.getInstance().getItemRange();
        Timeline.getInstance().setOptions({
            maxHeight: 450,
            width: 1000,
            autoResize: true,
            start: graph_start_format(timeRange.min),
            end: graph_end_format(timeRange.max),
            // set granularity of x-axis
            timeAxis: {
                scale: 'day', // be cautious to set 'day'
                step: 7,
            },
        });

        console.log("ALl Prescriptions by this Visit retrieved...");
        ajaxMedicationsDone = true;
    },
    error: function(response, status, errorThrown) {},
});

/**
 * Set up 2D Graph data and options by visiting data of a user.
 * Documentation: http://visjs.org/docs/graph2d/
 * @x       date of visit as x-axis on graph    required
 * @y       CGI score as y-axis on graph        required
 * @group   group for vis dataset, default 0
 * @notes   notes for this visit
 */
$.ajax({
    type: 'GET',
    dataType: 'json',
    url: '/patient/'+ $('#user-id').attr("class") +'/visits',
    success: function(return_obj, status, jqXHR) {
        // BZ: must deserialize from string to JSON objects
        // visits = jQuery.parseJSON(return_obj);
        visits = return_obj;
        Graph2d.getInstance().setItems(new vis.DataSet(visits));

        // configuration for the Graph
        var timeRange = Graph2d.getInstance().getDataRange();
        Graph2d.getInstance().setOptions({
            autoResize: true,
            start: graph_start_format(timeRange.min),
            end: graph_end_format(timeRange.max),
            dataAxis: {
                left: {
                    format: graph_dataAxis_left_format,
                    range: {
                        min: 0,
                        max: 8
                    }
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
            // maxHeight: 350,
            sort: true,
            // set granularity of x-axis
            timeAxis: {
                scale: 'day', // be cautious to set 'day'
                step: 7,
            },
            width: 1000,
            shaded: {
                orientation: 'bottom'
            },
        });

        console.log("ALl Visits by this Patient retrieved...");
        ajaxVisitsDone = true;
        // console.log("start for graph2d", graph_start_format(visits[0].x));
        // console.log("start for timeline", graph_start_format(visits[0].x));
        // console.log("end for timeline", graph_end_format(visits[visits.length - 1].x));
    },
    error: function(response, status, errorThrown) {},
});


$('document').ready(function() {
    ////////////////////////////////////////////////////////
    // Apply singleton pattern to register graph and timeline
    // on dragging events to each other.
    ////////////////////////////////////////////////////////
    Timeline.getInstance().on('rangechange', onDragTimeLine);
    Graph2d.getInstance().on('rangechange', onDragGraph);
    Graph2d.getInstance().on('rangechange', onDragGraph);

    ////////////////////////////////////////////////////////
    // Display loading effect while reading from database.
    // Thanks to: http://codepen.io/agrimsrud/pen/EmCoa
    ////////////////////////////////////////////////////////
    var loader = document.getElementById('loader'),
        border = document.getElementById('border'),
        α = 0,
        π = Math.PI,
        t = 3;

    (function draw() {
        α++;
        α %= 360;
        var r = (α * π / 180),
            x = Math.sin(r) * 125,
            y = Math.cos(r) * -125,
            mid = (α > 180) ? 1 : 0,
            anim = 'M 0 0 v -125 A 125 125 1 ' + mid + ' 1 ' + x + ' ' + y + ' z';
        loader.setAttribute('d', anim);
        border.setAttribute('d', anim);
        setTimeout(draw, t); // Redraw
    })();

    setTimeout(function() {
        ////////////////////////////////////////////////////////
        // Access all cycles/points on graph and register listeners
        ////////////////////////////////////////////////////////
        // http://stackoverflow.com/questions/30211605
        var arr = Array.prototype.slice.call($('svg')[1].children);
        // console.log($('svg')[1].children.length);
        // http://stackoverflow.com/questions/10024866
        var circles = arr.filter(function(entry) {
            return entry.nodeName !== "path";
        });
        // register mouseover function on each cycle point;
        registerMouseOverPoints(circles);

        // fade out loading as soon as all AJAX has returned
        if(ajaxMedicationsDone && ajaxVisitsDone){
            $('#loading').animate({ height: "0px", opacity: 0 }, 500);
            console.log("All data retrieved...");
        }
    }, 3000);

});