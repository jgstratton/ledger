/**
 * alertService provdes a mechanism for storing fail/success messages temporarily in the session to 
 * avoid the need to pass them through the url or form scopes.  This will all allow for the alerts to be 
 * displayed only once (and then cleared from the session) so that the same alerts don't reappear on page 
 * refreshes, or interfere with other value remembering mechanisms.
 * */
component output="false" {

    /**
     * @fn add
     * Adds the message to the given alert type
     * */
    public void function add( required string type, required string message) {
        lock scope="session" type="exclusive" timeout="30" {
            initType(type);
            session.alertService[type].messages.append(message);
        }
    }

    /**
     * @fn addMultiple
     * Pass in an array to add multiple error messages to the alert type
     */
    public void function addMultiple( required string type, required array messages) {
        lock scope="session" type="exclusive" timeout="30" {
            initType(type);
            for (var message in messages) {
                session.alertService[type].messages.append(message);
            }
        }
    }

    /**
     * @fn getFontIcon
     * Get the font icon class for the alert type
     */
    public string function getFontIcon( required string type ) {
        switch (type) {
            case "danger":
                return "fa fa-exclamation-triangle";
            case "warning":
                return "fa fa-exclamation-circle";
            case "success":
                return "fa fa-check";
            default:
                return "";
        }
    }

    /**
     * @fn setTitle
     * Set the optional title for the error type
     */
    public void function setTitle( required string type, required string title) {
        lock scope="session" type="exclusive" timeout="30" {
            initType(type);
            session.alertService[type].title = arguments.title;
        }
    }

    /**
     * @fn render
     * return the alerts object for rendering
     */
    public struct function fetch(){
        var result = "";

        lock scope="session" type="exclusive" timeout="30" {
            initSessionAlertService();
            var alerts = structCopy(session.alertService);
            session.alertService.clear();
            return alerts;
        }
    }

    /**
     * @fn initType
     * Sets up the alert type in the session object if it doesn't already exsit
     * */
    private void function initType( required string type ){
        initSessionAlertService();
        if (!session.alertService.keyExists(type)){
            session.alertService[type] = { title: '', messages: [] };
        }
    }

    /**
     * initSessionAlertService
     * Make sure the alert service is defined in the session object
     */
    private void function initSessionAlertService(){
        if (!session.keyExists('alertService')) {
            session.alertService = {};
        }
    }
}