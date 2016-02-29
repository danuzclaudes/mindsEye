/////////////////////////////////////////////////////////////
// apply singleton pattern to create Timeline of drug history
/////////////////////////////////////////////////////////////
var Timeline = (function(){
    var singleton;

    function createSingleton(){
        // DOM element where the Timeline will be attached
        var container = document.getElementById('interval');
        
        /////////////////////////////////////////////////////
        // hard-coded; needs to read all drug classes from db
        /////////////////////////////////////////////////////
        var groupNames = [
            'AAP', 'BUP', 'D2', 'LI', 'LTG',
            'OLZ', 'SNRI', 'SSRI', 'TCA'
        ];
        var groups = new vis.DataSet();
        for(var i = 0; i < 9; i++){
            groups.add({
       	        id: groupNames[i],  // bug: should also be class name
                content: groupNames[i],
                style: "padding-left: 64px"
            });
        }
        // create a DataSet of medications
        var dataset = new vis.DataSet();
        for(var i = 0; i < prescriptions.length; i++){
            dataset.add({
                id: prescriptions[i].id,
                content: prescriptions[i].content,
                group: prescriptions[i].group,
                start: prescriptions[i].start,
                end: prescriptions[i].end,
                type: prescriptions[i].type == 'point' ? 'point' : ''
            });
        }
        // configuration for the Timeline
        var options = {
            maxHeight: 450,
            width: 1000,
            autoResize: true,
            // assume range of prescription is confined with first/last visit?
            start: graph_start_format(visits[0].x),
            end: graph_end_format(visits[visits.length - 1].x),
            // set granulized dates
            timeAxis: {
                scale: 'day',
                step: 3,
            },
        };
        // Create a Timeline
        return new vis.Timeline(container, dataset, groups, options);
    };

    return {
        getInstance: function(){
            if(! singleton){
                singleton = createSingleton();
            }
            return singleton;
        }
    }
})();

var timeline = Timeline.getInstance();
