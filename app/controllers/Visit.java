package controllers;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import play.Logger;
import play.libs.Json;
import play.mvc.Controller;
import play.mvc.Result;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;

import views.html.*;

public class Visit extends Controller {

    /**
     * Returns all visiting data of a patient.
     * The visits will be displayed as HTML tables through
     * the Viewer of `visitlist.scala.html`.
     * @param   id    user id
     * @return  user's visiting data in tabular form
     */
    public Result getAll(int id){
        List<models.Visit> allVisits = models.Visit.find.where()
            .eq("patient_id", id).findList();
        return ok(visitlist.render(id, "Visiting Records", allVisits));
    }

    private final DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * Returns all visiting data of a patient in JSON format.
     * The visits will be returned as input data for Graph through
     * javaScript Routers.
     * @param   id    user id
     * @return  an array of JSON objects as dataset of Graph2D
     *
     * Example: [{x:"2011-01-12","y":7,"group":0,"notes":"...",...}]
     */
    public Result getAllInJSON(Integer id) {
        Logger.debug("Get all visits in JSON format");
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
        Logger.debug(result + "");

        response().setContentType("text/javascript");
        return ok(result);
    }

}
