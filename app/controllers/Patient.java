package controllers;

import play.Logger;
import play.data.DynamicForm;
import play.data.Form;
import play.mvc.Controller;
import play.mvc.Result;
import views.html.dashboard;
import views.html.error;

public class Patient extends Controller {

    public Result dashboard(int id) {
        Result tmp = validate(Integer.toString(id));
        // set up patient id across session if valid
        session().clear();
        session("patient", id + "");
        return tmp.status() != 200 ? tmp : ok(dashboard.render(id));
    }

    public Result post() {
        DynamicForm requestForm = Form.form().bindFromRequest();
        if (requestForm.hasErrors()) {
            return badRequest(error.render("Invalid Form POST!"));
        }
        Result tmp = validate(requestForm.data().get("patient"));
        // redirect if successfully validate and record is found
        return tmp.status() != 200 ? tmp : redirect(
            routes.Patient.
            dashboard(Integer.valueOf(requestForm.get("patient")))
        );
    }

    private Result validate(String patient) {
        try {
            Integer.parseInt(patient);
        } catch (NumberFormatException e) {
            Logger.error("A");
            return badRequest(error.render("Invalid Patient ID!"));
        } catch (NullPointerException e) {
            return badRequest(error.render("Invalid Form POST!"));
        } finally {
            // will reach finally no matter if an exception is caught;
            // even after a return statement in catch
            Logger.debug("B");
        }
        // will not reach beyond finally if exception is caught
        Logger.info("C");
        if (!search(patient)) {
            return badRequest(error.render(
                "Cannot find records of Patient # " + patient + "!")
            );
        }
        return ok();
    }

    private boolean search(String patient) {
        return models.Patient.find.where()
                .eq("patientId", Integer.valueOf(patient))
                .findRowCount() > 0;
    }

}
