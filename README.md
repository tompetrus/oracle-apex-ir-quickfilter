# IR Quick Filter All Columns

Plugin Details:
- Name: IR Quick Filter All Columns
- Code: PLUGINS.DYNAMICACTIONS.IRQFCOLUMNS
- Version: v2.0
- Apex compatibility: 5

When using the column dropdown next to the search-input on an interactive report, by default only the currently displayed columns are available. This plugin hacks into the interactive report JavaScript to hijack the calls to retrieve the columns, and instead returns all the columns available to the user - in other words, the columns available in the "select columns" action.

## To use:

1. install the plugin in the shared components of your application
2. create a dynamic action on the page of type "Page Load"
3. as a true action, select the "ir Quick Filter" action, found under "Initialize"
4. in apex 5, then select the affected region. You can create multiple true actions for different regions (ir's), so multiple IR's are supported.

## To ensure compatibility with version 1.0: 
You can install this new version and it will 'upgrade' (overwrite) the version 1.0 plugin. Meaning that dynamic actions which have been using this plugin are also upgraded. Ideally you may want to go over them and assign a region to each true action. I added in the region affected element in order to let you deal with multiple IR's on one page (an apex 5 improvement).   
If you do not do this, there are two possibilities: 

1. some fallback code has been added to deal with non-region-assigned actions and will look for ir regions. These regions are retrieved by selecting elements with class `t-IRR-region`. If none are found, nothing happens. 
2. no ir regions can be found as a fallback, nothing happens.

Enabling debug will also put out debug lines in the browser's developer tools console. If you're encountering errors or nothing occurs and you can't tell why, try enabling debug.

## Changes over v1:

- javascript code has been moved to a javascript file. The function is put on the `apex.custom.plugin` namespace (the custom namespace is added on by me and is no official namespace. I create it to group together custom apex JS functionality...). 
- javascript had to be completely redone to deal with IR javascript rewrite
- column retrieval now uses `apex_json` and uses a ref cursor instead of `apex_util.json_from_sql`. That means a big improvement as the sql shared pool will no longer get flooded with similar yet different statements (ir id was appended to sql instead of being a variable)
- **hidden columns are no longer retrieved**. This was removed because it was weird. Hidden columns are explicitly meant to not be shown on the front end and can in no way be manipulated by users.

## Note
I'd like to point out once more that this is a hack on the javascript of the IR. That being said, nothing is altered with regards to sql or backend or anysomesuch. The only affected part is the column dropdown when the plugin is used. Every other part is untouched by the plugin, and no further "messing" with IR javascript is done. The applying of the filters and such is, for example, regular functionality. Every effort is made to keep things as standard as possible, where possible, with regards to this additional functionality.
