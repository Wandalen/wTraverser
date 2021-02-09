( function _Taverser_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to traverse data structures, no matter how compex and cycled them are.  Traverser may be used to inspect data, make some transformation or duplication. Traverser relies on class relations definition for traversing. Use the module to traverse your data.
  @module Tools/base/Traverser
  @extends Tools
*/

/**
 *  */

/**
 * Collection of cross-platform routines to traverse data structures, no matter how compex and cycled them are.
*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../wtools/Tools.s' );

  _.include( 'wProto' );

}

let Self = _global_.wTools;
let _global = _global_;
let _ = _global_.wTools;

_.assert( _.routineIs( _.workpiece.instanceIsStandard ) );

// --
// routines
// --

var TraverseIterator = Object.create( null );

//

TraverseIterator.iterationClone = function iterationClone()
{
  _.assert( arguments.length === 0, 'Expects no arguments' );
  var newIteration = Object.create( this );
  return newIteration;
}

//

TraverseIterator.iterationNew = function iterationNew( key )
{
  var it = this;
  var iterator = this.iterator;
  var result = Object.create( iterator );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.numberIs( it.copyingDegree ) );

  result.iterationPrev = it;

  if( it !== iterator )
  {
    result.down = it;

    result.path = null;
    result.level = it.level;
    result.copyingDegree = it.copyingDegree;

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
    result.down = null;

    result.level = iterator.level;
    result.copyingDegree = iterator.copyingDegree;

    result.proto = iterator.proto;
    result.dst = iterator.dst;
    result.src = iterator.src;
    result.key = iterator.key;
    result.path = iterator.path ? iterator.path : '/';

    result.customFields = iterator.customFields;
    result.dropFields = iterator.dropFields;
    result.screenFields = iterator.screenFields;
  }

  /* */

  _.assert( _.objectIs( result.iterator ) );

  if( key !== undefined )
  result.select( key );

  return result;
}

//

TraverseIterator.select = function select( key )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( this.path === null );

  this.src = this.iterationPrev.src[ key ];
  this.key = key;
  this.path = this.iterationPrev.path === '/' ? '/' + key : this.iterationPrev.path + '/' + key;

  this.level = this.level+1;

  if( this.copyingDegree === 2 )
  this.copyingDegree -= 1;

  return this;
}

//

function _traverseIterator( o )
{
  var iterator = Object.create( TraverseIterator );

  _.mapExtend( iterator, o );

  iterator.rootSrc = o.rootSrc || o.src;
  iterator.iterator = iterator;

  iterator.onCompactField = iterator.onCompactField || function compact( it, eit )
  {
    if( it.proto && it.proto.compactField )
    {
      return it.proto.compactField.call( it.src, eit );
    }
    else
    {
      if( _.instanceIs( eit.down.src ) )
      if( eit.dst === null || eit.dst === undefined )
      return;
    }
    return eit.dst;
  }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( iterator.level === 0 );
  _.assert( iterator.copyingDegree >= 0 );
  _.assert( iterator.iterator === iterator );
  _.assertRoutineOptions( _traverseIterator, o );

  Object.preventExtensions( iterator );

  return iterator;
}

//

