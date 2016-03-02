////////////////////////////////////////////////////////
// apply singleton pattern to create Graph of visits
////////////////////////////////////////////////////////
var Graph2d = (function(){
    var singleton;

    function createSingleton(){
        var container = document.getElementById('graph');
        var groups = new vis.DataSet();
        groups.add({
            id: 0,
            content: "CGI scores",
        });
        return new vis.Graph2d(container, new vis.DataSet(), groups);
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
