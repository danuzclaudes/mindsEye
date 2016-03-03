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

import views.html.error;
import views.html.medicines.medlist;


public class Medication extends Controller {

    /**
     * Get accepted file type of this HTTP request
     */
    private String acceptedTypes;
    /**
     * Get previous url that directing to medicine-list page
     * https://stackoverflow.com/a/23816747
     */
    private String refererUrl;

    public Result getByPatient(int patient) {
        Logger.debug("Get all medicines of patient " + patient);
        List<models.Medication> allMeds = models.Medication.findMedsByPatient(patient);

        return decideContentType(allMeds, patient + "", true);
    }

    /**
     * Returns all medications data on a visit.
     * The response of this `GET` request will be either HTML tables
     * through the Viewer `medlist.scala.html` by default,
     * or JSON type as response of AJAX calls
     * @param   visit   MD5 hashed visit id
     * @return  visit's medicines data according to content-type
     */
    public Result getByVisit(String visit) {
        Logger.debug("Get all medicines...");
        List<models.Medication> allMeds = models.Medication.findMedsByVisit(visit);

        acceptedTypes = request().acceptedTypes().get(0).toString();
        refererUrl = request().getHeader("referer");
        Logger.debug("Previous URL: " + refererUrl);

        return decideContentType(allMeds, visit, false);
    }

    private Result decideContentType(List<models.Medication> allMeds, String id, boolean flag){
        acceptedTypes = request().acceptedTypes().get(0).toString();
        refererUrl = request().getHeader("referer");

        if (acceptedTypes.equals("text/html")) {
            String title = "Medicine Records for " + (flag ? "patient" : "visit");
            return ok(medlist.render(id, title, allMeds, refererUrl));
        } else if (acceptedTypes.equals("application/json")) {
            return getAllInJSON(allMeds);
        } else {
            return badRequest(error.render(
                    "Bad Request for Medications"));
        }
    }

    private final DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

    /**
     * Returns all medications data of prescribed on one visit `visit`.
     * The medictions data will be returned as input data for TimeLine
     * through AJAX calls.
     * @param   allMeds  list of all selected and sorted medicines
     * @return  a JSON object as dataset of TimeLine
     *
     * Example:
     * [{id:8, content:'...', start:'...', end:'...', group:'TCA'},...]
     */
    public Result getAllInJSON(List<models.Medication> allMeds) {
        ObjectMapper mapper = new ObjectMapper();
        ArrayNode result = Json.newArray();

        for (models.Medication med : allMeds) {
            ObjectNode item = mapper.createObjectNode();
            item.put("id", med.medId);
            item.put("content", med.medName);
            item.put("start", df.format(med.medStartDate));
            item.put("group", med.medGroup);
            if (med.medEndDate != null)
                item.put("end", df.format(med.medEndDate));
            result.add(item);
        }
        response().setContentType("application/json");
        return ok(result);
    }
}
