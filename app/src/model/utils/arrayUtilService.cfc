component {
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
            var hashKey = getHashKey(obj, propertyList);

            if (!lookupStruct.keyExists(hashKey)) {
                lookupStruct[hashKey] = 1;
                returnArray.append(obj);
            }
        }
        return returnArray;
    }

    private string function getHashKey(required component obj, required string propertyList){
        var keyArray = [];
        
        keyArray.append(getMetaData(obj).name);
        for (var property in propertyList) {
            keyArray.append( invoke(obj,"get#property#") ?: '' );
        }
        return arrayToList(keyArray, chr(7));
    }
}