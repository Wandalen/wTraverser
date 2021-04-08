( function _Traverser_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wCloner' );
  _.include( 'wTesting' );

  require( '../l4/Traverser.s' );

}

const _global = _global_;
const _ = _global_.wTools;

// --
// test
// --

function trivial( test )
{

  var a = { x : 1, dir : { y : 2, z : 'x' }, buffer : new F32x([ 1, 2, 3 ]), array : [ 3, 4, 5 ] };

  // onString : null,
  // onRoutine : null,
  // onBuffer : null,
  // onInstanceCopy : null,
  // onContainerUp : null,
  // onContainerDown : null,
  // onEntityUp : null,
  // onEntityDown : null,
  //
  // onMapUp : () => true,
  // onMapElementUp : () => true,
  // onMapElementDown : () => true,
  // onArrayUp : () => true,
  // onBuffer : () => true,

  var onMapUpPaths = [];
  function onMapUp( it )
  {
    onMapUpPaths.push( it.path );
    return it;
  }

  var onMapElementUpPaths = [];
  function onMapElementUp( parent, child )
  {
    onMapElementUpPaths.push( child.path );
    return child;
  }

  var onMapElementDownPaths = [];
  function onMapElementDown( parent, child )
  {
    onMapElementDownPaths.push( child.path );
    return child;
  }

  var onArrayUpPaths = [];
  function onArrayUp( it )
  {
    onArrayUpPaths.push( it.path );
    return it;
  }

  var onBufferPaths = [];
  function onBuffer( src, it )
  {
    onBufferPaths.push( it.path );
    return it;
  }

  var r = _.traverse
  ({
    src : a,
    onBuffer,
    onMapElementUp,
    onMapElementDown,
    onArrayUp,
    onMapUp,
  })
  console.log( r );

  test.identical( onMapUpPaths, [ '/', '/dir' ] );
  test.identical( onMapElementUpPaths, [ '/x', '/dir', '/dir/y', '/dir/z', '/buffer', '/array' ] );
  test.identical( onMapElementDownPaths, [ '/x', '/dir/y', '/dir/z', '/dir', '/buffer', '/array' ] );
  test.identical( onArrayUpPaths, [ '/array' ] );
  test.identical( onBufferPaths, [ '/buffer' ] );

}

//

function traverseMapWithClonerRoutines( test )
{
  var onMapElementUp = ( it, eit ) => eit;
  var onMapUp = _._cloneMapUp;
  var onMapElementDown = _._cloneMapElementDown;

  /* */

  test.case = 'before changes in private routine _cloneMapUp';
  var src =
  {
    map : { y : 2, z : undefined },
    primitive : 'abc',
    notDefined : undefined
  };
  var got = _.traverse({ src, onMapUp, onMapElementUp, onMapElementDown });
  var exp =
  {
    map : { y : 2 },
    primitive : 'abc'
  };
  test.identical( got, exp );
  // var exp =
  // {
  //   'map' : { 'y' : 2, 'z' : undefined },
  //   'primitive' : 'abc',
  //   'notDefined' : undefined
  // };
  // test.identical( got, exp );

  /* */

}

// --
// declare
// --

const Proto =
{

  name : 'Tools.l4.Traverser',
  silencing : 1,

  tests :
  {

    trivial,
    traverseMapWithClonerRoutines,

  },

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )( );
