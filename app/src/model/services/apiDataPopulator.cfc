component output="false" accessors=true {
    property hashUtil;

    variables.executioncount = 0;

    /**
     * Default settings for getting accounts data
     */
    public struct function populateAccountsStruct(required component obj, struct config = {}) {
        var apiData = new beans.apiData({
            maxDepth: 3,
            maxbreadth: 100,
            excludeProperties: 'transactions,user'    
        });

        var returnStruct = populateApiData(obj, apiData);
        return returnStruct;
    }

    /**
     * Returns either a struct, or it returns null if it's reach it's max depth
     */
    public struct function populateApiData(required component obj, required component apiData) {
        var dataStruct = populateStructComponent(obj, apiData, 0);
        return dataStruct;
    }

    /**
     * Returns either a struct, or it returns null if it's reach it's max depth
     */
    private struct function populateAllProperties(required component obj, required component apiData, required numeric depth) {
        var returnStruct = {};
        var meta = getComponentMetadata(obj);

        //return empty struct if we've hit our maximum configured depth
        if (depth > apiData.getMaxDepth()) {
            return {};
        }

        for (var prop in meta.properties) {
            populateValueByProperty(obj, apiData, depth, prop, returnStruct);
        }

        return returnStruct;
    }

    /**
     * Populates the struct key value based on the poperty
     */
    private void function populateValueByProperty(required component obj, required component apiData, required numeric depth, required struct property, required struct returnStruct) {
        //if property is excluded then, exit before attempting to get the property
        if (apiData.propertyIsExluded(property)) {
            return;
        }

        //if property has a custom getter, then use it otherwise use the default getters
        if (property.keyExists('apiDataPopulatorFnc')) {
            arguments.returnStruct[property.name] = invoke(obj,"#property.apiDataPopulatorFnc#");
            return;
        } else {
            var value = invoke(obj,"get#property.name#");
        }
        
        //if the value doesn't exist then just exit now, nothing to populate
        if (!local.keyExists('value')) {
            return;
        }

        //if the property has a "fieldType" key, then we're dealing with orm relationships
        if (property.keyExists('fieldType')){
            switch(property.fieldType) {
                case "many-to-one" :
                case "one-to-one" :
                    if (depth + 1 < apiData.getMaxDepth()) {
                        arguments.returnStruct[property.name] = populateStructComponent(value, apiData, depth);
                    }
                    return;
                case "one-to-many" :
                    var componentArray = [];
                    arguments.returnStruct[property.name] = [];
                    var curBreadth = 0;
                    for (var arrObj in value) {
                        curBreadth += 1;
                        if (curBreadth > apiData.getMaxBreadth()) {
                            break;
                        }
                        if (depth + 1 < apiData.getMaxDepth()) {
                            componentArray.append(populateStructComponent(arrObj, apiData, depth));
                        }
                    }
                    arguments.returnStruct[property.name] = componentArray;
                    
                    return;
                default :
                    // if fieldtype isn't found... continue on to types
            }
        }

        switch(property.type) {

            case "any" : 
            case "numeric" : 
            case "string" : 
                arguments.returnStruct[property.name] = value;
                return;
            case "boolean" :
                arguments.returnStruct[property.name] = (value) ? true : false; //normalize boolean values
                return;
            default :
                throw("Property type not supported for API populator");
        }
        
    }

    /**
     * Checks the state to see if the object has been populated yet.  If it has, it returns the hash value of the current object.  If not, it
     * processes the object adds the current obj's hash to the state.  This will save us from an infinite loop where (such as where an object is 
     * related to itself).
     */
    private struct function populateStructComponent(required component obj, required component apiData, required numeric depth) {
        var componentStruct = {};
        if (!isNull(obj)) {
            var objKey = getHashUtil().getComponentHashKey(obj);
            if (!apiData.hasKey(objKey)) {
                apiData.addKey(objKey);
                componentStruct = populateAllProperties(obj, apiData, depth + 1);
            }
            componentStruct._hashValue = apiData.getHash(objKey);
        }
        return componentStruct;
    }

}