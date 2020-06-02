# Dev

Class of tools to provide methods for the development phase.

## Usage

Load the tools methods:

```4d
$o:=MobileAppServer .Dev.new()
```

### Use Dev class to update the server structure
### `updateStructure()`

This method perform, on the server side, the structure adjustments for an optimised mobile data update. It will be especially useful if you create your mobile application from a local database copy and then you want to connect it to your production server.

Pass as parameter a table name or a collection of table names according to your project definition and the method perform the structure adjustments.

```4d
$o:=MobileAppServer .Dev.new()
$result:=$o.updateStructure("Table_1")
```

or

```4d
$o:=MobileAppServer .Dev.new()
$result:=$o.updateStructure(New collection("Table_1";"Table_2";...;"table_N"))
```

The returned object `$result` contains a boolean property `success` to check if the process has been successfully executed. If so, the `log` property gives, as a collection, the list of actions performed and the results. Otherwise, the `errors` property lists the errors encountered.

Be careful, the table names are case sensitive


