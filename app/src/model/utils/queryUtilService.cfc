component{
    
    //from https://www.bennadel.com/blog/124-ask-ben-converting-a-query-to-an-array.htm
    public array function queryToArray(required query data) {

        //preserve the original column case, with .columnList it uCases the column names
        var columns = [];
        var meta = getMetaData(data);
        for (var col in meta) {
            columns.append(col.name);
        }

        var queryArray = [];
        
        for (var rowIndex = 1 ; rowIndex <= arguments.data.recordCount; rowIndex+= 1) {
            var row = {};
            for (var columnIndex = 1; columnIndex <= columns.len(); columnIndex += 1) {
                var columnName = columns[ columnIndex ];
                row[columnName] = arguments.data[columnName][rowIndex];
            }
            queryArray.append(row);
        }
        return( queryArray );
    }
}