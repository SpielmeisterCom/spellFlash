package Spielmeister {

	import Spielmeister.Spell.Platform.*

	import flash.display.*


	public class PlatformAdapter implements ModuleDefinition {
		private var platformKit : PlatformKit

		public function PlatformAdapter ( stage : Stage, root : DisplayObject, loaderURL : String ) {
			this.platformKit = new PlatformKit( stage, root, loaderURL )
			this.platformKit.init()
		}

		private function createPlatformKit() : PlatformKit {
			return platformKit
		}

		public function load( define : Function, require : Function ) : void {
			define(
				"spell/client/renderingTestMain",
				[
					"spell/shared/util/EventManager",
					"spell/shared/util/ResourceLoader",
					"spell/shared/util/Logger",
					"spell/shared/util/platform/PlatformKit",
					"spell/shared/util/Events"
				],
				function(
					EventManager,
					ResourceLoader,
					Logger,
					PlatformKit,
					Events
				) {
					"use strict"


					Logger.setLogLevel( Logger.LOG_LEVEL_DEBUG )

					var bufferWidth = 320
					var bufferHeight = 240
					var renderingContexts = []
					var objectCount = 7


					var eventManager = new EventManager()

					var resourceUris = [
						"images/4.2.04_256.png"
					]

					var draw = function( resources ) {
						var image = resources[ "images/4.2.04_256.png" ]

						renderingContexts.push(
							PlatformKit.RenderingFactory.createContext2d(
								bufferWidth,
								bufferHeight,
								"display0",
								PlatformKit.RenderingFactory.BACK_END_DISPLAY_LIST
							)
						)

						for( var i = 0; i < renderingContexts.length; i++ ) {
							var context = renderingContexts[ i ]
							var texture = context.createTexture( image )

							context.setClearColor( [ 0.0, 0.0, 0.0 ] )
							context.clear()

							context.scale( [ 0.66, 0.66, 0 ] )

							for( var j = 0; j < objectCount; j++ ) {
								context.drawTexture( texture, 0, 0 )
								context.translate( [ texture.width, texture.height / 2, 0 ] )
								context.scale( [ 0.5, 0.5, 0 ] )
								context.rotate( 0.15 )

								var opacity = 1.0 - ( j / objectCount )
								context.setGlobalAlpha( opacity )
							}
						}

						Logger.info( "drawing completed" )
					}


					var resourceLoader = new ResourceLoader( eventManager )

					resourceLoader.addResourceBundle( "bundle1", resourceUris )

					eventManager.subscribe(
						[ Events.RESOURCE_PROGRESS, "bundle1" ],
						function( event ) {
							Logger.info( event )
						}
					)

					eventManager.subscribe(
						[ Events.RESOURCE_LOADING_COMPLETED, "bundle1" ],
						function( event ) {
							Logger.info( "loading completed" )
							draw( resourceLoader.getResources() )
						}
					)

					eventManager.subscribe(
						[ Events.RESOURCE_ERROR, "bundle1" ],
						function( event ) {
							Logger.info( "Error while loading '" + event + "'." )
						}
					)

					resourceLoader.start()
				}
			)

			define(
				"spell/shared/util/platform/private/functions",
				function() : Underscore {
					return new Underscore()
				}
			)

			define(
				"spell/shared/util/platform/private/initDebugEnvironment",
				function() : Function {
					return function() : void {}
				}
			)

			define(
				"spell/shared/util/platform/PlatformKit",
				createPlatformKit
			)

			define(
				"spell/shared/util/platform/Types",
				function() : Types {
					return new Types()
				}
			)

			define(
				"spell/shared/util/platform/log",
				function() : Function {
					return function( message : String ) : void {
						var now : Date = new Date()
						var formattedMessage : String = "[" + now.toDateString() + " " + now.toLocaleTimeString() + "] " +  message

						trace( formattedMessage )
					}
				}
			)

			define(
				'spell/client/renderingCoordinateTestMain',
				[
					'spell/shared/util/ConfigurationManager',
					'spell/shared/util/EventManager',
					'spell/shared/util/ResourceLoader',
					'spell/shared/util/Events',
					'spell/shared/util/Logger',
					'spell/shared/util/platform/PlatformKit',

					'glmatrix/mat4'
				],
				function(
					ConfigurationManager,
					EventManager,
					ResourceLoader,
					Events,
					Logger,
					PlatformKit,

					mat4
				) {
					'use strict'


					Logger.setLogLevel( Logger.LOG_LEVEL_DEBUG )
					Logger.debug( 'mark1' )


					var bufferWidth          = 320
					var bufferHeight         = 240

					var soundManager         = {}
					var eventManager         = new EventManager()
					var configurationManager = new ConfigurationManager( eventManager )
					var resourceLoader       = new ResourceLoader( soundManager, eventManager, configurationManager.resourceServer )

					var resourceUris = [
						'images/4.2.04_256.png'
					]

					var texture = undefined

					var context = PlatformKit.RenderingFactory.createContext2d(
						eventManager,
						bufferWidth,
						bufferHeight,
						PlatformKit.RenderingFactory.BACK_END_DISPLAY_LIST,
						'display0'
					)

					var drawTestPattern1 = function( x, y, width, height ) {
						var halfWidth = width / 2,
							halfHeight = height / 2

						context.save()
						{
							context.setFillStyleColor( [ 1.0, 0.0, 0.2 ] )
							context.fillRect( x, y + halfHeight, halfWidth, halfHeight )

							context.setFillStyleColor( [ 0.8, 0.0, 0.8 ] )
							context.fillRect( x + halfWidth, y, halfWidth, halfHeight )

							context.setFillStyleColor( [ 0.5, 0.72, 0.61 ] )
							context.fillRect( x + halfWidth * 1.5, y, halfWidth / 2, halfHeight / 2 )

			//				context.setFillStyleColor( [ 0.0, 0.0, 0.82 ] )
			//				context.fillRect( x, y, width, height )
						}
						context.restore()
					}

					var drawTestPattern2 = function( x, y, width, height ) {
//						context.drawTexture( texture, x, y, width, height )
						context.drawSubTexture( texture, 64, 64, 128, 128, x, y, width, height )
					}

					var createMatrix = function() {
						var matrix = mat4.create()
						mat4.identity( matrix )

						return matrix
					}


					/**
					 * Setting up the transformation related components
					 */

					// matrices
					var worldToView = createMatrix()

					// view coordinates to normalized device coordinates
					var aspectRatio  = bufferWidth / bufferHeight,
						cameraWidth  = 3,
						cameraHeight = cameraWidth / aspectRatio

					mat4.ortho(
						-cameraWidth / 2,
						cameraWidth / 2,
						-cameraHeight / 2,
						cameraHeight / 2,
						0,
						1000,
						worldToView
					)

					mat4.translate( worldToView, [ 0, 0, 0 ] ) // camera is located at (0/0/0); WATCH OUT: apply inverse translation


					var drawScreenCoordinates = function() {
						context.setClearColor( [ 0.0, 0.0, 0.0 ] )
						context.clear()

						drawTestPattern1( 0, 0, bufferWidth, bufferHeight )
			//			drawTestPattern2( 0, 0, bufferWidth, bufferHeight )
					}

					var drawViewCoordinates = function() {
						context.setClearColor( [ 0.0, 0.0, 0.0 ] )
						context.clear()

						context.setViewMatrix( worldToView )

						drawTestPattern1( 0, 0, 1, 1 )
			//			drawTestPattern2( 0, 0, 1, 1 )
					}

					var drawWorldCoordinates = function() {
						context.setClearColor( [ 0.0, 0.0, 0.0 ] )
						context.clear()

						context.setViewMatrix( worldToView )

						// object to world space transformation go here - object is located at (-1|-1) in world space
						context.translate( [ -1.0, -1.0, 0 ] )

						drawTestPattern1( 0, 0, 1, 1 )
			//			drawTestPattern2( 0, 0, 1, 1 )
					}

					var drawModelCoordinates = function() {
						context.setClearColor( [ 0.0, 0.0, 0.0 ] )
						context.clear()

						context.setViewMatrix( worldToView )

						// object to world space transformation go here - object is located at (-1|-1) in world space
						context.translate( [ -1.0, -1.0, 0 ] )

						// "appearance" transformations go here - pattern is rotated in object space
						context.rotate( Math.PI / 30 )

			//			drawTestPattern1( 0, 0, 1, 1 )
						drawTestPattern2( 0, 0, 1, 1 )
					}


					var runTest = function() {
						/**
						 * The expected result in all test cases is that the color buffer is covered completely with the test pattern.
						 *
						 * http://www.songho.ca/opengl/gl_transform.html
						 */

			//			drawScreenCoordinates()

			//			drawViewCoordinates()

			//			drawWorldCoordinates()

						drawModelCoordinates()
					}

					eventManager.subscribe(
						[ Events.RESOURCE_LOADING_COMPLETED, 'bundle1' ],
						function( event ) {
							Logger.info( 'loading completed' )

							texture = context.createTexture( resourceLoader.getResources()[ resourceUris[ 0 ] ] )

							Logger.info( 'running test' )
							runTest()
						}
					)

					resourceLoader.addResourceBundle( "bundle1", resourceUris )
					resourceLoader.start()
				}
			)
		}
	}
}
