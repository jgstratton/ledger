component output="false" {

	public boolean function methodHasAnnotation(required component obj, required string methodName, required string annotation) {
        return getMetaFunction(obj,methodName).keyExists(annotation);
    }

    /**
     * Returns string or null (if annotation doesn't exist)
     */
    public any function getMethodAnnotation(required component obj, required string methodName, required string annotation) {
        var metaFunction = getMetaFunction(obj,methodName);
        if (metaFunction.keyExists(annotation)) {
            return metaFunction[annotation];
        }
        return;
    }

    private struct function getMetaFunction(required component obj, required string methodName) {
        for (var fnc in getMetaData(obj).functions) {
            if (fnc.name == methodName) {
                return fnc;
            }
        }
        //if the method name was not found in the meta data, then throw an error
        throw(message='"#arguments.methodName#" was not found in component #getName(obj)#', type="invalidMethodName");
    }

    private string function getName(required component obj) {
        return getMetaData(obj).name;
    }
}
