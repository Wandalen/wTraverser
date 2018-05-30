
if( typeof module !== 'undefined' )
require( '..' );

var _ = wTools;

/**/

var a = { x : 1, dir : { y : 2, z : 3 } };
var r = _.traverse({ src : a })
console.log( r );
