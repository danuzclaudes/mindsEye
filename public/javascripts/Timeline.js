/////////////////////////////////////////////////////////////
// apply singleton pattern to create Timeline of drug history
/////////////////////////////////////////////////////////////
var Timeline = (function() {
    var singleton;

    function createSingleton() {
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
        for (var i = 0; i < 9; i++) {
            groups.add({
                id: groupNames[i], // bug: should also be class name
                content: groupNames[i],
                style: "padding-left: 64px"
            });
        }

        // Create a Timeline
        return new vis.Timeline(container, new vis.DataSet(), groups);
    };

    return {
        getInstance: function() {
            if (!singleton) {
                singleton = createSingleton();
            }
            return singleton;
        }
    }
})();
