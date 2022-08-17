<!-- Type your summary here -->
# WebContext

You could get the context from [WebHandler](WebHandler.md)

```4d
$context:=$handler.getContext()
```

and then get the dataClass

```4d
$dataClass:=$context.getDataClass()
```

or the entity if any

```4d
$entity:=$context.getEntity()
```
