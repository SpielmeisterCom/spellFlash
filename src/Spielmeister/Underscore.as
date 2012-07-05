package Spielmeister {

	import flash.utils.getQualifiedClassName

	public class Underscore {
		public function Underscore() {
		}

		public function isArray( collection : * ) : Boolean {
			return getQualifiedClassName( collection ) == 'Array'
		}

		public function isObject( object : * ) : Boolean {
			var className = getQualifiedClassName( object )

			return className == 'Object' ||
				className == 'Array'
		}

		public function size( collection : * ) : int {
			return toArray( collection ).length
		}

		public function toArray( collection : * ) : Array {
			if( isArray( collection ) ) return collection.slice()


			var result : Array = new Array()

			for each( var value : * in collection ) {
				result.push( value )
			}


			return result
		}

		public function each( collection : *, iterator : Function, context : * = null ) : void {
			for( var i in collection ) {
				iterator.apply( context, [ collection[ i ], i, collection ] )
			}
		}

		public function map( collection : *, iterator : Function, context : * = null ) : Array {
			var result : Array = toArray( collection )

			for( var i in result ) {
				result[ i ] = iterator.apply( context, [ result[ i ], i, result ] )
			}

			return result
		}

		public function last( collection : *, count : int = 1 ) : Object {
			var tmp : Array = toArray( collection )

			return ( count == 1 ? tmp[ tmp.length - 1 ] : tmp.slice( tmp.length - count, tmp.length ) )
		}

		public function filter( collection : *, iterator : Function, context : * = null ) : Array {
			return toArray( collection ).filter.call( context, iterator )
		}

		public function has( object : Object, key : String ) : Boolean {
			return object.hasOwnProperty( key )
		}

		public function any( collection : *, iterator : Function, context : * = null ) : Boolean {
			for( var key : String in collection ) {
				var value : Object = collection[ key ]
				if( iterator.call( context, value, key ) ) return true
			}

			return false
		}

		public function find( collection : *, iterator : Function, context : * = null ) : Object {
			var result : Object

			any(
				collection,
				function( value : Object, key : String ) : Boolean {
					if( iterator.call( context, value, key ) ) {
						result = value

						return true
					}

					return false
				}
			)

			return result
		}

		public function times( n : int, iterator : Function, context : * = null ) : void {
			while( n > 0 ) {
				iterator.call( context )
				n--
			}
		}

		public function extend( destination : Object, ... sources ) : Object {
			for each( var source : Object in sources ) {
				for( var property : String in source ) {
					destination[ property ] = source[ property ]
				}
			}

			return destination
		}

		public function all( collection : *, iterator : Function, context : * = null ) : Boolean {
			for each( var value : Object in collection ) {
				if( !iterator.call( context, value ) ) {
					return false
				}
			}

			return true
		}

		public function range( ... arguments ) : Array {
			if( arguments.length === 0 ) return []

			var start : int,
				stop : int,
				step : int = 1

			if( arguments.length == 1 ) {
				start = 0
				stop  = arguments[ 0 ]

			} else if( arguments.length >= 2 ) {
				start = arguments[ 0 ]
				stop  = arguments[ 1 ]

				if( arguments.length == 3 ) {
					step = arguments[ 2 ]
				}
			}

			var length : int = Math.max( Math.ceil ( ( stop - start ) / step ), 0 )
			var i : int = 0
			var range : Array = new Array( length )

			while( i < length ) {
				range[ i++ ] = start
				start += step
			}

			return range
		}

		public function reduce( collection : Object, iterator : Function, memo : * = undefined, context : * = null ) : * {
			for( var i in collection ) {
				memo = iterator.call( context, memo, collection[ i ], i, collection )
			}

			return memo
		}

		public function bind( func : Function, context : * = null, ... arguments1 ) {
			return function( ... arguments2 ) : * {
				return func.apply( context, arguments1.concat( arguments2 ) )
			}
		}

		public function reject( collection : *, iterator : Function, context : * = null ) : Array {
			return toArray( collection ).filter.call(
				context,
				function( item : *, index : int, array : Array ) : Boolean {
					return !iterator.call( context, item )
				}
			)
		}

		public function clone( object : Object ) : Object {
			if( !isObject( object ) ) return object
			return isArray( object ) ? object.slice() : extend( {}, object )
		}

		public function defaults( object : Object, ... arguments ) : Object {
			for each( var otherObject : Object in arguments ) {
				for( var propertyName in otherObject ) {
					if( object[ propertyName ] == undefined ) object[ propertyName ] = otherObject[ propertyName ]
				}
			}

			return object
		}

		public function indexOf( array : Array, item : Object, isSorted : Boolean = false ) : int {
			return array.indexOf( item )
		}

		public function isString( object : Object ) : Object {
			return getQualifiedClassName( object ) === 'String'
		}

		public function isEmpty( object : Object ) : Boolean {
			if( isArray( object ) ||
				isString( object ) ) {

				return object.length === 0
			}

			for( var key in object ) {
				if( has( object, key ) ) return false
			}

			return true
		}

		public function keys( object : Object ) : Array {
			var keys : Array = []
			for( var key in object ) {
				if( has( object, key ) ) keys[ keys.length ] = key
			}

			return keys
		}

		public function isFunction( object : Object ) : Boolean {
			return getQualifiedClassName( object ) === 'Function'
		}

		public function after( times : int, callback : Function ) : Object {
			if( times <= 0 ) return callback()

			return function() : Object {
				if( --times < 1 ) {
					return callback.apply( this, arguments )
				}

				return undefined
			}
		}

		public function contains( collection : *, target : String ) : Boolean {
			if( collection === null ) return false

			if( isArray( collection ) ) {
				return collection.indexOf( target ) !== -1
			}

			for each( var value : Object in collection ) {
				if( value === target ) return true
			}

			return false
		}

		public function invoke( collection : *, method : *, ... args ) : * {
			return map(
				collection,
				function( value ) {
					return ( isFunction( method ) ? method || value : value[ method ] ).apply( value, args )
				}
			)
		}

		public function flatten( collection : Array, shallow : Boolean = false ) : Array {
			return reduce(
				collection,
				function( memo, value ) {
					return memo.concat(
						( isArray( value ) ?
							( shallow ?
								value :
								flatten( value ) ) :
							value )
					)
				},
				[]
			)
		}

		public function pick( object : Object, ... args ) : Object {
			return reduce(
				flatten( args ),
				function( memo, key ) {
					if( key in object ) memo[ key ] = object[ key ]

					return memo
				},
				{}
			)
		}

		public function unique( collection : Array, isSorted : Boolean = false, ... args ) : Array {
			var iterator = args[ 0 ]

			var initial : Object = iterator ? map( collection, iterator ) : collection
			var results : Array = []

			if( collection.length < 3 ) isSorted = true

			reduce(
				initial,
				function( memo, value, index ) {
					if( isSorted ? last( memo ) !== value || !memo.length : contains( memo, value ) ) {
						memo.push( value )
						results.push( collection[ index ] )
					}
					return memo
				},
				[]
			)

			return results
		}

		public function union() : Object {
			return unique( flatten( arguments, true ) )
		}

		public function difference( collection : Array, ... args ) : Array{
			var rest : Array = flatten( args, true )

			return filter(
				collection,
				function( value : String ) {
					return !contains( rest, value )
				}
			)
		}

		public function values( object : Object ) : Array {
			var result : Array = []

			for each( var value : Object in object ) {
				result.push( value )
			}

			return result
		}

		public function initial( collection : Array, n : Number = 0, guard : * = false ) : Array {
			return collection.slice(
				0,
				collection.length - ( ( ( n === 0 ) || guard ) ? 1 : n )
			)
		}

		public function pluck( object : Object, key : String ) : Array {
			return map(
				object,
				function( value ) {
					return value[ key ]
				}
			)
		}

		public function zip( ... args ) : Array {
			var length : Number = 0

			for each( var arg : Object in args ) {
				var argLength : Number = arg.length
				if( length < argLength ) length = argLength
			}

			var results : Array = new Array( length )

			for( var i : Number = 0; i < length; i++ ) {
				results[ i ] = pluck( args, "" + i )
			}

			return results
		}



		public function runTests() : void {
			trace( 'testing...' )

			var start : int  = 0
			var end : int    = 0
			var length : int = 10

			var collectionArray : Array = new Array( length )
			var collectionObject : Object = {}

			for( var i : int = 0; i < length; i++ ) {
				collectionArray[ i ] = i + "_"
				collectionObject[ i ] = collectionArray[ i ]
			}

			var tmp


			/**
			 * isArray
			 */
			if( !isArray( collectionArray ) ) {
				trace( 'Error: isArray( collectionArray ) is false')
			}

			if( isArray( collectionObject ) ) {
				trace( 'Error: isArray( collectionObject ) is true')
			}


			/**
			 * toArray
			 */
			tmp = toArray( collectionArray )
			if( !isArray( tmp ) ||
				tmp.length != collectionArray.length ) {

				trace( 'Error: toArray( collectionArray ) failed')
			}

			tmp = toArray( collectionObject )
			if( !isArray( tmp ) ||
				tmp.length != collectionArray.length ) {

				trace( 'Error: toArray( collectionObject ) failed')
			}


			/**
			 * each
			 */
			each(
				collectionArray,
				function( iter ) {
//					trace( iter )
				}
			)


			/**
			 * map
			 */
			tmp = map(
				collectionArray,
				function( iter, key, list ) {
					return iter * 2
				}
			)


			/**
			 * size
			 */
			if( size( collectionArray ) != collectionArray.length ) {
				trace( 'Error: size( collectionArray ) failed')
			}


			/**
			 * last
			 */
			tmp = last( collectionArray )
			if( tmp !== collectionArray[ collectionArray.length - 1 ] ) {
				trace( 'Error: last( collectionArray ) failed')
			}


			/**
			 * filter
			 */
			tmp = filter(
				collectionArray,
				function( iter ) {
					return ( iter % 2 == 0 )
				}
			)


			/**
			 * has
			 */
			if( !has( collectionObject, '0' ) ) {
				trace( 'Error: has( collectionObject, \'0\' ) failed')
			}


			/**
			 * some
			 */
			tmp = any(
				collectionArray,
				function( iter ) {
					return iter == collectionArray[ Math.floor( collectionArray.length / 2 ) ]
				}
			)

			if( !tmp ) {
				trace( 'Error: any( collectionArray, f() ) failed')
			}


			/**
			 * find
			 */
			tmp = find(
				collectionArray,
				function( item ) {
					return item == 100
				}
			)


			/**
			 * times
			 */
			times(
				3,
				function() : void {
//					trace( 'x' )
				}
			)


			/**
			 * extend
			 */
			tmp = extend(
				{
					a: "test"
				},
				{
					b: "foo"
				},
				{
					a: "test2"
				}
			)


			/**
			 * all
			 */
			tmp = all(
				collectionArray,
				function( iter ) {
					return iter.charAt( iter.length - 1 ) == '_'
				}
			)

			if( !tmp ) {
				trace( 'Error: all( collectionArray, f() ) failed')
			}


			/**
			 * range
			 */
			tmp = range()
			tmp = range( 0 )
			tmp = range( 5 )
			tmp = range( 5, 10 )
			tmp = range( 5, 10, 2 )


			/**
			 * reduce
			 */
			tmp = reduce(
				[ 1, 2, 3 ],
				function( memo, value ) {
					memo.count++
					memo.sum = memo.sum + value

					return memo
				},
				{
					count : 0,
					sum   : 0
				}
			)


			/**
			 * bind
			 */
			var f = function( x, y ) {
				trace( 'arguments.length: ' + arguments.length )

				trace( 'x: ' + x )
				trace( 'y: ' + y )
			}

//			var F = bind( f, null, 'test' )
//			F( 123 )


			trace( 'done' )
		}
	}
}
