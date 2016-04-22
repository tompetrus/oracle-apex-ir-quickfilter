Name: IR Quick Filter All Columns
Code: PLUGINS.DYNAMICACTIONS.IRQFCOLUMNS
Version: v1.0
Apex compatibility: 4.1, 4.2

When using the column dropdown next to the search-input on an interactive report, by default only the currently displayed columns are available. This plugin hacks into the interactive report JavaScript to hijack the calls to retrieve the columns, and instead returns all the columns available to the user - in other words, the columns available in the "select columns" action.

To use:
1) install the plugin in the shared components of your application
2) create a dynamic action on the page of type "Page Load"
3) as a true action, select the "ir Quick Filter" action, found under "Initialize"

Info can be found here: http://tpetrus.blogspot.co.uk/2012/08/interactive-report-quick-filter-show.html