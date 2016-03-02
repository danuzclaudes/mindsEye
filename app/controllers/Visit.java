package controllers;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import play.Logger;
import play.libs.Json;
import play.mvc.*;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;

import views.html.*;

public class Visit extends Controller {

    /**
     * Returns all visiting data of a patient.
     * The response of this `GET` request will be either HTML tables
     * through the Viewer `visitlist.scala.html` by default,
     * or JSON type as response of AJAX calls.
     * @param   id    patient's id
     * @return  user's visiting data according to content-type
     */
    public Result getAll(int id){
        Logger.debug("Get all visits...");
        List<models.Visit> allVisits = models.Visit.find.where()
            .eq("patient_id", id).findList();
        String acceptedTypes = request().acceptedTypes().get(0).toString();

        if(acceptedTypes.equals("text/html")){
            // render visits data through Viewer `visitlist` in tabular form
            return ok(visitlist.render(id, "Visiting Records", allVisits));
        }
        else if(acceptedTypes.equals("application/json")){
            // return visits data in JSON to `main.js`
            return getAllInJSON(id);
        }
        else {
            return badRequest(badrequest.render("Bad Request"));
        }
    }

    private final DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * Returns all visiting data of a patient in JSON format directly.
     * The visits will be returned as input data for Graph through
     * AJAX calls.
     * @param   id    user id
     * @return  an array of JSON objects as dataset of Graph2D
     *
     * Example: [{x:"2011-01-12","y":7,"group":0,"notes":"...",...}]
     */
    public Result getAllInJSON(Integer id) {
        ObjectMapper mapper = new ObjectMapper();
        ArrayNode result = Json.newArray();

        for(models.Visit v :
                models.Visit.find.where().eq("patient_id", id).findList()){
            result.add(
                mapper.createObjectNode()
                    .put("x", df.format(v.visitDate))
                    .put("y", v.cgiScore)
                    .put("group", v.visitGroup)
                    .put("notes", v.visitNotes)
            );
        }
        response().setContentType("application/json");
        return ok(result);
    }

}
