# Contributing

All contributors are welcome to this project in the form of feedback, bug reports and even better - pull requests

## Issues

Issues are used to track **bugs** and **feature requests**.

* Before reporting a bug or requesting a feature, run a few searches to
see if a similar issue has already been opened and ensure you’re not submitting
a duplicate.

### Bugs

* Describe steps to reproduce
* Full error message if any
* Your code if relevant

## Pull Request Guidelines

* Open a single PR for each subject.
* Prefer to develop in a topic branch, not master (feature/name)
* Update documentation where applicable.

### Method properties

* Methods not documented and not for the ginal client must be private ie. set invisible.
* Method must be set preemptive if possible.

### Naming rules

* Name of public methods must start with `Mobile App` then category if any (ex: `Action`) and finally a name.
  * This rules could be changed
* Create a folder by category
  * Create a `Compiler_categoryName` inside each folders for compilation declarations

### Only touch relevant files

* Make sure your PR stays focused on a single feature or category.
* Don't change project configs or any files unrelated to the subject you're working.
* Don't reformat code you don't modify.

## Formatting code

* To format code use If you can 4DPop Beautifier macro.
* `folders.json` is not yet version source control compliant.

So sort the key before commit if you want to make minimum diff
```
cat folders.json  | jq --sort-keys . > folders.sorted.json ; rm folders.json; mv folders.sorted.json folders.json
```
You can install jq using homebrew
```
brew install jq
```
