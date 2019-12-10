component accessors="true" {
    property hashUtil;

    /**
     * Remove all duplicates from an array of objects by using the object name and specified properties
     */
    public array function getDistinctComponents(required array objArray, required string propertyList) {
        
        //if the array is empty return
        if (!objArray.len()) {
            return objArray;
        }

        var returnArray = [];
        var lookupStruct = {};

        for (var obj in objArray) {
            var hashKey = getHashUtil().getComponentHashKey(obj, propertyList);

            if (!lookupStruct.keyExists(hashKey)) {
                lookupStruct[hashKey] = 1;
                returnArray.append(obj);
            }
        }
        return returnArray;
       }

    /**
     * Compare two arrays and returns the items that are the same in both (removes duplicates).
     */
    public array function arrayIntersect(required array array1, required array array2) {
        var lookup = {};
        var intersection = {};
        for (var item1 in array1) {
            lookup[item1] = 1;
        }
        for (var item2 in array2) {
            if(lookup.keyExists(item2)) {
                intersection[item2] = 1;
            }
        }
        
        return listToArray(structKeyList(intersection));
    }
}