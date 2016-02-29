function graph_dataAxis_left_format(value){
    // Insert a custom function to format the label by value
    // The labels could be changed here for numeric scores other than CGI.
    var res = "";
    switch(value) {
        case 0: case 1: case 3:
        case 4: case 5: case 7:
            res = "" + value; break;
        case 2:
            res = "<=2 good"; break;
        case 6:
            res = ">=6 worse"; break;
        default:
            // console.log("Invalid score");
    }
    return res;
}

function graph_end_format(endDate){
    // format end date of graph 2d by end + 5 days
    var tmp = new Date(endDate);
    tmp.setDate(tmp.getDate() + 5);
    return tmp;
}

function graph_start_format(startDate){
    // format start date of graph 2d by start - 5 days
    var tmp = new Date(startDate);
    tmp.setDate(tmp.getDate() - 5);
    return tmp;
}
