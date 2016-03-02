package controllers;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import play.Logger;
import play.libs.Json;
import play.mvc.Controller;
import play.mvc.Result;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;

public class Medication extends Controller {

    public Result getAll(String visit){
        List<models.Medication> allMeds =
                models.Medication.findMedsByVisit(visit);
        Logger.debug(allMeds.get(0).medStartDate + "");
        return ok("found all meds");
    }

    private final DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

    public Result getAllInJSON(String id) {
        Logger.debug("Get all medicines in JSON format");
        ObjectMapper mapper = new ObjectMapper();
        ArrayNode result = Json.newArray();

        // @TODO
        // restore json format as of visits.js
        // {id: 8, content: 'item 5', start: '2015-10-28', end: '2015-11-12', group: 'TCA'},
        for(models.Medication med : models.Medication.findMedsByVisit(id)){
            ObjectNode item = mapper.createObjectNode();
            item.put("id", med.medId);
            item.put("content", med.medName);
            item.put("start", df.format(med.medStartDate));
            item.put("group", med.medGroup);
            if(med.medEndDate != null) item.put("end", df.format(med.medEndDate));
            result.add(item);
        }
        // Logger.debug(result + "");

        response().setContentType("text/javascript");
        return ok(result);
    }
}
