import play.*;
import play.mvc.*;
import play.libs.F.Promise;

import static play.mvc.Results.*;

public class Global extends GlobalSettings {

    @Override
    public void onStart(Application app){
        Logger.info("Welcome to MindsEye...");
    }

    public Promise<Result> onBadRequest(Http.RequestHeader request, String error) {
        return Promise.<Result>pure(
            badRequest(views.html.error.render("Don't try to hack the URI!"))
        );
    }

    public Promise<Result> onHandlerNotFound(Http.RequestHeader request) {
        return Promise.<Result>pure(notFound(
                views.html.error.render(request.uri() + " Not Found!")
        ));
    }
}
