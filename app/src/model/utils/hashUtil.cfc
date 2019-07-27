component {

    //Generate a hash key using the object type (name) and property values, if property list is not passed, it will use the id fieldtype
    public string function getComponentHashKey(required component obj, string argPropertyList){
        var keyArray = [];
        var propertyList = argPropertyList ?: getIdProperties(obj);

        keyArray.append(getMetaData(obj).name);

        for (var property in propertyList) {
            keyArray.append( invoke(obj,"get#property#") ?: '' );
        }

        //the default MD5 hash is fine for this purpose
        var returnValue = arrayToList(keyArray, chr(7));
        return returnValue;
    }

    //get the ID fieldtype properties from the object
    private array function getIdProperties(required component obj) {
        var idProperties = [];
        var properties = getMetaData(arguments.obj).properties;
        for (var property in properties) {
            if (property.keyExists('fieldType') && property.fieldtype == 'id'){
                idProperties.append(property.name);
            }
        }
        return idProperties;
    }
}