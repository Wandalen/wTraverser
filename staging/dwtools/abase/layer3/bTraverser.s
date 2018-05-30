( function _Taverser_s_() {

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

}

var Self = _global_.wTools;
var _ = _global_.wTools;

// --
// routines
// --

var TraverseIterator = Object.create( null );

TraverseIterator.iterationClone = function iterationClone()
{
  _.assert( arguments.length === 0 );
  var newIteration = Object.create( this );
  return newIteration;
}

TraverseIterator.iterationNew = function iterationNew( key )
{
  var result;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  result = _traverseIterationInit( this,this.iterator );

  if( key !== undefined )
  result.select( key );

  return result;
}

TraverseIterator.select = function select( key )
{
  _.assert( arguments.length === 1 );
  _.assert( this.path === null );

  this.src = this.iterationPrev.src[ key ];
  this.key = key;
  this.path = this.iterationPrev.path + '.' + key;

  this.level = this.level+1;

  if( this.copyingDegree === 2 )
  this.copyingDegree -= 1;

  return this;
}

//

function _traverseIterator( o )
{
  var iterator = Object.create( TraverseIterator );

  _.mapExtend( iterator,o );

  iterator.rootSrc = o.rootSrc || o.src;
  iterator.iterator = iterator;

  _.assert( arguments.length === 1 );
  _.assert( iterator.level === 0 );
  _.assert( iterator.copyingDegree >= 0 );
  _.assert( iterator.iterator === iterator );

  Object.preventExtensions( iterator );

  return iterator;
}

//

function _traverseIterationInit( iteration,iterator )
{
  var result = Object.create( iterator );

  _.assert( arguments.length === 2 );
  _.assert( !iteration || _.numberIs( iteration.copyingDegree ) );

  result.iterationPrev = iteration;

  if( iteration !== iterator )
  {
    result.path = null;
    result.level = iteration.level;
    result.copyingDegree = iteration.copyingDegree;

    result.proto = null;
    result.dst = null;
    result.src = null;
    result.key = null;

    result.customFields = null;
    result.dropFields = null;
    result.screenFields = null;
  }
  else
  {
    result.path = '/';
    result.level = iterator.level;
    result.copyingDegree = iterator.copyingDegree;

    result.proto = iterator.proto;
    result.dst = iterator.dst;
    result.src = iterator.src;
    result.key = iterator.key;
    result.path = iterator.path;

    result.customFields = iterator.customFields;
    result.dropFields = iterator.dropFields;
    result.screenFields = iterator.screenFields;
  }

  /* */

  _.assert( result.iterator );

  return result;
}

//

function _traverseIteration( o )
{
  _.assert( _.mapIs( o ) );
  _.assert( arguments.length === 1 );

  var iterator = _traverseIterator( o );
  var iteration = iterator.iterationNew();;

  return iteration;
}

//

function _traverser( routine,o )
{
  // var routine = routine || _traverser;
  var routine = _traverser;

  // if( o.copyingMedials === undefined )
  // o.copyingMedials = _.instanceIsStandard( o.src ) ? 0 : 1;

  _.assert( _.routineIs( routine ) );
  _.assert( routine.iterationDefaults );
  _.assert( !routine.iteratorDefaults );
  _.assert( routine.defaults );
  _.assert( arguments.length === 2 );
  _.routineOptions( routine,o );
  _.assertMapHasNoUndefine( o );
  _.assert( _.objectIs( o ) );

  /* */

  o.iterationDefaults = routine.iterationDefaults;
  o.defaults = routine.defaults;

  var iteration = _traverseIteration( o );
  return iteration;
}

_traverser.iterationDefaults =
{

  src : null,
  key : null,
  dst : null,
  proto : null,
  level : 0,
  path : '',
  customFields : null,
  dropFields : null,
  screenFields : null,
  instanceAsMap : 0,
  usingInstanceCopy : 1,

  copyingDegree : 3,

}

_traverser._defaults =
{

  copyingComposes : 3,
  copyingAggregates : 1,
  copyingAssociates : 1,
  copyingMedials : 0,
  copyingMedialRestricts : 1,
  copyingRestricts : 0,
  copyingBuffers : 3,
  copyingCustomFields : 0,

  rootSrc : null,
  levels : 999,
  technique : null,
  deserializing : 0,

  onString : null,
  onRoutine : null,
  onBuffer : null,
  onInstanceCopy : null,
  onContainerUp : null,
  onContainerDown : null,
  onElementUp : null,
  onElementDown : null,

}

_traverser.defaults =
{

  onMapUp : null,
  onMapEntryUp : null,
  onMapEntryDown : null,
  onArrayUp : null,
  onBufferUp : null,

}

_.mapExtend( _traverser._defaults, _traverser.iterationDefaults );
_.mapExtend( _traverser.defaults, _traverser._defaults );

//

function _traverseHandleElementUp( iteration,iterator )
{

  if( iteration.onElementUp )
  {
    var r = iteration.onElementUp( iteration.src,iteration,iterator );
    _.assert( r === undefined || r === false );
    if( r === false )
    return false;
  }

  return true;
}

//

function _traverseHandleElementDown( iteration,iterator )
{

  if( iteration.onElementDown )
  {
    var r = iteration.onElementDown( iteration.dst,iteration,iterator );
    _.assert( r === undefined || r === false );
    if( r === false )
    return false;
  }

  return true;
}

//

function _traverseMap( iteration,iterator )
{
  var result;

  _.assert( iteration.copyingDegree >= 1 );
  _.assert( arguments.length === 2 );
  _.assert( _.objectLike( iteration.src ) );

  /* */

  if( iterator.onContainerUp )
  {
    var r = iterator.onContainerUp( iteration,iterator );
    _.assert( r === undefined || r === false );
    if( r === false )
    return iteration.dst;
  }

  var c = iteration.onMapUp( iteration );
  if( c === false )
  return iteration.dst;

  /* */

  var screen = iteration.screenFields ? iteration.screenFields : iteration.src;

  if( iteration.copyingDegree )
  for( var key in screen )
  {

    if( screen[ key ] === undefined )
    continue;

    if( iteration.src[ key ] === undefined )
    continue;

    if( iteration.dropFields )
    if( iteration.dropFields[ key ] !== undefined )
    continue;

    var mapLike = _.mapLike( iteration.src ) || iteration.instanceAsMap;
    if( !mapLike && !iteration.screenFields )
    if( !Object.hasOwnProperty.call( iteration.src,key ) )
    {
      debugger;
      continue;
    }

    if( key === 'providersWithProtocolMap' )
    {
      debugger;xxx;
    }

    var newIteration = iteration.iterationNew( key );

    iteration.onMapEntryUp( iteration,newIteration );

    _traverseAct( newIteration,iterator );

    iteration.onMapEntryDown( iteration,newIteration );

  }

  /* container down */

  if( iterator.onContainerDown )
  {
    var r = iterator.onContainerDown( iteration,iterator );
    _.assert( r === undefined );
  }

  /* */

  return iteration.dst;
}

//

function _traverseArray( iteration,iterator )
{

  _.assert( iteration.copyingDegree >= 1 );
  _.assert( arguments.length === 2 );
  _.assert( _.arrayLike( iteration.src ) );
  _.assert( !_.bufferAnyIs( iteration.src ) );

  /* */

  if( iterator.onContainerUp )
  {
    var r = iterator.onContainerUp( iteration,iterator );
    _.assert( r === undefined || r === false );
    if( r === false )
    return iteration.dst;
  }

  var c = iteration.onArrayUp( iteration );
  if( c === false )
  return iteration.dst;

  if( iteration.copyingDegree )
  for( var key = 0 ; key < iteration.src.length ; key++ )
  {
    var newIteration = iteration.iterationNew( key );
    iteration.dst[ key ] = _traverseAct( newIteration,iterator );
  }

  /* container down */

  if( iterator.onContainerDown )
  {
    var r = iterator.onContainerDown( iteration,iterator );
    _.assert( r === undefined );
  }

  return iteration.dst;
}

//

function _traverseBuffer( iteration,iterator )
{
  iteration.copyingDegree = Math.min( iterator.copyingBuffers,iteration.copyingDegree );

  _.assert( iteration.copyingDegree >= 1,'not tested' );
  _.assert( !_.bufferNodeIs( iteration.src ),'not tested' );
  _.assert( arguments.length === 2 );
  _.assert( _.bufferAnyIs( iteration.src ) );

  if( !iteration.copyingDegree )
  debugger;

  if( !iteration.copyingDegree )
  return;

  if( iterator.onContainerUp )
  {
    var r = iterator.onContainerUp( iteration,iterator );
    _.assert( r === undefined || r === false );
    if( r === false )
    return iteration.dst;
  }

  /* buffer */

  var c = iteration.onBufferUp( iteration );
  if( c === false )
  return iteration.dst;

  /* */

  if( iterator.onBuffer )
  {
    var r = iterator.onBuffer( iteration.dst,iteration,iterator );
    _.assert( r === undefined );
  }

  /* container down */

  if( iterator.onContainerDown )
  {
    debugger;
    var r = iterator.onContainerDown( iteration,iterator );
    _.assert( r === undefined );
  }

  return iteration.dst;
}

//

function _traverseAct( iteration,iterator )
{
  var handled = 0;

  _.assert( arguments.length === 2 );
  _.assert( iteration.level >= 0 );
  _.assert( iteration.copyingDegree > 0 );
  _.assert( _.strIs( iteration.path ) );
  _.assert( !( _.objectLike( iteration.src ) && _.arrayLike( iteration.src ) ) );

  // iteration.level += 1;

  if( !( iteration.level <= iterator.levels ) )
  throw _.err
  (
    'failed to traverse structure',_.strTypeOf( iterator.rootSrc ) +
    '\nat ' + iteration.path +
    '\ntoo deep structure' +
    '\nrootSrc : ' + _.toStr( iterator.rootSrc ) +
    '\niteration : ' + _.toStr( iteration ) +
    '\niterator : ' + _.toStr( iterator )
  );

  /* */

  if( !_._traverseHandleElementUp( iteration,iterator ) )
  return iteration.dst;

  /* class instance */

  if( iteration.copyingDegree > 1 && iteration.usingInstanceCopy )
  {

    if( iteration.onInstanceCopy )
    {
      iteration.onInstanceCopy( iteration,iterator );
    }

    if( iteration.dst && iteration.dst._traverseAct )
    {
      iteration.dst._traverseAct( iteration,iterator );
      return iteration.dst;
    }
    else if( iteration.src && iteration.src._traverseAct )
    {
      iteration.src._traverseAct( iteration,iterator );
      return iteration.dst;
    }

  }

  /* object like */

  if( _.objectLike( iteration.src ) )
  {
    handled = 1;
    _._traverseMap( iteration,iterator );
  }

  /* array like */

  var bufferTypedIs = _.bufferAnyIs( iteration.src );
  if( _.arrayLike( iteration.src ) && !bufferTypedIs )
  {
    handled = 1;
    _._traverseArray( iteration,iterator );
  }

  /* buffer like */

  if( bufferTypedIs )
  {
    handled = 1;
    _._traverseBuffer( iteration,iterator );
  }

  if( iteration.dst === null )
  iteration.dst = iteration.src;

  /* routine */

  if( _.routineIs( iteration.src ) )
  {
    handled = 1;
    if( iterator.onRoutine )
    debugger;
    if( iterator.onRoutine )
    iterator.onRoutine( iteration.src,iteration,iterator );
  }

  /* string */

  if( _.strIs( iteration.src ) )
  {
    handled = 1;
    if( iterator.onString )
    iterator.onString( iteration.src,iteration,iterator );
  }

  /* atomic */

  if( _.atomicIs( iteration.src ) )
  {
    handled = 1;
  }

  /* */

  if( !_traverseHandleElementDown( iteration,iterator ) )
  return iteration.dst;

  /* */

  if( !handled && iteration.copyingDegree > 1 )
  {
    debugger;
    throw _.err( 'unknown type of src : ' + _.strTypeOf( iteration.src ) );
  }

  return iteration.dst;
}

// --
//
// --

function traverse( o )
{
  var iteration = _._traverser( traverse,o );
  _._traverseAct( iteration,itrator );
  return result;
}

traverse.defaults =
{
}

traverse.defaults.__proto__ = _traverser.defaults;

// --
// prototype
// --

var Proto =
{

  _traverseIterator : _traverseIterator,
  _traverseIteration : _traverseIteration,
  _traverser : _traverser,

  _traverseHandleElementUp : _traverseHandleElementUp,
  _traverseHandleElementDown : _traverseHandleElementDown,

  _traverseMap : _traverseMap,
  _traverseArray : _traverseArray,
  _traverseBuffer : _traverseBuffer,
  _traverseAct : _traverseAct,

  traverse : traverse,

}

_.mapExtend( Self, Proto );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_._UsingWtoolsPrivately_ )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
