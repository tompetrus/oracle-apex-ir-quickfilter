if ( !apex.custom ) { apex.custom = {}; };
if ( !apex.custom.plugin ) { apex.custom.plugin = {}; };

apex.custom.plugin.irQuickFilter =
function(pElements, pAjaxIdentifier){
  //change column dropdown for one IR region
  function changeIrColumnDrop(pRegionId){
    apex.debug("PLUGIN-QF ... static id: " + pRegionId);
    var region$ = apex.jQuery("#"+pRegionId),
        ir$ = apex.jQuery("#"+pRegionId+"_ir"),
        drop$ = apex.jQuery("#"+pRegionId+"_column_search_drop");
        
    apex.debug("PLUGIN-QF ... IR region: ", ir$);
    region$.on("apexafterrefresh", function(){
      apex.debug("PLUGIN-QF ... After report refresh - reinitializing IR quick filter on ", pRegionId);
      var x = ir$.data("apex-interactiveReport");
      drop$.menu("destroy");
      drop$.menu( {
        asyncFetchMenu: function(menu, callback) {
          x.searchMenu = menu;
          x.searchMenuCallback = callback;
          x._dialogReset();
          x.currentAction = "CONTROL";
          x.currentControl= "SEARCH_COLUMN"

          apex.debug("PLUGIN-QF ... start fetch of menu items...");
          apex.server.plugin(pAjaxIdentifier
          , {x01: x.worksheetId}
          , { dataType: "text"
            , success: function(pData){ 
                apex.debug("PLUGIN-QF ... Successfull fetch of items, parse them (internal)");
                x._columnSearchShow.call(x, pData);
              } 
            , complete: function(){
                if ( x.searchMenuCallback ){
                  apex.debug("PLUGIN-QF ... Callback failed");
                  x.searchMenuCallback(false);
                  x.searchMenuCallback = null;
                  x.searchMenu = null;  
                };
              }
            }
          );
        },
        afterClose: function( event, data ) {
          if ( data.actionTaken ) { 
              setTimeout(function() {
                  x._getElement( "search_field" ).focus();
              }, 100);
          }
        },
        items: []
      });
    });
    region$.trigger("apexafterrefresh");
  };
  //main code
  apex.debug("PLUGIN-QF ... affectedElements: ", pElements);
  //if no affected element has been specified apex passes along the document node
  if ( pElements[0].nodeName === "#document" ) {
    apex.debug("PLUGIN-QF ... no affectedElement was assigned. Attempting to retrieve all IR regions by class - assuming Universal Theme!");
    apex.jQuery(".t-IRR-region").each(function(){
      changeIrColumnDrop(this.id);
    });
  } else {
    changeIrColumnDrop(pElements[0].id);
  };
};