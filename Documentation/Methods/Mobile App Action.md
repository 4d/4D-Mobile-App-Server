<!-- $action:=Mobile App Action($1) with $1 Informations provided by mobile application in `On Mobile App Action` -->
# Mobile App Action

Utility methods to get `dataClass` or `entity` to apply action when inside `On Mobile App Action` database method.

## Usage

in `On Mobile App Action` wrap the first input parameters

```4d
$action:=Mobile App Action($1) // $1 Informations provided by mobile application
```

Then you can switch as usual on action name and use of the function

```4d
Case of
        //________________________________________
    : ($action.name="purgeAll") // Purge all, action scope is table/dataclass

        $dataClass:=$action.getDataClass()
        // Insert here the code to purge all entities of this dataClass.

        //________________________________________
    : ($action.name="add") // Add a new entitys

        $book:=$action.newEntity()
        $status:=$book.save()
        //________________________________________
    : ($action.name="rate") // Rate a book, action scope is entity

        $book:=$action.getEntity()
        // Insert here the code for the action "Rate and Review" the book

End case
```

### all scope

#### getDataClass()

This return the `dataClass`  associated to the action.

```4d
$dataClass:=$action.getDataClass()
```

#### newEntity()

Create a new instance of entity associated to the action data class; same as  `getDataClass().new()`

```4d
$aNewEntity:=$action.newEntity()
```

### current record scope

#### getEntity()

Get the entity associated to the action.

```4d
$entityToApplyAction:=$action.getEntity()
```

> This return Null if the action scope is not "current record" 

#### dropEntity()

Drop the entity associated to the action; same as  `getEntity().drop()`

```4d
$status:=$action.dropEntity()
```

### work with relations

When navigating in mobile application you need some information about context.

For instance you are on one parent record/entity of type "company" and then you display the company "employee" list. You need to know the parent "company" to add or remove an "employee" from this list.

#### getParent()

You can get the parent entity associated to the action.

 ```4d
$parentEntity:=$action.getParent()
```

#### unlink()

You can unlink on entity from its parent.

 ```4d
$operationResult:=$action.unlink()                    
$status:=$operationResult.save() // to save record
```
