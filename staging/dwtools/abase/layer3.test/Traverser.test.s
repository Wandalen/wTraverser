( function _Traverser_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wTesting' );

  require( '../layer3/bTraverser.s' );

}

var _ = _global_.wTools;

// --
// test
// --

function trivial( test )
{

  var a = { x : 1, dir : { y : 2, z : 'x' }, buffer : new Float32Array([ 1,2,3 ]), array : [ 3,4,5 ] };

  // onString : null,
  // onRoutine : null,
  // onBuffer : null,
  // onInstanceCopy : null,
  // onContainerUp : null,
  // onContainerDown : null,
  // onElementUp : null,
  // onElementDown : null,
//
  // onMapUp : () => true,
  // onMapEntryUp : () => true,
  // onMapEntryDown : () => true,
  // onArrayUp : () => true,
  // onBufferUp : () => true,

  var onMapUpPaths = [];
  function onMapUp( iteration )
  {
    onMapUpPaths.push( iteration.path );
  }

  var onMapEntryUpPaths = [];
  function onMapEntryUp( parent,child )
  {
    onMapEntryUpPaths.push( child.path );
  }

  var onMapEntryDownPaths = [];
  function onMapEntryDown( parent,child )
  {
    onMapEntryDownPaths.push( child.path );
  }

  var onArrayUpPaths = [];
  function onArrayUp( iteration )
  {
    onArrayUpPaths.push( iteration.path );
  }

  var onBufferUpPaths = [];
  function onBufferUp( iteration )
  {
    onBufferUpPaths.push( iteration.path );
  }

  var r = _.traverse
  ({
    src : a,
    onMapEntryUp : onMapEntryUp,
    onMapEntryDown : onMapEntryDown,
    onArrayUp : onArrayUp,
    onBufferUp : onBufferUp,
    onMapUp : onMapUp,
  })
  console.log( r );

  test.identical( onMapUpPaths,[ '/','/dir' ] );
  test.identical( onMapEntryUpPaths,[ '/x', '/dir', '/dir/y', '/dir/z', '/buffer', '/array' ] );
  test.identical( onMapEntryDownPaths,[ '/x', '/dir/y', '/dir/z', '/dir', '/buffer', '/array' ] );
  test.identical( onArrayUpPaths,[ '/array' ] );
  test.identical( onBufferUpPaths,[ '/buffer' ] );

}

// --
// proto
// --

var Self =
{

  name : 'Traverser',
  silencing : 1,

  tests :
  {

    trivial : trivial,

  },

}

//

Self = wTestSuit( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
