component accessors="true" {
    property name="config" type="struct";
    property name="componentKeys" type="struct";
    property name="generatedData" type="struct";

    public component function init(struct config = {}) {

        //default config:
        var config = {
            maxDepth: 10,
            excludeProperties: '',
            maxbreadth: 1000
        }

        structAppend(local.config, arguments.config, true);
        variables.config = local.config;
        variables.componentKeys = {};
        variables.generatedData = {};

        return this;
    }

    public numeric function getMaxDepth() {
        return variables.config.maxDepth;
    }

    public numeric function getMaxBreadth() {
        return variables.config.maxBreadth;
    }

    public boolean function propertyIsExluded(required struct property) {
        return listFindNoCase(variables.config.excludeProperties, property.name);
    }

    public void function addKey(required string key) {
        variables.componentKeys[key] = hash(key);
    }

    public string function getHash(required string key) {
        return variables.componentKeys[key];
    }

    public boolean function hasKey(required string key) {
        return structKeyExists(variables.componentKeys, key);
    }

}