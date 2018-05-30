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
  var a = { x : 1, dir : { y : 2, z : 3 } };

  test.description = 'trivial';
  test.identical( 1,1 );

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