function _traverseIteration( o )
{
  _.assert( _.mapIs( o ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  var iterator = _traverseIterator( o );
  var it = iterator.iterationNew();;

  return it;
}

//

function _traverser( routine, o )
{
  var routine = _traverser;

  _.assert( _.routineIs( routine ) );
  _.assert( _.objectIs( routine.iterationDefaults ) );
  _.assert( !routine.iteratorDefaults );
  _.assert( _.objectIs( routine.defaults ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.routineOptions( routine, o );
  _.assertMapHasNoUndefine( o );
  _.assert( _.objectIs( o ) );

  /* */

  o.iterationDefaults = routine.iterationDefaults;
  o.defaults = routine.defaults;

  o.onMapUp = _.routinesComposeAll( o.onMapUp );
  o.onMapElementUp = _.routinesComposeAll( o.onMapElementUp );
  o.onMapElementDown = _.routinesCompose( o.onMapElementDown );
  o.onArrayUp = _.routinesComposeAll( o.onArrayUp );
  o.onArrayElementUp = _.routinesComposeAll( o.onArrayElementUp );
  o.onArrayElementDown = _.routinesCompose( o.onArrayElementDown );
  o.onBuffer = _.routinesComposeAll( o.onBuffer );

  var it = _traverseIteration( o );

  return it;
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
  compact : 0,

  copyingDegree : 3,

}

_traverser.defaults =
{

  copyingComposes : 3,
  copyingAggregates : 1,
  copyingAssociates : 1,
  copyingMedials : 0,
  // copyingMedialRestricts : 1,
  copyingMedialRestricts : 0,
  copyingRestricts : 0,
  copyingBuffers : 3,
  copyingCustomFields : 0,

  rootSrc : null,
  levels : 999,
  technique : null,
  deserializing : 0,

  onEntityUp : null,
  onEntityDown : null,
  onContainerUp : null,
  onContainerDown : null,

  onHashMap : null,
  onSet : null,
  onDate : null,
  onString : null,
  onRegExp : null,
  onRoutine : null,
  onBuffer : null,
  onInstanceCopy : null,
  onCompactField : null,

  onMapUp : null,
  onMapElementUp : null,
  onMapElementDown : null,
  onArrayUp : null,
  onArrayElementUp : null,
  onArrayElementDown : null,

}

_.mapExtend( _traverser.defaults, _traverser.iterationDefaults );

_traverseIterator.defaults = Object.create( _traverser.defaults );
_traverseIterator.defaults.defaults = null;
_traverseIterator.defaults.iterationDefaults = null;

//

function _traverseEntityUp( it )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( it.onEntityUp )
  {
    var c = it.onEntityUp( it );
    _.assert( c === undefined || c === false );
    if( c === false )
    return false;
  }

  return true;
}

//

function _traverseEntityDown( it )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( it.onEntityDown )
  {
    debugger;
    var c = it.onEntityDown( it );
    _.assert( c === undefined );
  }

}

//

function _traverseMap( it )
{
  var result;

  _.assert( it.copyingDegree >= 1 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectLike( it.src ) || _.workpiece.instanceIsStandard( it.src ) );

  /* */

  if( it.onContainerUp )
  {
    var c0 = it.onContainerUp( it );
    _.assert( c0 === undefined || c0 === false );
    if( c0 === false )
    return it.dst;
  }

  var c1 = it.onMapUp( it );
  _.assert( c1 === false || _.arrayIs( c1 ) || c1 === _.dont );
  if( c1 === false || c1 === _.dont )
  return it.dst;

  /* */

  var screen = it.screenFields ? it.screenFields : it.src;

  if( it.copyingDegree )
  for( var key in screen )
  {

    if( screen[ key ] === undefined )
    continue;

    if( it.src[ key ] === undefined )
    continue;

    if( it.dropFields )
    if( it.dropFields[ key ] !== undefined )
    continue;

    var mapLike_ = _.mapLike_( it.src ) || it.instanceAsMap;
    if( !mapLike_ && !it.screenFields )
    if( !Object.hasOwnProperty.call( it.src, key ) )
    {
      continue;
    }

    var newIteration = it.iterationNew( key );

    // if( _global_.debugger )
    // if( it.path === '/' )
    // debugger;

    let c = it.onMapElementUp( it, newIteration ) ;
    _.assert( c === false || c === _.dont || _.arrayIs( c ) );
    if( c === false || c === _.dont )
    continue;

    _traverseAct( newIteration );

    it.onMapElementDown( it, newIteration );

  }

  /* container down */

  if( it.onContainerDown )
  {
    var c = it.onContainerDown( it );
    _.assert( c === undefined );
  }

  /* */

  return it.dst;
}

//

function _traverseArray( it )
{

  _.assert( it.copyingDegree >= 1 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longIs( it.src ) );
  _.assert( !_.bufferAnyIs( it.src ) );

  /* */

  if( it.onContainerUp )
  {
    var c0 = it.onContainerUp( it );
    _.assert( c0 === undefined || c0 === false );
    if( c0 === false )
    return it.dst;
  }

  var c1 = it.onArrayUp( it );
  _.assert( c1 === false || _.arrayIs( c1 ) );
  if( c1 === false )
  return it.dst;

  /* */

  if( it.copyingDegree > 1 )
  {
    for( var key = 0 ; key < it.src.length ; key++ )
    {
      var newIteration = it.iterationNew( key );

      if( it.onArrayElementUp( it, newIteration ) === false )
      continue;

      _traverseAct( newIteration );

      it.onArrayElementDown( it, newIteration );
    }
  }
  else
  {
    debugger;
  }

  /* container down */

  if( it.onContainerDown )
  {
    var c = it.onContainerDown( it );
    _.assert( c === undefined );
  }

  return it.dst;
}

//

function _traverseBuffer( it )
{
  it.copyingDegree = Math.min( it.copyingBuffers, it.copyingDegree );

  _.assert( it.copyingDegree >= 1, 'not tested' );
  _.assert( !_.bufferNodeIs( it.src ), 'not tested' );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.bufferAnyIs( it.src ) );
  _.assert( it.copyingDegree );

  if( it.onContainerUp )
  {
    var c0 = it.onContainerUp( it );
    _.assert( c0 === undefined || c0 === false );
    if( c0 === false )
    return it.dst;
  }

  /* buffer */

  var c1 = it.onBuffer( it.src, it );
  _.assert( c1 === false || _.arrayIs( c1 ) );
  if( c1 === false )
  return it.dst;

  /* container down */

  if( it.onContainerDown )
  {
    debugger;
    var c = it.onContainerDown( it );
    _.assert( c === undefined );
  }

  return it.dst;
}

//

function _traverseAct( it )
{
  var handled = 0;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( it.level >= 0 );
  _.assert( it.copyingDegree > 0 );
  _.assert( _.objectIs( it.iterator ) );
  _.assert( _.strIs( it.path ) );
  _.assert( !( _.objectLike( it.src ) && _.longIs( it.src ) ) );

  if( !( it.level <= it.iterator.levels ) )
  throw _.err
  (
    'failed to traverse structure', _.strType( it.iterator.rootSrc )
    + '\nat ' + it.path
    + '\ntoo deep structure'
    + '\nrootSrc : ' + _.toStr( it.iterator.rootSrc )
    + '\niteration : ' + _.toStr( it )
    + '\niterator : ' + _.toStr( it.iterator )
  );

  /* */

  if( !_._traverseEntityUp( it ) )
  return it.dst;

  /* class instance */

  if( it.copyingDegree > 1 && it.usingInstanceCopy )
  {

    if( it.onInstanceCopy )
    {
      it.onInstanceCopy( it.src, it );
    }

    if( _.workpiece.instanceLikeStandard( it.dst ) && _.routineIs( it.dst._traverseAct ) )
    {
      it.dst._traverseAct( it );
      return it.dst;
    }
    else if( _.workpiece.instanceLikeStandard( it.src ) && _.routineIs( it.src._traverseAct ) )
    {
      it.src._traverseAct( it );
      return it.dst;
    }

  }

  /* !!! else if required here */

  /* object like */

  if( _.workpiece.instanceIsStandard( it.src ) )
  {
    handled = 1;
    _._traverseMap( it );
  }

  /* object like */

  if( _.objectLike( it.src ) )
  {
    handled = 1;
    _._traverseMap( it );
  }

  /* array like */

  var bufferAnyIs = _.bufferAnyIs( it.src );
  if( _.longIs( it.src ) && !bufferAnyIs )
  {
    handled = 1;
    _._traverseArray( it );
  }

  /* buffer like */

  if( bufferAnyIs )
  {
    handled = 1;
    _._traverseBuffer( it );
  }

  /* routine */

  if( _.routineIs( it.src ) )
  {
    handled = 1;
    if( it.onRoutine )
    it.onRoutine( it.src, it );
  }

  /* string */

  if( _.strIs( it.src ) )
  {
    handled = 1;
    if( it.onString )
    it.onString( it.src, it );
  }

  /* regexp */

  if( _.regexpIs( it.src ) )
  {
    handled = 1;
    if( it.onRegExp )
    it.onRegExp( it.src, it );
  }

  /* date */

  if( _.dateIs( it.src ) )
  {
    handled = 1;
    if( it.onDate )
    it.onDate( it.src, it );
  }

  /* set */

  if( _.setLike( it.src ) )
  {
    handled = 1;
    if( it.onSet )
    it.onSet( it.src, it );
  }

  /* hash map */

  if( _.hashMapLike( it.src ) )
  {
    handled = 1;
    if( it.onHashMap )
    it.onHashMap( it.src, it );
  }

  /* atomic */

  if( _.primitiveIs( it.src ) )
  {
    handled = 1;
  }

  if( it.dst === null )
  it.dst = it.src;

  /* */

  if( !handled && it.copyingDegree > 1 )
  {
    debugger;
    _.assert( 0, 'unknown type of src : ' + _.strType( it.src ) );
  }

  /* */

  _traverseEntityDown( it );

  return it.dst;
}

// --
//
// --

/**
 * @typedef {Object} iterationDefaults
 * @property {Object} src=null
 * @property {Object} dst=null
 * @property {String} key=null
 * @property {Object} proto=null
 * @property {Number} level=0
 * @property {String} path=''
 * @property {Object} customFields=null
 * @property {Object} dropFields=null
 * @property {Object} screenFields=null
 * @property {Boolean} instanceAsMap=0
 * @property {Boolean} usingInstanceCopy=1
 * @property {Boolean} compact=0
 * @property {Number} copyingDegree=3
 * @namespace Tools
 * @module Tools/base/Traverser
 */

/**
 * @typedef {Object} traverseOptions
 * @property {Number} copyingComposes=3
 * @property {Number} copyingAggregates=1
 * @property {Number} copyingAssociates=1
 * @property {Number} copyingMedials=0
 * @property {Number} copyingMedialRestricts=1
 * @property {Number} copyingMedialRestricts=0
 * @property {Number} copyingRestricts=0
 * @property {Number} copyingBuffers=3
 * @property {Number} copyingCustomFields=0

 * @property {Object} rootSrc=null
 * @property {Number} levels=999
 * @property {String} technique=null
 * @property {Boolean} deserializing=0

 * @property {Function} onEntityUp=null
 * @property {Function} onEntityDown=null
 * @property {Function} onContainerUp=null
 * @property {Function} onContainerDown=null

 * @property {Function} onDate=null
 * @property {Function} onRegExp=null
 * @property {Function} onRoutine=null
 * @property {Function} onBuffer=null
 * @property {Function} onInstanceCopy=null
 * @property {Function} onCompactField=null
 *
 * @property {Function} onMapUp=null
 * @property {Function} onMapElementUp=null
 * @property {Function} onMapElementDown=null
 * @property {Function} onArrayUp=null
 * @property {Function} onArrayElementUp=null
 * @property {Function} onArrayElementDown=null
 * @namespace Tools
 * @module Tools/base/Traverser
 */

/**
 * @summary Traverses a complex data structure.
 * @param {Object} o Options map, look {@link module:Tools/base/Traverser.wTools.Traverser~traverseOptions traverseOptions} for details.
 *
 * @example
 * var src = { buffer : new F32x([ 1,2,3 ]) };
 *
 * var onBufferPaths = [];
 * function onBuffer( src,it )
 * {
 *   onBufferPaths.push( it.path );
 *   return it;
 * }
*
 * var r = _.traverse
 * ({
 *   src,
 *   onBuffer,
 * })
 * console.log( onBufferPaths ); //["/buffer"]
 *
 * @returns {Object} Returns modified `o.src` object.
 * @function traverse
 * @namespace Tools
 * @module Tools/base/Traverser
 */

function traverse( o )
{
  var it = _._traverser( traverse, o );
  var result = _._traverseAct( it );
  return result;
}

traverse.defaults = Object.create( _traverser.defaults );

// --
// declare
// --

var Proto =
{

  _traverseIterator,
  _traverseIteration,

  _traverser,
  _traverseEntityUp,
  _traverseEntityDown,

  _traverseMap,
  _traverseArray,
  _traverseBuffer,
  _traverseAct,

  traverse,

}

_.mapExtend( Self, Proto );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
