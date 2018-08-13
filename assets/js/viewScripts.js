var viewScripts = {};

(function() {
    var scripts = [];
    var self = this;

    //use this in the views to add scripts to the queue
    this.add = function(script) {
        scripts.push(script);   
    };
 
    //run this after all the js files are included, runs through the queue and executes any scripts.
    this.run = function() {
        if(scripts.length > 0){
            var thisScript = scripts.shift();
            thisScript();
            self.run();
        }
    }
}).apply(viewScripts);   