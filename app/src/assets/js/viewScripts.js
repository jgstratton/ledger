/**
 * Scripts that get loaded in the views will be gathered and processed
 * at the end of the request.  At this point all of the DOM elements will be loaded.
 * If a script is given a name, then it will only be executed once.
 */
var viewScripts = {};

(function() {
    var scripts = [];
    var scriptNames = {};
    var self = this;

    //use this in the views to add scripts to the queue
    this.add = function(script, scriptName) {
        if (typeof scriptName != 'undefined') {
            if (scriptName in scriptNames) {
                return;
            }
            scriptNames[scriptName] = true;
            scripts.push(script);
            return;
        }

        scripts.push(script);
    };

    //run this after all the js files are included, runs through the queue and executes any scripts.
    this.run = function() {
        if (scripts.length > 0) {
            var thisScript = scripts.shift();
            thisScript();
            self.run();
        }
    };
}.apply(viewScripts));
