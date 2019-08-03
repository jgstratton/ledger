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

}