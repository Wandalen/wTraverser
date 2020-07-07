
if( typeof module !== 'undefined' )
require( 'wtraverser' );
var _ = wTools;

/**/

function onMapEntryUp( map, entry )
{
  console.log( entry.path );
}

var a = { x : 1, dir : { y : 2, z : 3 } };
var r = _.traverse({ src : a, onMapEntryUp : onMapEntryUp })
