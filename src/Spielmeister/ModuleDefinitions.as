package Spielmeister {

	import Spielmeister.Spell.Platform.*

	import flash.display.*
	import mx.core.IChildList


	public class ModuleDefinitions {

		private var platformKit : PlatformKit
		private var define      : Function
		private var require     : Function


		public function ModuleDefinitions( stage: Stage, root : DisplayObject, container : IChildList, loaderURL : String, urlParameters : Object, define : Function, require : Function ) {
			this.platformKit = new PlatformKit( stage, root, container, loaderURL, urlParameters )
			this.platformKit.init()

			this.define = define
			this.require = require
		}


		private function createPlatformKit() : PlatformKit {
			return platformKit
		}


		public function loadModuleDefinitions() : void {
			loadModuleDefinitionsJavascript()
			loadModuleDefinitionsActionscript()
		}


		// definitions of modules written in Actionscript go here
		private function loadModuleDefinitionsActionscript() : void {
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
				"underscore",
				function() : Underscore {
					return new Underscore()
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
				"glmatrix/glmatrix",
				[
					"spell/shared/util/platform/Types"
				],
				function(
					Types
				) {
					/**
					 * @fileOverview gl-matrix - High performance matrix and vector operations for WebGL
					 * @author Brandon Jones
					 * @version 1.2.3
					 */

					/*
					 * Copyright (c) 2011 Brandon Jones
					 *
					 * This software is provided 'as-is', without any express or implied
					 * warranty. In no event will the authors be held liable for any damages
					 * arising from the use of this software.
					 *
					 * Permission is granted to anyone to use this software for any purpose,
					 * including commercial applications, and to alter it and redistribute it
					 * freely, subject to the following restrictions:
					 *
					 *    1. The origin of this software must not be misrepresented; you must not
					 *    claim that you wrote the original software. If you use this software
					 *    in a product, an acknowledgment in the product documentation would be
					 *    appreciated but is not required.
					 *
					 *    2. Altered source versions must be plainly marked as such, and must not
					 *    be misrepresented as being the original software.
					 *
					 *    3. This notice may not be removed or altered from any source
					 *    distribution.
					 */

					"use strict";

					// Type declarations
					// account for CommonJS environments

					/**
					 * @class 3 Dimensional Vector
					 * @name vec3
					 */
					var vec3 = {};

					/**
					 * @class 3x3 Matrix
					 * @name mat3
					 */
					var mat3 = {};

					/**
					 * @class 4x4 Matrix
					 * @name mat4
					 */
					var mat4 = {};

					/**
					 * @class Quaternion
					 * @name quat4
					 */
					var quat4 = {};


					var createArray = Types.createNativeFloatArray;


					/*
					 * vec3
					 */

					/**
					 * Creates a new instance of a vec3 using the default array type
					 * Any javascript array-like objects containing at least 3 numeric elements can serve as a vec3
					 *
					 * @param {vec3} [vec] vec3 containing values to initialize with
					 *
					 * @returns {vec3} New vec3
					 */
					vec3.create = function (vec) {
						var dest = createArray(3);

						if (vec) {
							dest[0] = vec[0];
							dest[1] = vec[1];
							dest[2] = vec[2];
						} else {
							dest[0] = dest[1] = dest[2] = 0;
						}

						return dest;
					};

					/**
					 * Copies the values of one vec3 to another
					 *
					 * @param {vec3} vec vec3 containing values to copy
					 * @param {vec3} dest vec3 receiving copied values
					 *
					 * @returns {vec3} dest
					 */
					vec3.set = function (vec, dest) {
						dest[0] = vec[0];
						dest[1] = vec[1];
						dest[2] = vec[2];

						return dest;
					};

					/**
					 * Performs a vector addition
					 *
					 * @param {vec3} vec First operand
					 * @param {vec3} vec2 Second operand
					 * @param {vec3} [dest] vec3 receiving operation result. If not specified result is written to vec
					 *
					 * @returns {vec3} dest if specified, vec otherwise
					 */
					vec3.add = function (vec, vec2, dest) {
						if (!dest || vec === dest) {
							vec[0] += vec2[0];
							vec[1] += vec2[1];
							vec[2] += vec2[2];
							return vec;
						}

						dest[0] = vec[0] + vec2[0];
						dest[1] = vec[1] + vec2[1];
						dest[2] = vec[2] + vec2[2];
						return dest;
					};

					/**
					 * Performs a vector subtraction
					 *
					 * @param {vec3} vec First operand
					 * @param {vec3} vec2 Second operand
					 * @param {vec3} [dest] vec3 receiving operation result. If not specified result is written to vec
					 *
					 * @returns {vec3} dest if specified, vec otherwise
					 */
					vec3.subtract = function (vec, vec2, dest) {
						if (!dest || vec === dest) {
							vec[0] -= vec2[0];
							vec[1] -= vec2[1];
							vec[2] -= vec2[2];
							return vec;
						}

						dest[0] = vec[0] - vec2[0];
						dest[1] = vec[1] - vec2[1];
						dest[2] = vec[2] - vec2[2];
						return dest;
					};

					/**
					 * Performs a vector multiplication
					 *
					 * @param {vec3} vec First operand
					 * @param {vec3} vec2 Second operand
					 * @param {vec3} [dest] vec3 receiving operation result. If not specified result is written to vec
					 *
					 * @returns {vec3} dest if specified, vec otherwise
					 */
					vec3.multiply = function (vec, vec2, dest) {
						if (!dest || vec === dest) {
							vec[0] *= vec2[0];
							vec[1] *= vec2[1];
							vec[2] *= vec2[2];
							return vec;
						}

						dest[0] = vec[0] * vec2[0];
						dest[1] = vec[1] * vec2[1];
						dest[2] = vec[2] * vec2[2];
						return dest;
					};

					/**
					 * Negates the components of a vec3
					 *
					 * @param {vec3} vec vec3 to negate
					 * @param {vec3} [dest] vec3 receiving operation result. If not specified result is written to vec
					 *
					 * @returns {vec3} dest if specified, vec otherwise
					 */
					vec3.negate = function (vec, dest) {
						if (!dest) { dest = vec; }

						dest[0] = -vec[0];
						dest[1] = -vec[1];
						dest[2] = -vec[2];
						return dest;
					};

					/**
					 * Multiplies the components of a vec3 by a scalar value
					 *
					 * @param {vec3} vec vec3 to scale
					 * @param {number} val Value to scale by
					 * @param {vec3} [dest] vec3 receiving operation result. If not specified result is written to vec
					 *
					 * @returns {vec3} dest if specified, vec otherwise
					 */
					vec3.scale = function (vec, val, dest) {
						if (!dest || vec === dest) {
							vec[0] *= val;
							vec[1] *= val;
							vec[2] *= val;
							return vec;
						}

						dest[0] = vec[0] * val;
						dest[1] = vec[1] * val;
						dest[2] = vec[2] * val;
						return dest;
					};

					/**
					 * Generates a unit vector of the same direction as the provided vec3
					 * If vector length is 0, returns [0, 0, 0]
					 *
					 * @param {vec3} vec vec3 to normalize
					 * @param {vec3} [dest] vec3 receiving operation result. If not specified result is written to vec
					 *
					 * @returns {vec3} dest if specified, vec otherwise
					 */
					vec3.normalize = function (vec, dest) {
						if (!dest) { dest = vec; }

						var x = vec[0], y = vec[1], z = vec[2],
							len = Math.sqrt(x * x + y * y + z * z);

						if (!len) {
							dest[0] = 0;
							dest[1] = 0;
							dest[2] = 0;
							return dest;
						} else if (len === 1) {
							dest[0] = x;
							dest[1] = y;
							dest[2] = z;
							return dest;
						}

						len = 1 / len;
						dest[0] = x * len;
						dest[1] = y * len;
						dest[2] = z * len;
						return dest;
					};

					/**
					 * Generates the cross product of two vec3s
					 *
					 * @param {vec3} vec First operand
					 * @param {vec3} vec2 Second operand
					 * @param {vec3} [dest] vec3 receiving operation result. If not specified result is written to vec
					 *
					 * @returns {vec3} dest if specified, vec otherwise
					 */
					vec3.cross = function (vec, vec2, dest) {
						if (!dest) { dest = vec; }

						var x = vec[0], y = vec[1], z = vec[2],
							x2 = vec2[0], y2 = vec2[1], z2 = vec2[2];

						dest[0] = y * z2 - z * y2;
						dest[1] = z * x2 - x * z2;
						dest[2] = x * y2 - y * x2;
						return dest;
					};

					/**
					 * Caclulates the length of a vec3
					 *
					 * @param {vec3} vec vec3 to calculate length of
					 *
					 * @returns {number} Length of vec
					 */
					vec3.length = function (vec) {
						var x = vec[0], y = vec[1], z = vec[2];
						return Math.sqrt(x * x + y * y + z * z);
					};

					/**
					 * Caclulates the dot product of two vec3s
					 *
					 * @param {vec3} vec First operand
					 * @param {vec3} vec2 Second operand
					 *
					 * @returns {number} Dot product of vec and vec2
					 */
					vec3.dot = function (vec, vec2) {
						return vec[0] * vec2[0] + vec[1] * vec2[1] + vec[2] * vec2[2];
					};

					/**
					 * Generates a unit vector pointing from one vector to another
					 *
					 * @param {vec3} vec Origin vec3
					 * @param {vec3} vec2 vec3 to point to
					 * @param {vec3} [dest] vec3 receiving operation result. If not specified result is written to vec
					 *
					 * @returns {vec3} dest if specified, vec otherwise
					 */
					vec3.direction = function (vec, vec2, dest) {
						if (!dest) { dest = vec; }

						var x = vec[0] - vec2[0],
							y = vec[1] - vec2[1],
							z = vec[2] - vec2[2],
							len = Math.sqrt(x * x + y * y + z * z);

						if (!len) {
							dest[0] = 0;
							dest[1] = 0;
							dest[2] = 0;
							return dest;
						}

						len = 1 / len;
						dest[0] = x * len;
						dest[1] = y * len;
						dest[2] = z * len;
						return dest;
					};

					/**
					 * Performs a linear interpolation between two vec3
					 *
					 * @param {vec3} vec First vector
					 * @param {vec3} vec2 Second vector
					 * @param {number} lerp Interpolation amount between the two inputs
					 * @param {vec3} [dest] vec3 receiving operation result. If not specified result is written to vec
					 *
					 * @returns {vec3} dest if specified, vec otherwise
					 */
					vec3.lerp = function (vec, vec2, lerp, dest) {
						if (!dest) { dest = vec; }

						dest[0] = vec[0] + lerp * (vec2[0] - vec[0]);
						dest[1] = vec[1] + lerp * (vec2[1] - vec[1]);
						dest[2] = vec[2] + lerp * (vec2[2] - vec[2]);

						return dest;
					};

					/**
					 * Calculates the euclidian distance between two vec3
					 *
					 * Params:
					 * @param {vec3} vec First vector
					 * @param {vec3} vec2 Second vector
					 *
					 * @returns {number} Distance between vec and vec2
					 */
					vec3.dist = function (vec, vec2) {
						var x = vec2[0] - vec[0],
							y = vec2[1] - vec[1],
							z = vec2[2] - vec[2];

						return Math.sqrt(x*x + y*y + z*z);
					};

					/**
					 * Projects the specified vec3 from screen space into object space
					 * Based on the <a href="http://webcvs.freedesktop.org/mesa/Mesa/src/glu/mesa/project.c?revision=1.4&view=markup">Mesa gluUnProject implementation</a>
					 *
					 * @param {vec3} vec Screen-space vector to project
					 * @param {mat4} view View matrix
					 * @param {mat4} proj Projection matrix
					 * @param {vec4} viewport Viewport as given to gl.viewport [x, y, width, height]
					 * @param {vec3} [dest] vec3 receiving unprojected result. If not specified result is written to vec
					 *
					 * @returns {vec3} dest if specified, vec otherwise
					 */
					vec3.unproject = function (vec, view, proj, viewport, dest) {
						if (!dest) { dest = vec; }

						var m = mat4.create();
						var v = createArray(4);

						v[0] = (vec[0] - viewport[0]) * 2.0 / viewport[2] - 1.0;
						v[1] = (vec[1] - viewport[1]) * 2.0 / viewport[3] - 1.0;
						v[2] = 2.0 * vec[2] - 1.0;
						v[3] = 1.0;

						mat4.multiply(proj, view, m);
						if(!mat4.inverse(m)) { return null; }

						mat4.multiplyVec4(m, v);
						if(v[3] === 0.0) { return null; }

						dest[0] = v[0] / v[3];
						dest[1] = v[1] / v[3];
						dest[2] = v[2] / v[3];

						return dest;
					};

					/**
					 * Returns a string representation of a vector
					 *
					 * @param {vec3} vec Vector to represent as a string
					 *
					 * @returns {string} String representation of vec
					 */
					vec3.str = function (vec) {
						return '[' + vec[0] + ', ' + vec[1] + ', ' + vec[2] + ']';
					};

					/*
					 * vec3.reflect
					 * Reflects a vector on a normal
					 *
					 * Params:
					 * vec - vec3, vector to reflect
					 * normal - vec3, the normal to reflect by
					 *
					 * Returns:
					 * vec
					 */
					vec3.reflect = function(vec, normal) {
						var tmp = vec3.create(normal);
						vec3.normalize(tmp);
						var normal_dot_vec = vec3.dot(tmp, vec);
						vec3.scale(tmp, -2 * normal_dot_vec);
						vec3.add(vec, tmp);

						return vec;
					};

					vec3.reset = function(vec) {
						vec[0] = vec[1] = vec[2] = 0
					}

					/*
					 * mat3
					 */

					/**
					 * Creates a new instance of a mat3 using the default array type
					 * Any javascript array-like object containing at least 9 numeric elements can serve as a mat3
					 *
					 * @param {mat3} [mat] mat3 containing values to initialize with
					 *
					 * @returns {mat3} New mat3
					 */
					mat3.create = function (mat) {
						var dest = createArray(9);

						if (mat) {
							dest[0] = mat[0];
							dest[1] = mat[1];
							dest[2] = mat[2];
							dest[3] = mat[3];
							dest[4] = mat[4];
							dest[5] = mat[5];
							dest[6] = mat[6];
							dest[7] = mat[7];
							dest[8] = mat[8];
						}

						return dest;
					};

					/**
					 * Copies the values of one mat3 to another
					 *
					 * @param {mat3} mat mat3 containing values to copy
					 * @param {mat3} dest mat3 receiving copied values
					 *
					 * @returns {mat3} dest
					 */
					mat3.set = function (mat, dest) {
						dest[0] = mat[0];
						dest[1] = mat[1];
						dest[2] = mat[2];
						dest[3] = mat[3];
						dest[4] = mat[4];
						dest[5] = mat[5];
						dest[6] = mat[6];
						dest[7] = mat[7];
						dest[8] = mat[8];
						return dest;
					};

					/**
					 * Sets a mat3 to an identity matrix
					 *
					 * @param {mat3} dest mat3 to set
					 *
					 * @returns dest if specified, otherwise a new mat3
					 */
					mat3.identity = function (dest) {
						if (!dest) { dest = mat3.create(); }
						dest[0] = 1;
						dest[1] = 0;
						dest[2] = 0;
						dest[3] = 0;
						dest[4] = 1;
						dest[5] = 0;
						dest[6] = 0;
						dest[7] = 0;
						dest[8] = 1;
						return dest;
					};

					/**
					 * Transposes a mat3 (flips the values over the diagonal)
					 *
					 * Params:
					 * @param {mat3} mat mat3 to transpose
					 * @param {mat3} [dest] mat3 receiving transposed values. If not specified result is written to mat
					 *
					 * @returns {mat3} dest is specified, mat otherwise
					 */
					mat3.transpose = function (mat, dest) {
						// If we are transposing ourselves we can skip a few steps but have to cache some values
						if (!dest || mat === dest) {
							var a01 = mat[1], a02 = mat[2],
								a12 = mat[5];

							mat[1] = mat[3];
							mat[2] = mat[6];
							mat[3] = a01;
							mat[5] = mat[7];
							mat[6] = a02;
							mat[7] = a12;
							return mat;
						}

						dest[0] = mat[0];
						dest[1] = mat[3];
						dest[2] = mat[6];
						dest[3] = mat[1];
						dest[4] = mat[4];
						dest[5] = mat[7];
						dest[6] = mat[2];
						dest[7] = mat[5];
						dest[8] = mat[8];
						return dest;
					};

					/**
					 * Copies the elements of a mat3 into the upper 3x3 elements of a mat4
					 *
					 * @param {mat3} mat mat3 containing values to copy
					 * @param {mat4} [dest] mat4 receiving copied values
					 *
					 * @returns {mat4} dest if specified, a new mat4 otherwise
					 */
					mat3.toMat4 = function (mat, dest) {
						if (!dest) { dest = mat4.create(); }

						dest[15] = 1;
						dest[14] = 0;
						dest[13] = 0;
						dest[12] = 0;

						dest[11] = 0;
						dest[10] = mat[8];
						dest[9] = mat[7];
						dest[8] = mat[6];

						dest[7] = 0;
						dest[6] = mat[5];
						dest[5] = mat[4];
						dest[4] = mat[3];

						dest[3] = 0;
						dest[2] = mat[2];
						dest[1] = mat[1];
						dest[0] = mat[0];

						return dest;
					};

					/**
					 * Returns a string representation of a mat3
					 *
					 * @param {mat3} mat mat3 to represent as a string
					 *
					 * @param {string} String representation of mat
					 */
					mat3.str = function (mat) {
						return '[' + mat[0] + ', ' + mat[1] + ', ' + mat[2] +
							', ' + mat[3] + ', ' + mat[4] + ', ' + mat[5] +
							', ' + mat[6] + ', ' + mat[7] + ', ' + mat[8] + ']';
					};

					/*
					 * mat4
					 */

					/**
					 * Creates a new instance of a mat4 using the default array type
					 * Any javascript array-like object containing at least 16 numeric elements can serve as a mat4
					 *
					 * @param {mat4} [mat] mat4 containing values to initialize with
					 *
					 * @returns {mat4} New mat4
					 */
					mat4.create = function (mat) {
						var dest = createArray(16);

						if (mat) {
							dest[0] = mat[0];
							dest[1] = mat[1];
							dest[2] = mat[2];
							dest[3] = mat[3];
							dest[4] = mat[4];
							dest[5] = mat[5];
							dest[6] = mat[6];
							dest[7] = mat[7];
							dest[8] = mat[8];
							dest[9] = mat[9];
							dest[10] = mat[10];
							dest[11] = mat[11];
							dest[12] = mat[12];
							dest[13] = mat[13];
							dest[14] = mat[14];
							dest[15] = mat[15];
						}

						return dest;
					};

					/**
					 * Copies the values of one mat4 to another
					 *
					 * @param {mat4} mat mat4 containing values to copy
					 * @param {mat4} dest mat4 receiving copied values
					 *
					 * @returns {mat4} dest
					 */
					mat4.set = function (mat, dest) {
						dest[0] = mat[0];
						dest[1] = mat[1];
						dest[2] = mat[2];
						dest[3] = mat[3];
						dest[4] = mat[4];
						dest[5] = mat[5];
						dest[6] = mat[6];
						dest[7] = mat[7];
						dest[8] = mat[8];
						dest[9] = mat[9];
						dest[10] = mat[10];
						dest[11] = mat[11];
						dest[12] = mat[12];
						dest[13] = mat[13];
						dest[14] = mat[14];
						dest[15] = mat[15];
						return dest;
					};

					/**
					 * Sets a mat4 to an identity matrix
					 *
					 * @param {mat4} dest mat4 to set
					 *
					 * @returns {mat4} dest
					 */
					mat4.identity = function (dest) {
						if (!dest) { dest = mat4.create(); }
						dest[0] = 1;
						dest[1] = 0;
						dest[2] = 0;
						dest[3] = 0;
						dest[4] = 0;
						dest[5] = 1;
						dest[6] = 0;
						dest[7] = 0;
						dest[8] = 0;
						dest[9] = 0;
						dest[10] = 1;
						dest[11] = 0;
						dest[12] = 0;
						dest[13] = 0;
						dest[14] = 0;
						dest[15] = 1;
						return dest;
					};

					/**
					 * Transposes a mat4 (flips the values over the diagonal)
					 *
					 * @param {mat4} mat mat4 to transpose
					 * @param {mat4} [dest] mat4 receiving transposed values. If not specified result is written to mat
					 *
					 * @param {mat4} dest is specified, mat otherwise
					 */
					mat4.transpose = function (mat, dest) {
						// If we are transposing ourselves we can skip a few steps but have to cache some values
						if (!dest || mat === dest) {
							var a01 = mat[1], a02 = mat[2], a03 = mat[3],
								a12 = mat[6], a13 = mat[7],
								a23 = mat[11];

							mat[1] = mat[4];
							mat[2] = mat[8];
							mat[3] = mat[12];
							mat[4] = a01;
							mat[6] = mat[9];
							mat[7] = mat[13];
							mat[8] = a02;
							mat[9] = a12;
							mat[11] = mat[14];
							mat[12] = a03;
							mat[13] = a13;
							mat[14] = a23;
							return mat;
						}

						dest[0] = mat[0];
						dest[1] = mat[4];
						dest[2] = mat[8];
						dest[3] = mat[12];
						dest[4] = mat[1];
						dest[5] = mat[5];
						dest[6] = mat[9];
						dest[7] = mat[13];
						dest[8] = mat[2];
						dest[9] = mat[6];
						dest[10] = mat[10];
						dest[11] = mat[14];
						dest[12] = mat[3];
						dest[13] = mat[7];
						dest[14] = mat[11];
						dest[15] = mat[15];
						return dest;
					};

					/**
					 * Calculates the determinant of a mat4
					 *
					 * @param {mat4} mat mat4 to calculate determinant of
					 *
					 * @returns {number} determinant of mat
					 */
					mat4.determinant = function (mat) {
						// Cache the matrix values (makes for huge speed increases!)
						var a00 = mat[0], a01 = mat[1], a02 = mat[2], a03 = mat[3],
							a10 = mat[4], a11 = mat[5], a12 = mat[6], a13 = mat[7],
							a20 = mat[8], a21 = mat[9], a22 = mat[10], a23 = mat[11],
							a30 = mat[12], a31 = mat[13], a32 = mat[14], a33 = mat[15];

						return (a30 * a21 * a12 * a03 - a20 * a31 * a12 * a03 - a30 * a11 * a22 * a03 + a10 * a31 * a22 * a03 +
								a20 * a11 * a32 * a03 - a10 * a21 * a32 * a03 - a30 * a21 * a02 * a13 + a20 * a31 * a02 * a13 +
								a30 * a01 * a22 * a13 - a00 * a31 * a22 * a13 - a20 * a01 * a32 * a13 + a00 * a21 * a32 * a13 +
								a30 * a11 * a02 * a23 - a10 * a31 * a02 * a23 - a30 * a01 * a12 * a23 + a00 * a31 * a12 * a23 +
								a10 * a01 * a32 * a23 - a00 * a11 * a32 * a23 - a20 * a11 * a02 * a33 + a10 * a21 * a02 * a33 +
								a20 * a01 * a12 * a33 - a00 * a21 * a12 * a33 - a10 * a01 * a22 * a33 + a00 * a11 * a22 * a33);
					};

					/**
					 * Calculates the inverse matrix of a mat4
					 *
					 * @param {mat4} mat mat4 to calculate inverse of
					 * @param {mat4} [dest] mat4 receiving inverse matrix. If not specified result is written to mat
					 *
					 * @param {mat4} dest is specified, mat otherwise, null if matrix cannot be inverted
					 */
					mat4.inverse = function (mat, dest) {
						if (!dest) { dest = mat; }

						// Cache the matrix values (makes for huge speed increases!)
						var a00 = mat[0], a01 = mat[1], a02 = mat[2], a03 = mat[3],
							a10 = mat[4], a11 = mat[5], a12 = mat[6], a13 = mat[7],
							a20 = mat[8], a21 = mat[9], a22 = mat[10], a23 = mat[11],
							a30 = mat[12], a31 = mat[13], a32 = mat[14], a33 = mat[15],

							b00 = a00 * a11 - a01 * a10,
							b01 = a00 * a12 - a02 * a10,
							b02 = a00 * a13 - a03 * a10,
							b03 = a01 * a12 - a02 * a11,
							b04 = a01 * a13 - a03 * a11,
							b05 = a02 * a13 - a03 * a12,
							b06 = a20 * a31 - a21 * a30,
							b07 = a20 * a32 - a22 * a30,
							b08 = a20 * a33 - a23 * a30,
							b09 = a21 * a32 - a22 * a31,
							b10 = a21 * a33 - a23 * a31,
							b11 = a22 * a33 - a23 * a32,

							d = (b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06),
							invDet;

							// Calculate the determinant
							if (!d) { return null; }
							invDet = 1 / d;

						dest[0] = (a11 * b11 - a12 * b10 + a13 * b09) * invDet;
						dest[1] = (-a01 * b11 + a02 * b10 - a03 * b09) * invDet;
						dest[2] = (a31 * b05 - a32 * b04 + a33 * b03) * invDet;
						dest[3] = (-a21 * b05 + a22 * b04 - a23 * b03) * invDet;
						dest[4] = (-a10 * b11 + a12 * b08 - a13 * b07) * invDet;
						dest[5] = (a00 * b11 - a02 * b08 + a03 * b07) * invDet;
						dest[6] = (-a30 * b05 + a32 * b02 - a33 * b01) * invDet;
						dest[7] = (a20 * b05 - a22 * b02 + a23 * b01) * invDet;
						dest[8] = (a10 * b10 - a11 * b08 + a13 * b06) * invDet;
						dest[9] = (-a00 * b10 + a01 * b08 - a03 * b06) * invDet;
						dest[10] = (a30 * b04 - a31 * b02 + a33 * b00) * invDet;
						dest[11] = (-a20 * b04 + a21 * b02 - a23 * b00) * invDet;
						dest[12] = (-a10 * b09 + a11 * b07 - a12 * b06) * invDet;
						dest[13] = (a00 * b09 - a01 * b07 + a02 * b06) * invDet;
						dest[14] = (-a30 * b03 + a31 * b01 - a32 * b00) * invDet;
						dest[15] = (a20 * b03 - a21 * b01 + a22 * b00) * invDet;

						return dest;
					};

					/**
					 * Copies the upper 3x3 elements of a mat4 into another mat4
					 *
					 * @param {mat4} mat mat4 containing values to copy
					 * @param {mat4} [dest] mat4 receiving copied values
					 *
					 * @returns {mat4} dest is specified, a new mat4 otherwise
					 */
					mat4.toRotationMat = function (mat, dest) {
						if (!dest) { dest = mat4.create(); }

						dest[0] = mat[0];
						dest[1] = mat[1];
						dest[2] = mat[2];
						dest[3] = mat[3];
						dest[4] = mat[4];
						dest[5] = mat[5];
						dest[6] = mat[6];
						dest[7] = mat[7];
						dest[8] = mat[8];
						dest[9] = mat[9];
						dest[10] = mat[10];
						dest[11] = mat[11];
						dest[12] = 0;
						dest[13] = 0;
						dest[14] = 0;
						dest[15] = 1;

						return dest;
					};

					/**
					 * Copies the upper 3x3 elements of a mat4 into a mat3
					 *
					 * @param {mat4} mat mat4 containing values to copy
					 * @param {mat3} [dest] mat3 receiving copied values
					 *
					 * @returns {mat3} dest is specified, a new mat3 otherwise
					 */
					mat4.toMat3 = function (mat, dest) {
						if (!dest) { dest = mat3.create(); }

						dest[0] = mat[0];
						dest[1] = mat[1];
						dest[2] = mat[2];
						dest[3] = mat[4];
						dest[4] = mat[5];
						dest[5] = mat[6];
						dest[6] = mat[8];
						dest[7] = mat[9];
						dest[8] = mat[10];

						return dest;
					};

					/**
					 * Calculates the inverse of the upper 3x3 elements of a mat4 and copies the result into a mat3
					 * The resulting matrix is useful for calculating transformed normals
					 *
					 * Params:
					 * @param {mat4} mat mat4 containing values to invert and copy
					 * @param {mat3} [dest] mat3 receiving values
					 *
					 * @returns {mat3} dest is specified, a new mat3 otherwise, null if the matrix cannot be inverted
					 */
					mat4.toInverseMat3 = function (mat, dest) {
						// Cache the matrix values (makes for huge speed increases!)
						var a00 = mat[0], a01 = mat[1], a02 = mat[2],
							a10 = mat[4], a11 = mat[5], a12 = mat[6],
							a20 = mat[8], a21 = mat[9], a22 = mat[10],

							b01 = a22 * a11 - a12 * a21,
							b11 = -a22 * a10 + a12 * a20,
							b21 = a21 * a10 - a11 * a20,

							d = a00 * b01 + a01 * b11 + a02 * b21,
							id;

						if (!d) { return null; }
						id = 1 / d;

						if (!dest) { dest = mat3.create(); }

						dest[0] = b01 * id;
						dest[1] = (-a22 * a01 + a02 * a21) * id;
						dest[2] = (a12 * a01 - a02 * a11) * id;
						dest[3] = b11 * id;
						dest[4] = (a22 * a00 - a02 * a20) * id;
						dest[5] = (-a12 * a00 + a02 * a10) * id;
						dest[6] = b21 * id;
						dest[7] = (-a21 * a00 + a01 * a20) * id;
						dest[8] = (a11 * a00 - a01 * a10) * id;

						return dest;
					};

					/**
					 * Performs a matrix multiplication
					 *
					 * @param {mat4} mat First operand
					 * @param {mat4} mat2 Second operand
					 * @param {mat4} [dest] mat4 receiving operation result. If not specified result is written to mat
					 *
					 * @returns {mat4} dest if specified, mat otherwise
					 */
					mat4.multiply = function (mat, mat2, dest) {
						if (!dest) { dest = mat; }

						// Cache the matrix values (makes for huge speed increases!)
						var a00 = mat[0], a01 = mat[1], a02 = mat[2], a03 = mat[3],
							a10 = mat[4], a11 = mat[5], a12 = mat[6], a13 = mat[7],
							a20 = mat[8], a21 = mat[9], a22 = mat[10], a23 = mat[11],
							a30 = mat[12], a31 = mat[13], a32 = mat[14], a33 = mat[15],

							b00 = mat2[0], b01 = mat2[1], b02 = mat2[2], b03 = mat2[3],
							b10 = mat2[4], b11 = mat2[5], b12 = mat2[6], b13 = mat2[7],
							b20 = mat2[8], b21 = mat2[9], b22 = mat2[10], b23 = mat2[11],
							b30 = mat2[12], b31 = mat2[13], b32 = mat2[14], b33 = mat2[15];

						dest[0] = b00 * a00 + b01 * a10 + b02 * a20 + b03 * a30;
						dest[1] = b00 * a01 + b01 * a11 + b02 * a21 + b03 * a31;
						dest[2] = b00 * a02 + b01 * a12 + b02 * a22 + b03 * a32;
						dest[3] = b00 * a03 + b01 * a13 + b02 * a23 + b03 * a33;
						dest[4] = b10 * a00 + b11 * a10 + b12 * a20 + b13 * a30;
						dest[5] = b10 * a01 + b11 * a11 + b12 * a21 + b13 * a31;
						dest[6] = b10 * a02 + b11 * a12 + b12 * a22 + b13 * a32;
						dest[7] = b10 * a03 + b11 * a13 + b12 * a23 + b13 * a33;
						dest[8] = b20 * a00 + b21 * a10 + b22 * a20 + b23 * a30;
						dest[9] = b20 * a01 + b21 * a11 + b22 * a21 + b23 * a31;
						dest[10] = b20 * a02 + b21 * a12 + b22 * a22 + b23 * a32;
						dest[11] = b20 * a03 + b21 * a13 + b22 * a23 + b23 * a33;
						dest[12] = b30 * a00 + b31 * a10 + b32 * a20 + b33 * a30;
						dest[13] = b30 * a01 + b31 * a11 + b32 * a21 + b33 * a31;
						dest[14] = b30 * a02 + b31 * a12 + b32 * a22 + b33 * a32;
						dest[15] = b30 * a03 + b31 * a13 + b32 * a23 + b33 * a33;

						return dest;
					};

					/**
					 * Transforms a vec3 with the given matrix
					 * 4th vector component is implicitly '1'
					 *
					 * @param {mat4} mat mat4 to transform the vector with
					 * @param {vec3} vec vec3 to transform
					 * @paran {vec3} [dest] vec3 receiving operation result. If not specified result is written to vec
					 *
					 * @returns {vec3} dest if specified, vec otherwise
					 */
					mat4.multiplyVec3 = function (mat, vec, dest) {
						if (!dest) { dest = vec; }

						var x = vec[0], y = vec[1], z = vec[2];

						dest[0] = mat[0] * x + mat[4] * y + mat[8] * z + mat[12];
						dest[1] = mat[1] * x + mat[5] * y + mat[9] * z + mat[13];
						dest[2] = mat[2] * x + mat[6] * y + mat[10] * z + mat[14];

						return dest;
					};

					/**
					 * Transforms a vec4 with the given matrix
					 *
					 * @param {mat4} mat mat4 to transform the vector with
					 * @param {vec4} vec vec4 to transform
					 * @param {vec4} [dest] vec4 receiving operation result. If not specified result is written to vec
					 *
					 * @returns {vec4} dest if specified, vec otherwise
					 */
					mat4.multiplyVec4 = function (mat, vec, dest) {
						if (!dest) { dest = vec; }

						var x = vec[0], y = vec[1], z = vec[2], w = vec[3];

						dest[0] = mat[0] * x + mat[4] * y + mat[8] * z + mat[12] * w;
						dest[1] = mat[1] * x + mat[5] * y + mat[9] * z + mat[13] * w;
						dest[2] = mat[2] * x + mat[6] * y + mat[10] * z + mat[14] * w;
						dest[3] = mat[3] * x + mat[7] * y + mat[11] * z + mat[15] * w;

						return dest;
					};

					/**
					 * Translates a matrix by the given vector
					 *
					 * @param {mat4} mat mat4 to translate
					 * @param {vec3} vec vec3 specifying the translation
					 * @param {mat4} [dest] mat4 receiving operation result. If not specified result is written to mat
					 *
					 * @returns {mat4} dest if specified, mat otherwise
					 */
					mat4.translate = function (mat, vec, dest) {
						var x = vec[0], y = vec[1], z = vec[2],
							a00, a01, a02, a03,
							a10, a11, a12, a13,
							a20, a21, a22, a23;

						if (!dest || mat === dest) {
							mat[12] = mat[0] * x + mat[4] * y + mat[8] * z + mat[12];
							mat[13] = mat[1] * x + mat[5] * y + mat[9] * z + mat[13];
							mat[14] = mat[2] * x + mat[6] * y + mat[10] * z + mat[14];
							mat[15] = mat[3] * x + mat[7] * y + mat[11] * z + mat[15];
							return mat;
						}

						a00 = mat[0]; a01 = mat[1]; a02 = mat[2]; a03 = mat[3];
						a10 = mat[4]; a11 = mat[5]; a12 = mat[6]; a13 = mat[7];
						a20 = mat[8]; a21 = mat[9]; a22 = mat[10]; a23 = mat[11];

						dest[0] = a00; dest[1] = a01; dest[2] = a02; dest[3] = a03;
						dest[4] = a10; dest[5] = a11; dest[6] = a12; dest[7] = a13;
						dest[8] = a20; dest[9] = a21; dest[10] = a22; dest[11] = a23;

						dest[12] = a00 * x + a10 * y + a20 * z + mat[12];
						dest[13] = a01 * x + a11 * y + a21 * z + mat[13];
						dest[14] = a02 * x + a12 * y + a22 * z + mat[14];
						dest[15] = a03 * x + a13 * y + a23 * z + mat[15];
						return dest;
					};

					/**
					 * Scales a matrix by the given vector
					 *
					 * @param {mat4} mat mat4 to scale
					 * @param {vec3} vec vec3 specifying the scale for each axis
					 * @param {mat4} [dest] mat4 receiving operation result. If not specified result is written to mat
					 *
					 * @param {mat4} dest if specified, mat otherwise
					 */
					mat4.scale = function (mat, vec, dest) {
						var x = vec[0], y = vec[1], z = vec[2];

						if (!dest || mat === dest) {
							mat[0] *= x;
							mat[1] *= x;
							mat[2] *= x;
							mat[3] *= x;
							mat[4] *= y;
							mat[5] *= y;
							mat[6] *= y;
							mat[7] *= y;
							mat[8] *= z;
							mat[9] *= z;
							mat[10] *= z;
							mat[11] *= z;
							return mat;
						}

						dest[0] = mat[0] * x;
						dest[1] = mat[1] * x;
						dest[2] = mat[2] * x;
						dest[3] = mat[3] * x;
						dest[4] = mat[4] * y;
						dest[5] = mat[5] * y;
						dest[6] = mat[6] * y;
						dest[7] = mat[7] * y;
						dest[8] = mat[8] * z;
						dest[9] = mat[9] * z;
						dest[10] = mat[10] * z;
						dest[11] = mat[11] * z;
						dest[12] = mat[12];
						dest[13] = mat[13];
						dest[14] = mat[14];
						dest[15] = mat[15];
						return dest;
					};

					/**
					 * Rotates a matrix by the given angle around the specified axis
					 * If rotating around a primary axis (X,Y,Z) one of the specialized rotation functions should be used instead for performance
					 *
					 * @param {mat4} mat mat4 to rotate
					 * @param {number} angle Angle (in radians) to rotate
					 * @param {vec3} axis vec3 representing the axis to rotate around
					 * @param {mat4} [dest] mat4 receiving operation result. If not specified result is written to mat
					 *
					 * @returns {mat4} dest if specified, mat otherwise
					 */
					mat4.rotate = function (mat, angle, axis, dest) {
						var x = axis[0], y = axis[1], z = axis[2],
							len = Math.sqrt(x * x + y * y + z * z),
							s, c, t,
							a00, a01, a02, a03,
							a10, a11, a12, a13,
							a20, a21, a22, a23,
							b00, b01, b02,
							b10, b11, b12,
							b20, b21, b22;

						if (!len) { return null; }
						if (len !== 1) {
							len = 1 / len;
							x *= len;
							y *= len;
							z *= len;
						}

						s = Math.sin(angle);
						c = Math.cos(angle);
						t = 1 - c;

						a00 = mat[0]; a01 = mat[1]; a02 = mat[2]; a03 = mat[3];
						a10 = mat[4]; a11 = mat[5]; a12 = mat[6]; a13 = mat[7];
						a20 = mat[8]; a21 = mat[9]; a22 = mat[10]; a23 = mat[11];

						// Construct the elements of the rotation matrix
						b00 = x * x * t + c; b01 = y * x * t + z * s; b02 = z * x * t - y * s;
						b10 = x * y * t - z * s; b11 = y * y * t + c; b12 = z * y * t + x * s;
						b20 = x * z * t + y * s; b21 = y * z * t - x * s; b22 = z * z * t + c;

						if (!dest) {
							dest = mat;
						} else if (mat !== dest) { // If the source and destination differ, copy the unchanged last row
							dest[12] = mat[12];
							dest[13] = mat[13];
							dest[14] = mat[14];
							dest[15] = mat[15];
						}

						// Perform rotation-specific matrix multiplication
						dest[0] = a00 * b00 + a10 * b01 + a20 * b02;
						dest[1] = a01 * b00 + a11 * b01 + a21 * b02;
						dest[2] = a02 * b00 + a12 * b01 + a22 * b02;
						dest[3] = a03 * b00 + a13 * b01 + a23 * b02;

						dest[4] = a00 * b10 + a10 * b11 + a20 * b12;
						dest[5] = a01 * b10 + a11 * b11 + a21 * b12;
						dest[6] = a02 * b10 + a12 * b11 + a22 * b12;
						dest[7] = a03 * b10 + a13 * b11 + a23 * b12;

						dest[8] = a00 * b20 + a10 * b21 + a20 * b22;
						dest[9] = a01 * b20 + a11 * b21 + a21 * b22;
						dest[10] = a02 * b20 + a12 * b21 + a22 * b22;
						dest[11] = a03 * b20 + a13 * b21 + a23 * b22;
						return dest;
					};

					/**
					 * Rotates a matrix by the given angle around the X axis
					 *
					 * @param {mat4} mat mat4 to rotate
					 * @param {number} angle Angle (in radians) to rotate
					 * @param {mat4} [dest] mat4 receiving operation result. If not specified result is written to mat
					 *
					 * @returns {mat4} dest if specified, mat otherwise
					 */
					mat4.rotateX = function (mat, angle, dest) {
						var s = Math.sin(angle),
							c = Math.cos(angle),
							a10 = mat[4],
							a11 = mat[5],
							a12 = mat[6],
							a13 = mat[7],
							a20 = mat[8],
							a21 = mat[9],
							a22 = mat[10],
							a23 = mat[11];

						if (!dest) {
							dest = mat;
						} else if (mat !== dest) { // If the source and destination differ, copy the unchanged rows
							dest[0] = mat[0];
							dest[1] = mat[1];
							dest[2] = mat[2];
							dest[3] = mat[3];

							dest[12] = mat[12];
							dest[13] = mat[13];
							dest[14] = mat[14];
							dest[15] = mat[15];
						}

						// Perform axis-specific matrix multiplication
						dest[4] = a10 * c + a20 * s;
						dest[5] = a11 * c + a21 * s;
						dest[6] = a12 * c + a22 * s;
						dest[7] = a13 * c + a23 * s;

						dest[8] = a10 * -s + a20 * c;
						dest[9] = a11 * -s + a21 * c;
						dest[10] = a12 * -s + a22 * c;
						dest[11] = a13 * -s + a23 * c;
						return dest;
					};

					/**
					 * Rotates a matrix by the given angle around the Y axis
					 *
					 * @param {mat4} mat mat4 to rotate
					 * @param {number} angle Angle (in radians) to rotate
					 * @param {mat4} [dest] mat4 receiving operation result. If not specified result is written to mat
					 *
					 * @returns {mat4} dest if specified, mat otherwise
					 */
					mat4.rotateY = function (mat, angle, dest) {
						var s = Math.sin(angle),
							c = Math.cos(angle),
							a00 = mat[0],
							a01 = mat[1],
							a02 = mat[2],
							a03 = mat[3],
							a20 = mat[8],
							a21 = mat[9],
							a22 = mat[10],
							a23 = mat[11];

						if (!dest) {
							dest = mat;
						} else if (mat !== dest) { // If the source and destination differ, copy the unchanged rows
							dest[4] = mat[4];
							dest[5] = mat[5];
							dest[6] = mat[6];
							dest[7] = mat[7];

							dest[12] = mat[12];
							dest[13] = mat[13];
							dest[14] = mat[14];
							dest[15] = mat[15];
						}

						// Perform axis-specific matrix multiplication
						dest[0] = a00 * c + a20 * -s;
						dest[1] = a01 * c + a21 * -s;
						dest[2] = a02 * c + a22 * -s;
						dest[3] = a03 * c + a23 * -s;

						dest[8] = a00 * s + a20 * c;
						dest[9] = a01 * s + a21 * c;
						dest[10] = a02 * s + a22 * c;
						dest[11] = a03 * s + a23 * c;
						return dest;
					};

					/**
					 * Rotates a matrix by the given angle around the Z axis
					 *
					 * @param {mat4} mat mat4 to rotate
					 * @param {number} angle Angle (in radians) to rotate
					 * @param {mat4} [dest] mat4 receiving operation result. If not specified result is written to mat
					 *
					 * @returns {mat4} dest if specified, mat otherwise
					 */
					mat4.rotateZ = function (mat, angle, dest) {
						var s = Math.sin(angle),
							c = Math.cos(angle),
							a00 = mat[0],
							a01 = mat[1],
							a02 = mat[2],
							a03 = mat[3],
							a10 = mat[4],
							a11 = mat[5],
							a12 = mat[6],
							a13 = mat[7];

						if (!dest) {
							dest = mat;
						} else if (mat !== dest) { // If the source and destination differ, copy the unchanged last row
							dest[8] = mat[8];
							dest[9] = mat[9];
							dest[10] = mat[10];
							dest[11] = mat[11];

							dest[12] = mat[12];
							dest[13] = mat[13];
							dest[14] = mat[14];
							dest[15] = mat[15];
						}

						// Perform axis-specific matrix multiplication
						dest[0] = a00 * c + a10 * s;
						dest[1] = a01 * c + a11 * s;
						dest[2] = a02 * c + a12 * s;
						dest[3] = a03 * c + a13 * s;

						dest[4] = a00 * -s + a10 * c;
						dest[5] = a01 * -s + a11 * c;
						dest[6] = a02 * -s + a12 * c;
						dest[7] = a03 * -s + a13 * c;

						return dest;
					};

					/**
					 * Generates a frustum matrix with the given bounds
					 *
					 * @param {number} left Left bound of the frustum
					 * @param {number} right Right bound of the frustum
					 * @param {number} bottom Bottom bound of the frustum
					 * @param {number} top Top bound of the frustum
					 * @param {number} near Near bound of the frustum
					 * @param {number} far Far bound of the frustum
					 * @param {mat4} [dest] mat4 frustum matrix will be written into
					 *
					 * @returns {mat4} dest if specified, a new mat4 otherwise
					 */
					mat4.frustum = function (left, right, bottom, top, near, far, dest) {
						if (!dest) { dest = mat4.create(); }
						var rl = (right - left),
							tb = (top - bottom),
							fn = (far - near);
						dest[0] = (near * 2) / rl;
						dest[1] = 0;
						dest[2] = 0;
						dest[3] = 0;
						dest[4] = 0;
						dest[5] = (near * 2) / tb;
						dest[6] = 0;
						dest[7] = 0;
						dest[8] = (right + left) / rl;
						dest[9] = (top + bottom) / tb;
						dest[10] = -(far + near) / fn;
						dest[11] = -1;
						dest[12] = 0;
						dest[13] = 0;
						dest[14] = -(far * near * 2) / fn;
						dest[15] = 0;
						return dest;
					};

					/**
					 * Generates a perspective projection matrix with the given bounds
					 *
					 * @param {number} fovy Vertical field of view
					 * @param {number} aspect Aspect ratio. typically viewport width/height
					 * @param {number} near Near bound of the frustum
					 * @param {number} far Far bound of the frustum
					 * @param {mat4} [dest] mat4 frustum matrix will be written into
					 *
					 * @returns {mat4} dest if specified, a new mat4 otherwise
					 */
					mat4.perspective = function (fovy, aspect, near, far, dest) {
						var top = near * Math.tan(fovy * Math.PI / 360.0),
							right = top * aspect;
						return mat4.frustum(-right, right, -top, top, near, far, dest);
					};

					/**
					 * Generates a orthogonal projection matrix with the given bounds
					 *
					 * @param {number} left Left bound of the frustum
					 * @param {number} right Right bound of the frustum
					 * @param {number} bottom Bottom bound of the frustum
					 * @param {number} top Top bound of the frustum
					 * @param {number} near Near bound of the frustum
					 * @param {number} far Far bound of the frustum
					 * @param {mat4} [dest] mat4 frustum matrix will be written into
					 *
					 * @returns {mat4} dest if specified, a new mat4 otherwise
					 */
					mat4.ortho = function (left, right, bottom, top, near, far, dest) {
						if (!dest) { dest = mat4.create(); }
						var rl = (right - left),
							tb = (top - bottom),
							fn = (far - near);
						dest[0] = 2 / rl;
						dest[1] = 0;
						dest[2] = 0;
						dest[3] = 0;
						dest[4] = 0;
						dest[5] = 2 / tb;
						dest[6] = 0;
						dest[7] = 0;
						dest[8] = 0;
						dest[9] = 0;
						dest[10] = -2 / fn;
						dest[11] = 0;
						dest[12] = -(left + right) / rl;
						dest[13] = -(top + bottom) / tb;
						dest[14] = -(far + near) / fn;
						dest[15] = 1;
						return dest;
					};

					/**
					 * Generates a look-at matrix with the given eye position, focal point, and up axis
					 *
					 * @param {vec3} eye Position of the viewer
					 * @param {vec3} center Point the viewer is looking at
					 * @param {vec3} up vec3 pointing "up"
					 * @param {mat4} [dest] mat4 frustum matrix will be written into
					 *
					 * @returns {mat4} dest if specified, a new mat4 otherwise
					 */
					mat4.lookAt = function (eye, center, up, dest) {
						if (!dest) { dest = mat4.create(); }

						var x0, x1, x2, y0, y1, y2, z0, z1, z2, len,
							eyex = eye[0],
							eyey = eye[1],
							eyez = eye[2],
							upx = up[0],
							upy = up[1],
							upz = up[2],
							centerx = center[0],
							centery = center[1],
							centerz = center[2];

						if (eyex === centerx && eyey === centery && eyez === centerz) {
							return mat4.identity(dest);
						}

						//vec3.direction(eye, center, z);
						z0 = eyex - centerx;
						z1 = eyey - centery;
						z2 = eyez - centerz;

						// normalize (no check needed for 0 because of early return)
						len = 1 / Math.sqrt(z0 * z0 + z1 * z1 + z2 * z2);
						z0 *= len;
						z1 *= len;
						z2 *= len;

						//vec3.normalize(vec3.cross(up, z, x));
						x0 = upy * z2 - upz * z1;
						x1 = upz * z0 - upx * z2;
						x2 = upx * z1 - upy * z0;
						len = Math.sqrt(x0 * x0 + x1 * x1 + x2 * x2);
						if (!len) {
							x0 = 0;
							x1 = 0;
							x2 = 0;
						} else {
							len = 1 / len;
							x0 *= len;
							x1 *= len;
							x2 *= len;
						}

						//vec3.normalize(vec3.cross(z, x, y));
						y0 = z1 * x2 - z2 * x1;
						y1 = z2 * x0 - z0 * x2;
						y2 = z0 * x1 - z1 * x0;

						len = Math.sqrt(y0 * y0 + y1 * y1 + y2 * y2);
						if (!len) {
							y0 = 0;
							y1 = 0;
							y2 = 0;
						} else {
							len = 1 / len;
							y0 *= len;
							y1 *= len;
							y2 *= len;
						}

						dest[0] = x0;
						dest[1] = y0;
						dest[2] = z0;
						dest[3] = 0;
						dest[4] = x1;
						dest[5] = y1;
						dest[6] = z1;
						dest[7] = 0;
						dest[8] = x2;
						dest[9] = y2;
						dest[10] = z2;
						dest[11] = 0;
						dest[12] = -(x0 * eyex + x1 * eyey + x2 * eyez);
						dest[13] = -(y0 * eyex + y1 * eyey + y2 * eyez);
						dest[14] = -(z0 * eyex + z1 * eyey + z2 * eyez);
						dest[15] = 1;

						return dest;
					};

					/**
					 * Creates a matrix from a quaternion rotation and vector translation
					 * This is equivalent to (but much faster than):
					 *
					 *     mat4.identity(dest);
					 *     mat4.translate(dest, vec);
					 *     var quatMat = mat4.create();
					 *     quat4.toMat4(quat, quatMat);
					 *     mat4.multiply(dest, quatMat);
					 *
					 * @param {quat4} quat Rotation quaternion
					 * @param {vec3} vec Translation vector
					 * @param {mat4} [dest] mat4 receiving operation result. If not specified result is written to a new mat4
					 *
					 * @returns {mat4} dest if specified, a new mat4 otherwise
					 */
					mat4.fromRotationTranslation = function (quat, vec, dest) {
						if (!dest) { dest = mat4.create(); }

						// Quaternion math
						var x = quat[0], y = quat[1], z = quat[2], w = quat[3],
							x2 = x + x,
							y2 = y + y,
							z2 = z + z,

							xx = x * x2,
							xy = x * y2,
							xz = x * z2,
							yy = y * y2,
							yz = y * z2,
							zz = z * z2,
							wx = w * x2,
							wy = w * y2,
							wz = w * z2;

						dest[0] = 1 - (yy + zz);
						dest[1] = xy + wz;
						dest[2] = xz - wy;
						dest[3] = 0;
						dest[4] = xy - wz;
						dest[5] = 1 - (xx + zz);
						dest[6] = yz + wx;
						dest[7] = 0;
						dest[8] = xz + wy;
						dest[9] = yz - wx;
						dest[10] = 1 - (xx + yy);
						dest[11] = 0;
						dest[12] = vec[0];
						dest[13] = vec[1];
						dest[14] = vec[2];
						dest[15] = 1;

						return dest;
					};

					/**
					 * Returns a string representation of a mat4
					 *
					 * @param {mat4} mat mat4 to represent as a string
					 *
					 * @returns {string} String representation of mat
					 */
					mat4.str = function (mat) {
						return '[' + mat[0] + ', ' + mat[1] + ', ' + mat[2] + ', ' + mat[3] +
							', ' + mat[4] + ', ' + mat[5] + ', ' + mat[6] + ', ' + mat[7] +
							', ' + mat[8] + ', ' + mat[9] + ', ' + mat[10] + ', ' + mat[11] +
							', ' + mat[12] + ', ' + mat[13] + ', ' + mat[14] + ', ' + mat[15] + ']';
					};

					/*
					 * quat4
					 */

					/**
					 * Creates a new instance of a quat4 using the default array type
					 * Any javascript array containing at least 4 numeric elements can serve as a quat4
					 *
					 * @param {quat4} [quat] quat4 containing values to initialize with
					 *
					 * @returns {quat4} New quat4
					 */
					quat4.create = function (quat) {
						var dest = createArray(4);

						if (quat) {
							dest[0] = quat[0];
							dest[1] = quat[1];
							dest[2] = quat[2];
							dest[3] = quat[3];
						}

						return dest;
					};

					/**
					 * Copies the values of one quat4 to another
					 *
					 * @param {quat4} quat quat4 containing values to copy
					 * @param {quat4} dest quat4 receiving copied values
					 *
					 * @returns {quat4} dest
					 */
					quat4.set = function (quat, dest) {
						dest[0] = quat[0];
						dest[1] = quat[1];
						dest[2] = quat[2];
						dest[3] = quat[3];

						return dest;
					};

					/**
					 * Calculates the W component of a quat4 from the X, Y, and Z components.
					 * Assumes that quaternion is 1 unit in length.
					 * Any existing W component will be ignored.
					 *
					 * @param {quat4} quat quat4 to calculate W component of
					 * @param {quat4} [dest] quat4 receiving calculated values. If not specified result is written to quat
					 *
					 * @returns {quat4} dest if specified, quat otherwise
					 */
					quat4.calculateW = function (quat, dest) {
						var x = quat[0], y = quat[1], z = quat[2];

						if (!dest || quat === dest) {
							quat[3] = -Math.sqrt(Math.abs(1.0 - x * x - y * y - z * z));
							return quat;
						}
						dest[0] = x;
						dest[1] = y;
						dest[2] = z;
						dest[3] = -Math.sqrt(Math.abs(1.0 - x * x - y * y - z * z));
						return dest;
					};

					/**
					 * Calculates the dot product of two quaternions
					 *
					 * @param {quat4} quat First operand
					 * @param {quat4} quat2 Second operand
					 *
					 * @return {number} Dot product of quat and quat2
					 */
					quat4.dot = function(quat, quat2){
						return quat[0]*quat2[0] + quat[1]*quat2[1] + quat[2]*quat2[2] + quat[3]*quat2[3];
					};

					/**
					 * Calculates the inverse of a quat4
					 *
					 * @param {quat4} quat quat4 to calculate inverse of
					 * @param {quat4} [dest] quat4 receiving inverse values. If not specified result is written to quat
					 *
					 * @returns {quat4} dest if specified, quat otherwise
					 */
					quat4.inverse = function(quat, dest) {
						var q0 = quat[0], q1 = quat[1], q2 = quat[2], q3 = quat[3],
							dot = q0*q0 + q1*q1 + q2*q2 + q3*q3,
							invDot = dot ? 1.0/dot : 0;

						// TODO: Would be faster to return [0,0,0,0] immediately if dot == 0

						if(!dest || quat === dest) {
							quat[0] *= -invDot;
							quat[1] *= -invDot;
							quat[2] *= -invDot;
							quat[3] *= invDot;
							return quat;
						}
						dest[0] = -quat[0]*invDot;
						dest[1] = -quat[1]*invDot;
						dest[2] = -quat[2]*invDot;
						dest[3] = quat[3]*invDot;
						return dest;
					};


					/**
					 * Calculates the conjugate of a quat4
					 * If the quaternion is normalized, this function is faster than quat4.inverse and produces the same result.
					 *
					 * @param {quat4} quat quat4 to calculate conjugate of
					 * @param {quat4} [dest] quat4 receiving conjugate values. If not specified result is written to quat
					 *
					 * @returns {quat4} dest if specified, quat otherwise
					 */
					quat4.conjugate = function (quat, dest) {
						if (!dest || quat === dest) {
							quat[0] *= -1;
							quat[1] *= -1;
							quat[2] *= -1;
							return quat;
						}
						dest[0] = -quat[0];
						dest[1] = -quat[1];
						dest[2] = -quat[2];
						dest[3] = quat[3];
						return dest;
					};

					/**
					 * Calculates the length of a quat4
					 *
					 * Params:
					 * @param {quat4} quat quat4 to calculate length of
					 *
					 * @returns Length of quat
					 */
					quat4.length = function (quat) {
						var x = quat[0], y = quat[1], z = quat[2], w = quat[3];
						return Math.sqrt(x * x + y * y + z * z + w * w);
					};

					/**
					 * Generates a unit quaternion of the same direction as the provided quat4
					 * If quaternion length is 0, returns [0, 0, 0, 0]
					 *
					 * @param {quat4} quat quat4 to normalize
					 * @param {quat4} [dest] quat4 receiving operation result. If not specified result is written to quat
					 *
					 * @returns {quat4} dest if specified, quat otherwise
					 */
					quat4.normalize = function (quat, dest) {
						if (!dest) { dest = quat; }

						var x = quat[0], y = quat[1], z = quat[2], w = quat[3],
							len = Math.sqrt(x * x + y * y + z * z + w * w);
						if (len === 0) {
							dest[0] = 0;
							dest[1] = 0;
							dest[2] = 0;
							dest[3] = 0;
							return dest;
						}
						len = 1 / len;
						dest[0] = x * len;
						dest[1] = y * len;
						dest[2] = z * len;
						dest[3] = w * len;

						return dest;
					};

					/**
					 * Performs a quaternion multiplication
					 *
					 * @param {quat4} quat First operand
					 * @param {quat4} quat2 Second operand
					 * @param {quat4} [dest] quat4 receiving operation result. If not specified result is written to quat
					 *
					 * @returns {quat4} dest if specified, quat otherwise
					 */
					quat4.multiply = function (quat, quat2, dest) {
						if (!dest) { dest = quat; }

						var qax = quat[0], qay = quat[1], qaz = quat[2], qaw = quat[3],
							qbx = quat2[0], qby = quat2[1], qbz = quat2[2], qbw = quat2[3];

						dest[0] = qax * qbw + qaw * qbx + qay * qbz - qaz * qby;
						dest[1] = qay * qbw + qaw * qby + qaz * qbx - qax * qbz;
						dest[2] = qaz * qbw + qaw * qbz + qax * qby - qay * qbx;
						dest[3] = qaw * qbw - qax * qbx - qay * qby - qaz * qbz;

						return dest;
					};

					/**
					 * Transforms a vec3 with the given quaternion
					 *
					 * @param {quat4} quat quat4 to transform the vector with
					 * @param {vec3} vec vec3 to transform
					 * @param {vec3} [dest] vec3 receiving operation result. If not specified result is written to vec
					 *
					 * @returns dest if specified, vec otherwise
					 */
					quat4.multiplyVec3 = function (quat, vec, dest) {
						if (!dest) { dest = vec; }

						var x = vec[0], y = vec[1], z = vec[2],
							qx = quat[0], qy = quat[1], qz = quat[2], qw = quat[3],

							// calculate quat * vec
							ix = qw * x + qy * z - qz * y,
							iy = qw * y + qz * x - qx * z,
							iz = qw * z + qx * y - qy * x,
							iw = -qx * x - qy * y - qz * z;

						// calculate result * inverse quat
						dest[0] = ix * qw + iw * -qx + iy * -qz - iz * -qy;
						dest[1] = iy * qw + iw * -qy + iz * -qx - ix * -qz;
						dest[2] = iz * qw + iw * -qz + ix * -qy - iy * -qx;

						return dest;
					};

					/**
					 * Calculates a 3x3 matrix from the given quat4
					 *
					 * @param {quat4} quat quat4 to create matrix from
					 * @param {mat3} [dest] mat3 receiving operation result
					 *
					 * @returns {mat3} dest if specified, a new mat3 otherwise
					 */
					quat4.toMat3 = function (quat, dest) {
						if (!dest) { dest = mat3.create(); }

						var x = quat[0], y = quat[1], z = quat[2], w = quat[3],
							x2 = x + x,
							y2 = y + y,
							z2 = z + z,

							xx = x * x2,
							xy = x * y2,
							xz = x * z2,
							yy = y * y2,
							yz = y * z2,
							zz = z * z2,
							wx = w * x2,
							wy = w * y2,
							wz = w * z2;

						dest[0] = 1 - (yy + zz);
						dest[1] = xy + wz;
						dest[2] = xz - wy;

						dest[3] = xy - wz;
						dest[4] = 1 - (xx + zz);
						dest[5] = yz + wx;

						dest[6] = xz + wy;
						dest[7] = yz - wx;
						dest[8] = 1 - (xx + yy);

						return dest;
					};

					/**
					 * Calculates a 4x4 matrix from the given quat4
					 *
					 * @param {quat4} quat quat4 to create matrix from
					 * @param {mat4} [dest] mat4 receiving operation result
					 *
					 * @returns {mat4} dest if specified, a new mat4 otherwise
					 */
					quat4.toMat4 = function (quat, dest) {
						if (!dest) { dest = mat4.create(); }

						var x = quat[0], y = quat[1], z = quat[2], w = quat[3],
							x2 = x + x,
							y2 = y + y,
							z2 = z + z,

							xx = x * x2,
							xy = x * y2,
							xz = x * z2,
							yy = y * y2,
							yz = y * z2,
							zz = z * z2,
							wx = w * x2,
							wy = w * y2,
							wz = w * z2;

						dest[0] = 1 - (yy + zz);
						dest[1] = xy + wz;
						dest[2] = xz - wy;
						dest[3] = 0;

						dest[4] = xy - wz;
						dest[5] = 1 - (xx + zz);
						dest[6] = yz + wx;
						dest[7] = 0;

						dest[8] = xz + wy;
						dest[9] = yz - wx;
						dest[10] = 1 - (xx + yy);
						dest[11] = 0;

						dest[12] = 0;
						dest[13] = 0;
						dest[14] = 0;
						dest[15] = 1;

						return dest;
					};

					/**
					 * Performs a spherical linear interpolation between two quat4
					 *
					 * @param {quat4} quat First quaternion
					 * @param {quat4} quat2 Second quaternion
					 * @param {number} slerp Interpolation amount between the two inputs
					 * @param {quat4} [dest] quat4 receiving operation result. If not specified result is written to quat
					 *
					 * @returns {quat4} dest if specified, quat otherwise
					 */
					quat4.slerp = function (quat, quat2, slerp, dest) {
						if (!dest) { dest = quat; }

						var cosHalfTheta = quat[0] * quat2[0] + quat[1] * quat2[1] + quat[2] * quat2[2] + quat[3] * quat2[3],
							halfTheta,
							sinHalfTheta,
							ratioA,
							ratioB;

						if (Math.abs(cosHalfTheta) >= 1.0) {
							if (dest !== quat) {
								dest[0] = quat[0];
								dest[1] = quat[1];
								dest[2] = quat[2];
								dest[3] = quat[3];
							}
							return dest;
						}

						halfTheta = Math.acos(cosHalfTheta);
						sinHalfTheta = Math.sqrt(1.0 - cosHalfTheta * cosHalfTheta);

						if (Math.abs(sinHalfTheta) < 0.001) {
							dest[0] = (quat[0] * 0.5 + quat2[0] * 0.5);
							dest[1] = (quat[1] * 0.5 + quat2[1] * 0.5);
							dest[2] = (quat[2] * 0.5 + quat2[2] * 0.5);
							dest[3] = (quat[3] * 0.5 + quat2[3] * 0.5);
							return dest;
						}

						ratioA = Math.sin((1 - slerp) * halfTheta) / sinHalfTheta;
						ratioB = Math.sin(slerp * halfTheta) / sinHalfTheta;

						dest[0] = (quat[0] * ratioA + quat2[0] * ratioB);
						dest[1] = (quat[1] * ratioA + quat2[1] * ratioB);
						dest[2] = (quat[2] * ratioA + quat2[2] * ratioB);
						dest[3] = (quat[3] * ratioA + quat2[3] * ratioB);

						return dest;
					};

					/**
					 * Returns a string representation of a quaternion
					 *
					 * @param {quat4} quat quat4 to represent as a string
					 *
					 * @returns {string} String representation of quat
					 */
					quat4.str = function (quat) {
						return '[' + quat[0] + ', ' + quat[1] + ', ' + quat[2] + ', ' + quat[3] + ']';
					};


					return {
						vec3: vec3,
						mat3: mat3,
						mat4: mat4,
						quat4: quat4
					}
				}
			)

			define(
				"glmatrix/vec3",
				[
					"glmatrix/glmatrix"
				],
				function(
					glmatrix
				) {
					return glmatrix.vec3
				}
			)

			define(
				"glmatrix/mat4",
				[
					"glmatrix/glmatrix"
				],
				function(
					glmatrix
				) {
					return glmatrix.mat4
				}
			)

			define(
				"spell/shared/util/math",
				function(
				) {
					"use strict"


					var clamp = function( value, lowerBound, upperBound ) {
						if ( value < lowerBound) return lowerBound;
						if ( value > upperBound) return upperBound;

						return value;
					}

					var isInInterval = function( value, lowerBound, upperBound ) {
						return ( value >= lowerBound && value <= upperBound )
					}

					/**
					 * Creates a random number generator.
					 *
					 * @param seed - seed that the rng is initialized with
					 */
					var createRandomNumberGenerator = function( seed ) {
						if( seed === undefined ) {
							seed = 0
						}

						var constant  = Math.pow( 2, 13 ) + 1
						var bigNumber = Math.pow( 2, 20 )
						var prime     = 1987
						var maximum   = 1000000 // number of decimal digits


						return {
							next : function( min, max ) {
								seed = seed % bigNumber
								seed *= constant
								seed += prime


								// if 'min' and 'max' are not provided, return random number between 0.0 and 1.0
								return (
									min !== undefined && max !== undefined ?
									min + seed % maximum / maximum * ( max - min ) :
									seed % maximum / maximum
								)
							}
						}
					}


					return {
						clamp : clamp,
						isInInterval : isInInterval,
						createRandomNumberGenerator : createRandomNumberGenerator
					}
				}
			)


			define(
				"spell/shared/util/color",
				[
					"spell/shared/util/math",

					"glmatrix/vec3",
					"underscore"
				],
				function(
					MathHelper,

					vec3,
					_
				) {
					"use strict"


					var toRange = function( value ) {
						return Math.round( MathHelper.clamp( value, 0, 1 ) * 255 )
					}


					var createRgb = function( r, g, b ) {
						return [ r, g, b ]
					}


					var createRgba = function( r, g, b, a ) {
						return [ r, g, b, a ]
					}


					var createRandom = function() {
						var primaryColorIndex = Math.round( Math.random() * 3 )
						var colorVec = vec3.create( [ 0.8, 0.8, 0.8 ] )

						for( var i = 0; i < colorVec.length; i++ ) {
							if ( i === primaryColorIndex ) {
								colorVec[ i ] = 0.95

							} else {
								colorVec[ i ] *= Math.random()
							}
						}

						return colorVec
					}


					var formatCanvas = function( r, g, b, a ) {
						if( a === undefined ) {
							return 'rgb('
								+ toRange( r ) + ', '
								+ toRange( g ) + ', '
								+ toRange( b ) + ')'
						}

						return 'rgba('
							+ toRange( r ) + ', '
							+ toRange( g ) + ', '
							+ toRange( b ) + ', '
							+ toRange( a ) + ')'
					}


					var isVec3Color = function( vec ) {
						return _.size( vec ) === 3
					}


					var isVec4Color = function( vec ) {
						return _.size( vec ) === 4
					}


					return {
						createRgb    : createRgb,
						createRgba   : createRgba,
						createRandom : createRandom,
						formatCanvas : formatCanvas,
						isVec3Color  : isVec3Color,
						isVec4Color  : isVec4Color
					}
				}
			)


			define(
				"spell/shared/util/Events",
				[
					"underscore"
				],
				function(
					_
				) {
					"use strict"


					var events = [
						// ResourceLoader
						"RESOURCE_PROGRESS",
						"RESOURCE_LOADING_COMPLETED",
						"RESOURCE_ERROR"
					]

					return _.reduce(
						events,
						function( memo, event ) {
							memo.result[ event ] = memo.index++

							return memo
						},
						{
							index  : 10,
							result : {}
						}
					).result
				}
			)

			define(
				"spell/client/components/sound/soundEmitter",
				function() {
					"use strict"

					var soundEmitter = function( args ) {
						this.soundId    = args.soundId
						this.volume     = args.volume     || 1
						this.muted      = args.muted      || false
						this.onComplete = args.onComplete || ''
						this.start      = args.start      || false
						this.stop       = args.stop       || false
						this.background = args.background || false
					}

					soundEmitter.ON_COMPLETE_LOOP               = 1
					soundEmitter.ON_COMPLETE_REMOVE_COMPONENT   = 2
					soundEmitter.ON_COMPLETE_STOP               = 3

					return soundEmitter
				}
			)

			define(
				"spell/shared/util/input/keyCodes",
				function() {
					return {
						"backspace": 8,
						"tab"      : 9,
						"enter"    : 13,
						"shift"    : 16,
						"ctrl"     : 17,
						"alt"      : 18,
						"pause"    : 19,
						"caps lock": 20,
						"escape"   : 27,
						"space"    : 32,
						"page up"  : 33,
						"page down": 34,
						"end"      : 35,
						"home"     : 36,
						"left arrow": 37,
						"up arrow"  : 38,
						"right arrow": 39,
						"down arrow" : 40,
						"insert"     : 45,
						"delete"     : 46,
						"0"          : 48,
						"1"          : 49,
						"2"          : 50,
						"3"          : 51,
						"4"          : 52,
						"5"          : 53,
						"6"          : 54,
						"7"          : 55,
						"8"          : 56,
						"9"          : 57,
						"a"          : 65,
						"b"          : 66,
						"c"          : 67,
						"d"          : 68,
						"e"          : 69,
						"f"          : 70,
						"g"          : 71,
						"h"          : 72,
						"i"          : 73,
						"j"          : 74,
						"k"          : 75,
						"l"          : 76,
						"m"          : 77,
						"n"          : 78,
						"o"          : 79,
						"p"          : 80,
						"q"          : 81,
						"r"          : 82,
						"s"          : 83,
						"t"          : 84,
						"u"          : 85,
						"v"          : 86,
						"w"          : 87,
						"x"          : 88,
						"y"          : 89,
						"z"          : 90,
						"left window key": 91,
						"right window key": 92,
						"select key"      : 93,
						"numpad 0"        : 96,
						"numpad 1"        : 97,
						"numpad 2"        : 98,
						"numpad 3"        : 99,
						"numpad 4"        : 100,
						"numpad 5"        : 101,
						"numpad 6"        : 102,
						"numpad 7"        : 103,
						"numpad 8"        : 104,
						"numpad 9"        : 105,
						"multiply"        : 106,
						"add"             : 107,
						"subtract"        : 109,
						"decimal point"   : 110,
						"divide"          : 111,
						"f1"              : 112,
						"f2"              : 113,
						"f3"              : 114,
						"f4"              : 115,
						"f5"              : 116,
						"f6"              : 117,
						"f7"              : 118,
						"f8"              : 119,
						"f9"              : 120,
						"f10"             : 121,
						"f11"             : 122,
						"f12"             : 123,
						"num lock"        : 144,
						"scroll lock"     : 145,
						"semi-colon"      : 186,
						"equal sign"      : 187,
						"comma"           : 188,
						"dash"            : 189,
						"period"          : 190,
						"forward slash"   : 191,
						"grave accent"    : 192,
						"open bracket"    : 219,
						"back slash"      : 220,
						"close bracket"   : 221,
						"single quote"    : 222
					}
				}
			)

			define(
				"spell/shared/components/sound/soundEmitter",
				function() {
					"use strict"

					var soundEmitter = function( args ) {
						this.soundId    = args.soundId
						this.volume     = args.volume     || 1
						this.muted      = args.muted      || false
						this.onComplete = args.onComplete || ''
						this.start      = args.start      || false
						this.stop       = args.stop       || false
						this.background = args.background || false
					}

					soundEmitter.ON_COMPLETE_LOOP               = 1
					soundEmitter.ON_COMPLETE_REMOVE_COMPONENT   = 2
					soundEmitter.ON_COMPLETE_STOP               = 3

					return soundEmitter
				}
			)
		}


		// definitions of modules written in Javascript go here
		private function loadModuleDefinitionsJavascript() : void {

define(
	"funkysnakes/client/components/appearance",
	function() {
		"use strict"


		return function( args ) {
			this.textureId = args.textureId
			this.offset    = ( args.offset !== undefined ? [ args.offset[ 0 ], args.offset[ 1 ], 0 ] : [ 0, 0, 0 ] )
			this.scale     = ( args.scale !== undefined ? [ args.scale[ 0 ], args.scale[ 1 ], 0 ] : [ 1, 1, 0 ] )
			this.opacity   = 1.0
		}
	}
)

define(
	"funkysnakes/client/components/renderData",
	function() {
		"use strict"


		return function( args ) {
			this.position    = [ 0, 0, 0 ]
			this.orientation = 0
			this.scale       = [ 1, 1 ]

			/**
			 * The render pass the entity is rendered in. Lower number means earlier rendering in the render process.
			 */
			this.pass = ( args.pass !== undefined ? args.pass : 0 )

			this.opacity = ( args.opacity !== undefined ? args.opacity : 1.0 )
		}
	}
)

define(
	"funkysnakes/shared/components/position",
	[
		"glmatrix/vec3"
	],
	function(
		vec3
	) {
		"use strict"


		return function( pos ) {
			return vec3.create( pos )
		}
	}
)

define(
	"funkysnakes/client/entities/arena",
	[
		"funkysnakes/client/components/appearance",
		"funkysnakes/client/components/renderData",
		"funkysnakes/shared/components/position"
	],
	function(
		appearance,
		renderData,
		position
	) {
		"use strict"


		return function() {
			this.appearance = new appearance( { textureId: "environment/arena.png" } )
			this.position   = new position( [ 5, 40, 0 ] )
			this.renderData = new renderData( { pass: 3 } )
		}
	}
)

define(
	"funkysnakes/client/components/cloud",
	[
		"glmatrix/vec3"
	],
	function(
		vec3
	) {
		"use strict"


		return function( args ) {
			this.speed = ( args.speed !== undefined ? vec3.create( args.speed ) : [ 0, 0, 0 ] )
		}
	}
)

define(
	"funkysnakes/client/entities/cloud",
	[
		"funkysnakes/client/components/appearance",
		"funkysnakes/client/components/cloud",
		"funkysnakes/client/components/renderData",
		"funkysnakes/shared/components/position"
	],
	function(
		appearance,
		cloud,
		renderData,
		position
	) {
		"use strict"


		return function( args ) {
			this.appearance = new appearance( {
				scale:     args.scale,
				textureId: args.textureId
			} )

			this.cloud = new cloud( {
				speed: args.speed
			} )

			this.renderData = new renderData( {
				pass: args.pass
			} )

			this.position = new position( args.position )
		}
	}
)

define(
	"spell/shared/components/input/inputDefinition",
	function() {
		"use strict"


		return function( inputId, actions ) {
			this.inputId = inputId
			this.actions = actions
		}
	}
)

define(
	"spell/shared/components/input/inputReceiver",
	function() {
		"use strict"


		return function( inputId, actions ) {
			var self = this

			self.inputId                = inputId
			self.actions                = {}
			self.events                 = []
			self.lastProcessedSeqNumber = -1
			self.lastSentSeqNumber      = -1

			self.lastSentEventTypeByAction = {}

			actions.forEach( function( action ) {
				self.actions[ action ] = false
			} )
		}
	}
)

define(
	"funkysnakes/client/entities/gameStarter",
	[
		"spell/shared/components/input/inputDefinition",
		"spell/shared/components/input/inputReceiver",
		"spell/shared/util/input/keyCodes"
	],
	function(
		inputDefinition,
		inputReceiver,
		keyCodes
	) {
		"use strict"


		return function() {
			this.inputDefinition = new inputDefinition(
				"GameStarter",
				[
					{ action: "start game", key: keyCodes[ "enter" ] }
				]
			)
			this.inputReceiver = new inputReceiver( "GameStarter", [ "start game" ] )
			this.gameStarter = {}
		}
	}
)

define(
	"funkysnakes/client/components/networkInterpolation",
	function() {
		"use strict"


		return function() {}
	}
)

define(
	"funkysnakes/client/components/powerupEffects",
	function() {
		"use strict"


		return function( args ) {
			this.baseTextureId          = args.baseTextureId
			this.speedTextureId         = args.speedTextureId
			this.invincibilityTextureId = args.invincibilityTextureId
		}
	}
)

define(
	"funkysnakes/client/components/shadowCaster",
	function() {
		"use strict"


		return function( args ) {
			this.textureId = args.textureId
		}
	}
)

define(
	"funkysnakes/shared/components/head",
	function() {
		"use strict"


		return function( clientId ) {
			this.clientId   = clientId

			this.bonusCountdowns = []
			this.speedBonus      = 0

			this.invincibilityCountdown = 0
		}
	}
)

define(
	"funkysnakes/shared/components/activePowerups",
	function(){
		"use strict"


		return function() {}
	}
)

define(
	"funkysnakes/shared/components/orientation",
	function() {
		"use strict"


		return function( angle ) {
			this.angle = angle
		}
	}
)

define(
	"funkysnakes/shared/components/body",
	function() {
		"use strict"


		return function( id ) {
			this.id = id
			this.pastPositions = []
			this.distanceCoveredSinceLastSavedPosition = 0
		}
	}
)

define(
	"funkysnakes/shared/components/active",
	function() {
		"use strict"


		return function() {}
	}
)

define(
	"funkysnakes/shared/components/amountTailElements",
	function() {
		"use strict"


		return function( amount ) {
			this.value = amount || 0
		}
	}
)

define(
	"spell/shared/util/network/snapshots",
	function() {
		"use strict"


		var snapshots = {
			SNAPSHOT_NOT_NEWEST_ERROR: "The added snapshot has an earlier timestamp than the latest snapshot.",


			create: function() {
				var theSnapshots = []
				initializeSnapshots( theSnapshots )
				return theSnapshots
			},

			add: function( theSnapshots, time, data ) {
				var latest = this.latest( theSnapshots )
				if ( latest !== undefined && latest.time > time ) {
					throw this.SNAPSHOT_NOT_NEWEST_ERROR
				}

				theSnapshots.push( {
					time: time,
					data: data
				} )
			},

			current: function( theSnapshots ) {
				return snapshotOrUndefined( theSnapshots[ 0 ] )
			},

			next: function( theSnapshots ) {
				return theSnapshots[ 1 ]
			},

			latest: function( theSnapshots ) {
				return snapshotOrUndefined( theSnapshots[ theSnapshots.length - 1 ] )
			},

			empty: function( theSnapshots ) {
				return theSnapshots.length === 1
			},

			forwardTo: function( theSnapshots, time ) {
				while( theSnapshots[ 1 ] !== undefined &&
						theSnapshots[ 2 ] !== undefined &&
						time >= theSnapshots[ 1 ].time ) {

					theSnapshots.shift()
				}
			},

			clear: function( theSnapshots ) {
				theSnapshots.length = 0
				initializeSnapshots( theSnapshots )
			}
		}


		function snapshotOrUndefined( s ) {
			if ( s.data === undefined ) {
				return undefined
			}
			else {
				return s
			}
		}

		function initializeSnapshots( theSnapshots ) {
			theSnapshots.push( {
				time: 0,
				data: undefined
			} )
		}


		return snapshots
	}
)

define(
	"spell/client/components/network/synchronizationSlave",
	[
		"spell/shared/util/network/snapshots"
	],
	function(
		snapshots
	) {
		"use strict"


		return function( args ) {
			this.id        = args.id
			this.snapshots = snapshots.create()
		}
	}
)

define(
	"funkysnakes/client/entities/head",
	[
		"funkysnakes/client/components/appearance",
		"funkysnakes/client/components/networkInterpolation",
		"funkysnakes/client/components/powerupEffects",
		"funkysnakes/client/components/renderData",
		"funkysnakes/client/components/shadowCaster",
		"funkysnakes/shared/components/head",
		"funkysnakes/shared/components/activePowerups",
		"funkysnakes/shared/components/orientation",
		"funkysnakes/shared/components/position",
		"funkysnakes/shared/components/body",
		"funkysnakes/shared/components/active",
		'funkysnakes/shared/components/amountTailElements',

		"spell/client/components/network/synchronizationSlave",
		"spell/shared/components/input/inputReceiver"
	],
	function(
		appearance,
		networkInterpolation,
		powerupEffects,
		renderData,
		shadowCaster,
		head,
		activePowerups,
		orientation,
		position,
		body,
		active,
		amountTailElements,

		synchronizationSlave,
		inputReceiver
	) {
		"use strict"


		return function( args ) {
			this.appearance = new appearance( {
				textureId : args.headTextureId,
				offset    : [ -29, -32 ]
			} )

			this.shadowCaster = new shadowCaster( {
				textureId : "shadows/vehicle.png"
			} )

			this.powerupEffects = new powerupEffects( {
				baseTextureId          : args.headTextureId,
				speedTextureId         : args.speedTextureId,
				invincibilityTextureId : args.invincibilityTextureId
			} )

			this.activePowerups       = new activePowerups()
			this.inputReceiver        = new inputReceiver( "player", [ "left", "right" ] )
			this.networkInterpolation = new networkInterpolation()
			this.orientation          = new orientation( args.angle )
			this.position             = new position( [ args.x, args.y, 0 ] )
			this.renderData           = new renderData( { pass: 5 } )
			this.synchronizationSlave = new synchronizationSlave( { id: args.networkId } )
			this.body                 = new body( args.clientId )
			this.head                 = new head( args.clientId )
			this.active               = new active()
			this.amountTailElements   = new amountTailElements()
		}
	}
)

define(
	"funkysnakes/client/entities/invincibilityPowerup",
	[
		"funkysnakes/client/components/appearance",
		"funkysnakes/client/components/networkInterpolation",
		"funkysnakes/client/components/renderData",
		"funkysnakes/client/components/shadowCaster",
		"funkysnakes/shared/components/position",

		"spell/client/components/network/synchronizationSlave"
	],
	function(
		appearance,
		networkInterpolation,
		renderData,
		shadowCaster,
		position,

		synchronizationSlave
	) {
		"use strict"


		return function( args ) {
			this.appearance = new appearance( {
				textureId : "items/invincible.png",
				offset    : [ -23, -24 ]
			} )

			this.shadowCaster = new shadowCaster( {
				textureId: "shadows/invincible.png"
			} )

			this.networkInterpolation = new networkInterpolation()
			this.position             = new position( args.position )
			this.renderData           = new renderData( { pass: 5 } )
			this.synchronizationSlave = new synchronizationSlave( { id: args.networkId } )
		}
	}
)

define(
	"funkysnakes/client/entities/shieldPowerup",
	[
		"funkysnakes/client/components/appearance",
		"funkysnakes/client/components/networkInterpolation",
		"funkysnakes/client/components/renderData",
		"funkysnakes/shared/components/position",

		"spell/client/components/network/synchronizationSlave"
	],
	function(
		appearance,
		networkInterpolation,
		renderData,
		position,

		synchronizationSlave
	) {
		"use strict"


		return function( args ) {
			this.appearance = new appearance( {
				textureId : "items/object_energy.png",
				offset    : [ -24, -24 ]
			} )

			this.networkInterpolation = new networkInterpolation()
			this.position             = new position( args.position )
			this.renderData           = new renderData( { pass: 5 } )
			this.synchronizationSlave = new synchronizationSlave( { id: args.networkId } )
		}
	}
)

define(
	"funkysnakes/client/entities/player",
	[
		"spell/shared/components/input/inputDefinition",
		"spell/shared/components/input/inputReceiver"
	],
	function(
		inputDefinition,
		inputReceiver
	) {
		"use strict"


		return function( playerId, leftKey, rightKey, spaceKey ) {
			this.inputDefinition = new inputDefinition(
				playerId,
				[
					{ action: "left"    , key: leftKey  },
					{ action: "right"   , key: rightKey },
					{ action: "use item", key: spaceKey }
				]
			)
			this.inputReceiver = new inputReceiver( playerId, [ "left", "right", "use item" ] )
			this.player = {}
		}
	}
)

define(
	"funkysnakes/shared/components/scoreDisplay",
	function() {
		"use strict"


		return function( playerId ) {
			this.playerId = playerId
		}
	}
)

define(
	"funkysnakes/shared/components/text",
	function() {
		"use strict"


		return function( text, color ) {
			this.value = text
			this.color = color
		}
	}
)

define(
	"funkysnakes/client/entities/scoreDisplay",
	[
		"funkysnakes/shared/components/position",
		"funkysnakes/shared/components/scoreDisplay",
		"funkysnakes/shared/components/text"
	],
	function(
		position,
		scoreDisplay,
		text
	) {
		"use strict"


		return function( position, playerId, textColor ) {
			this.position     = new position( position )
			this.scoreDisplay = new scoreDisplay( playerId )
			this.text         = new text( "", textColor )
		}
	}
)

define(
	"funkysnakes/shared/components/assignedToPlayer",
	function() {
		"use strict"


		/**
		 * playerId = -1 means entity is neutral
		 */
		return function( playerId ) {
			this.playerId = ( playerId !== undefined ? playerId : -1 )
		}
	}
)

define(
	"funkysnakes/shared/config/constants",
	function() {
		return {
			// canvas size
			xSize: 1024,
			ySize: 768,

			// playing field border
			left  : 75,
			right : 955,
			top   : 105,
			bottom: 695,

			// ship
			minSpeedPerSecond : 80,
			maxSpeedPerSecond : 390,
			speedPerSecond    : 130,
			speedPowerupBonus : 50,

			interpolationDelay: 100,

			// tail
			pastPositionsDistance: 10,
			tailElementDistance  : 30,
			distanceTailToShip   : 35,

			// shield
			shieldLifetime: 2.0, // in seconds

			// misc
			maxCloudTextureSize: 512
		}
	}
)

define(
	"funkysnakes/shared/config/players",
	[
		"funkysnakes/shared/config/constants",

		"spell/shared/util/input/keyCodes"
	],
	function(
		constants,

		keyCodes
	) {
		"use strict"


		return [
			{
				headTextureId          : "vehicles/ship_player1.png",
				bodyTextureId          : "items/player1_container.png",
				speedTextureId         : "vehicles/ship_player1_speed.png",
				invincibilityTextureId : "vehicles/ship_player1_invincible.png",

				scoreColor: "rgb( 0, 0, 255 )",

				leftKey : keyCodes[ "left arrow" ],
				rightKey: keyCodes[ "right arrow" ],
				useKey  : keyCodes[ "space" ],

				scoreDisplayPosition: [ 5, 20, 0 ],

				startX          : constants.xSize / 4,
				startY          : constants.ySize / 4,
				startOrientation: Math.PI / 2
			},

			{
				headTextureId          : "vehicles/ship_player2.png",
				bodyTextureId          : "items/player2_container.png",
				speedTextureId         : "vehicles/ship_player2_speed.png",
				invincibilityTextureId : "vehicles/ship_player2_invincible.png",

				scoreColor: "rgb( 0, 255, 0 )",

				leftKey : keyCodes[ "y" ],
				rightKey: keyCodes[ "x" ],

				scoreDisplayPosition: [ 155, 20, 0 ],

				startX          : constants.xSize / 4 * 3,
				startY          : constants.ySize / 4 * 3,
				startOrientation: -Math.PI / 2
			},

			{
				headTextureId          : "vehicles/ship_player3.png",
				bodyTextureId          : "items/player3_container.png",
				speedTextureId         : "vehicles/ship_player3_speed.png",
				invincibilityTextureId : "vehicles/ship_player3_invincible.png",

				scoreColor: "rgb( 255, 0, 0 )",

				leftKey : keyCodes[ "n" ],
				rightKey: keyCodes[ "m" ],

				scoreDisplayPosition: [ 305, 20, 0 ],

				startX          : constants.xSize / 4,
				startY          : constants.ySize / 4 * 3,
				startOrientation: 0
			},

			{
				headTextureId          : "vehicles/ship_player4.png",
				bodyTextureId          : "items/player4_container.png",
				speedTextureId         : "vehicles/ship_player4_speed.png",
				invincibilityTextureId : "vehicles/ship_player4_invincible.png",

				scoreColor: "rgb( 236, 187, 93 )",

				leftKey : keyCodes[ "1" ],
				rightKey: keyCodes[ "q" ],

				scoreDisplayPosition: [ 455, 20, 0 ],

				startX          : constants.xSize / 4 * 3,
				startY          : constants.ySize / 4,
				startOrientation: Math.PI
			}
		]
	}
)

define(
	"funkysnakes/client/entities/speedPowerup",
	[
		"funkysnakes/client/components/appearance",
		"funkysnakes/client/components/networkInterpolation",
		"funkysnakes/client/components/renderData",
		"funkysnakes/client/components/shadowCaster",
		"funkysnakes/shared/components/position",
		"funkysnakes/shared/components/assignedToPlayer",
		"funkysnakes/shared/config/players",
		"spell/shared/components/sound/soundEmitter",

		"spell/client/components/network/synchronizationSlave"
	],
	function(
		appearance,
		networkInterpolation,
		renderData,
		shadowCaster,
		position,
		assignedToPlayer,
		playerConfiguration,
		soundEmitter,

		synchronizationSlave
	) {
		"use strict"


		var createTextureId = function( playerId ) {
			if( playerId === -1 ) {
				return "items/neutral_container.png"
			}


			var player = playerConfiguration[ playerId ]

			return player.bodyTextureId
		}

		return function( args ) {
			this.networkInterpolation = new networkInterpolation()
			this.position             = new position( args.position )
			this.renderData           = new renderData( { pass: 5 } )
			this.synchronizationSlave = new synchronizationSlave( { id: args.networkId } )
			this.assignedToPlayer     = new assignedToPlayer( args.playerId )

			if( args.type === "speed" ) {
				this.appearance = new appearance( {
					textureId : createTextureId( this.assignedToPlayer.playerId ),
					offset    :  [ -12, -12 ]
				} )

				this.soundEmitter = new soundEmitter( {
					soundId:'fx/spawn',
					volume: 0.40
				} )

			} else if( args.type === "spentSpeed" ) {
				this.appearance = new appearance( {
					textureId : "items/dropped_container_0.png",
					offset    :  [ -12, -12 ]
				} )

				this.soundEmitter = new soundEmitter( {
					soundId:'fx/speed',
					volume: 0.60
				} )
			}

			this.shadowCaster= new shadowCaster( {
				textureId: "shadows/container.png"
			} )
		}
	}
)

define(
	"funkysnakes/client/components/background",
	function() {
		"use strict"


		return function( args ) {
		}
	}
)

define(
	"funkysnakes/client/entities/background",
	[
		"funkysnakes/shared/components/position",
		"funkysnakes/client/components/appearance",
		"funkysnakes/client/components/background",
		"spell/shared/components/sound/soundEmitter"
	],
	function(
		position,
		appearance,
		background,
		soundEmitter
	) {
		"use strict"


		return function( args ) {
			this.position   = new position( args.position || [ 0, 0, 0 ] )

			this.appearance = new appearance( {
				textureId: args.textureId
			} )

			this.soundEmitter = new soundEmitter( {
				soundId:'music/rain',
				volume: 0.5,
				onComplete: soundEmitter.ON_COMPLETE_LOOP,
				background: true
			} )

			this.background = new background()
		}
	}
)

define(
	"funkysnakes/client/entities/widget",
	[
		"funkysnakes/client/components/appearance",
		"funkysnakes/shared/components/position",
		"funkysnakes/client/components/renderData"
	],
	function(
		appearance,
		position,
		renderData
	) {
		"use strict"


		return function( args ) {
			this.appearance = new appearance( {
				scale     : args.scale,
				textureId : args.textureId
			} )

			this.position   = new position( args.position || [ 0, 0, 0 ] )
			this.renderData = new renderData( { pass: 100 } ) // "100" means render it in the last pass
		}
	}
)

define(
	"funkysnakes/client/components/fade",
	function() {
		"use strict"


		return function( args ) {
			this.beginAfter = args.beginAfter
			this.duration   = args.duration
			this.age        = 0
			this.start      = ( args.start !== undefined ? args.start : 1.0 )
			this.end        = ( args.end !== undefined ? args.end : 0.0 )
		}
	}
)

define(
	"funkysnakes/client/entities/widgetThatFades",
	[
		"funkysnakes/client/components/appearance",
		"funkysnakes/client/components/fade",
		"funkysnakes/shared/components/position",
		"funkysnakes/client/components/renderData"
	],
	function(
		appearance,
		fade,
		position,
		renderData
	) {
		"use strict"


		return function( args ) {
			this.appearance = new appearance( {
				scale     : args.scale,
				textureId : args.textureId
			} )

			this.position = new position( args.position || [ 0, 0, 0 ] )

			this.renderData = new renderData( {
				pass    : 100, // "100" means render it in the last pass
				opacity : ( args.opacity !== undefined ? args.opacity : 1.0 )
			} )

			this.fade = new fade( args.fade )
		}
	}
)

define(
	"funkysnakes/shared/components/lobby/game",
	function() {
		"use strict"


		return function( args ) {
			this.id         = args.id
			this.hasChanged = true
			this.name       = args.name
			this.players    = []
			this.start      = false
		}
	}
)

define(
	"funkysnakes/shared/entities/lobby/game",
	[
		"funkysnakes/shared/components/lobby/game"
	],
	function(
		game
	) {
		"use strict"


		return function( args ) {
			this.game = new game( args )
		}
	}
)

define(
	"funkysnakes/client/entities/effect",
	[
		"spell/shared/components/sound/soundEmitter",
		"spell/client/components/network/synchronizationSlave"
	],
	function(
		soundEmitter,
		synchronizationSlave
	) {
		"use strict"


		return function( args ) {
			this.soundEmitter = new soundEmitter( {
				soundId: args.soundId
			} )

			this.synchronizationSlave = new synchronizationSlave( { id: args.networkId } )
		}
	}
)

define(
	"funkysnakes/client/entities",
	[
		"funkysnakes/client/entities/arena",
		"funkysnakes/client/entities/cloud",
		"funkysnakes/client/entities/gameStarter",
		"funkysnakes/client/entities/head",
		"funkysnakes/client/entities/invincibilityPowerup",
		"funkysnakes/client/entities/shieldPowerup",
		"funkysnakes/client/entities/player",
		"funkysnakes/client/entities/scoreDisplay",
		"funkysnakes/client/entities/speedPowerup",
		"funkysnakes/client/entities/background",
		"funkysnakes/client/entities/widget",
		"funkysnakes/client/entities/widgetThatFades",
		"funkysnakes/shared/entities/lobby/game",
		"funkysnakes/client/entities/effect"
	],
	function(
		arena,
		cloud,
		gameStarter,
		head,
		invincibilityPowerup,
		shieldPowerup,
		player,
		scoreDisplay,
		speedPowerup,
		background,
		widget,
		widgetThatFades,
		game,
		effect
	) {
		"use strict"


		return {
			"arena"               : arena,
			"cloud"               : cloud,
			"gameStarter"         : gameStarter,
			"head"                : head,
			"invincibilityPowerup": invincibilityPowerup,
			"shieldPowerup"       : shieldPowerup,
			"player"              : player,
			"scoreDisplay"        : scoreDisplay,
			"speedPowerup"        : speedPowerup,
			"background"          : background,
			"widget"              : widget,
			"widgetThatFades"  : widgetThatFades,

			"lobby/game"          : game,
			"effect"              : effect
		}
	}
)

define(
	"spell/shared/util/mathConstants",
	function(
	) {
		"use strict"


		return {
			PI2: Math.PI * 2
		}
	}
)

define(
	"funkysnakes/client/systems/shieldRenderer",
	[
		"funkysnakes/shared/config/constants",
		"spell/shared/util/mathConstants",

		"glmatrix/vec3",
		"underscore"
	],
	function(
		constants,
		mathConstants,

		vec3,
		_
	) {
		"use strict"


		function render(
			timeInMs,
			textures,
			context,
			shieldEntities
		) {
			var maxShieldLifetime = constants.shieldLifetime
			var timeInS = timeInMs / 1000
			var scaleMagnitude = 0.04
			var scaleFrequency = mathConstants.PI2 * 1.5

			_.each( shieldEntities, function( entity ) {
				var dynamicScaleFactor = 1 - scaleMagnitude + Math.cos( timeInS * scaleFrequency ) * scaleMagnitude
				var dynamicAlphaFactor = 1.0

				if( entity.shield.state === "activated" ) {
					var ageInSeconds = maxShieldLifetime - entity.shield.lifetime

					// ((x/-3) + 1) + (x/3) * (cos(x * 30) + 1) / 2
					dynamicAlphaFactor = ( ( ageInSeconds / -maxShieldLifetime ) + 1 ) + ( ageInSeconds / maxShieldLifetime ) * ( Math.cos ( ageInSeconds * 30 ) + 1 ) / 2
				}

				context.save()
				{
					var textureId = "effects/shield.png"
					var shieldTexture = textures[ textureId ]

					context.setGlobalAlpha( dynamicAlphaFactor )

					var orientation = entity.renderData.orientation

					context.translate( entity.renderData.position )

					context.scale( entity.appearance.scale )
					context.scale( [ dynamicScaleFactor, dynamicScaleFactor, 0 ] )
					context.rotate( orientation )
					context.translate( [ -39, -39, 0 ] )
					context.drawTexture( shieldTexture, 0, 0 )
				}
				context.restore()
			} )
		}


		return render
	}
)

define(
	"funkysnakes/client/systems/render",
	[
		"funkysnakes/client/systems/shieldRenderer",
		"funkysnakes/shared/config/constants",

		"glmatrix/vec3",
		"underscore"
	],
	function(
		shieldRenderer,
		constants,

		vec3,
		_
	) {
		"use strict"



		var createEntitiesSortedByPath = function( entitiesByPass ) {
			var passA, passB

			return _.toArray( entitiesByPass ).sort(
				function( a, b ) {
					passA = a[ 0 ].renderData.pass
					passB = b[ 0 ].renderData.pass

					return ( passA < passB ? -1 : ( passA > passB ? 1 : 0 ) )
				}
			)
		}

		var texture, shadowTexture, drewShields, shadowOffset, position
		texture       = null
		shadowTexture = null
		drewShields   = false
		shadowOffset  = vec3.create( [ 3, 2, 0 ] )
		position      = vec3.create( [ 0, 0, 0 ] )


		function render(
			timeInMs,
			deltaTimeInMs,
			textures,
			context,
			entitiesByPass,
			backgroundEntities,
			shieldEntities
		) {
			context.clear()

			drewShields   = false


			// draw background
			_.each(
				backgroundEntities,
				function( entity ) {
					context.save()
					{
						texture = textures[ entity.appearance.textureId ]

						context.translate( entity.position )
						context.drawTexture( texture, 0, 0 )
					}
					context.restore()
				}
			)

			_.each(
				createEntitiesSortedByPath( entitiesByPass ),
				function( entities ) {
					// draw shadows
					_.each(
						entities, function( entity ) {
							if( !entity.hasOwnProperty( "shadowCaster" ) ) return


							shadowTexture = textures[ entity.shadowCaster.textureId ]

							context.save()
							{
								context.setGlobalAlpha( 0.85 )

								vec3.reset( position )
								vec3.add( entity.renderData.position, shadowOffset, position )

								context.translate( position )

								context.rotate( entity.renderData.orientation )

								context.translate( entity.appearance.offset )

								context.drawTexture( shadowTexture, 0, 0 )
							}
							context.restore()
						}
					)

					// HACK: until animated appearances are supported shield rendering has to happen right before the "widget pass"
					if( !drewShields &&
						entities.length > 0 &&
						entities[ 0 ].renderData.pass === 100 ) {

						shieldRenderer( timeInMs, textures, context, shieldEntities )
						drewShields = true
					}

					// draw textures
					_.each(
						entities,
						function( entity ) {
							context.save()
							{
								texture = textures[ entity.appearance.textureId ]

								if( texture === undefined ) throw "The textureId '" + entity.appearance.textureId + "' could not be resolved."


								context.translate( entity.renderData.position )

								context.scale( entity.appearance.scale )
								context.rotate( entity.renderData.orientation )
								context.translate( entity.appearance.offset )

								if( entity.appearance.opacity !== 1.0 ||
									entity.renderData.opacity !== 1.0 ) {

									context.setGlobalAlpha( entity.appearance.opacity * entity.renderData.opacity )
								}

								context.drawTexture( texture, 0, 0 )
							}
							context.restore()
						}
					)
				}
			)
		}


		return render
	}
)

define(
	'spell/shared/util/random/XorShift32',
	function() {
		'use strict'


		var XorShift32 = function( seed ) {
			this.x = seed
		}

		XorShift32.prototype = {
			next : function() {
				var a = this.x,
					b = a

				a <<= 13
				b ^= a

				a >>= 17
				b ^= a

				a <<= 5
				b ^= a


				this.x = b

				return ( b + 2147483648 ) * ( 1 / 4294967296 )
			},
			nextBetween : function( min, max ) {
				return ( min + this.next() * ( max - min ) )
			}
		}

		return XorShift32
	}
)

define(
	"funkysnakes/client/util/createClouds",
	[
		"funkysnakes/shared/config/constants",

		"spell/shared/util/random/XorShift32",

		"glmatrix/vec3"
	],
	function(
		constants,

		XorShift32,

		vec3
	) {
		"use strict"


		var createClouds = function( entityManager, numberOfClouds, baseSpeed, type, pass ) {
			if( type !== "cloud_dark" &&
				type !== "cloud_light" ) {

				throw "Type '" + type + "' is not supported"
			}


			var prng = new XorShift32( 437840 )
			var scaleFactor = 1.0
			var tmp = [ 0, 0, 0 ]


			var fromX  = ( -constants.maxCloudTextureSize ) * scaleFactor
			var fromY  = ( -constants.maxCloudTextureSize ) * scaleFactor
			var untilX = ( constants.maxCloudTextureSize + constants.xSize ) * scaleFactor
			var untilY = ( constants.maxCloudTextureSize + constants.ySize ) * scaleFactor


			for( var i = 0; i < numberOfClouds; i++) {
				var position = [
					prng.nextBetween( fromX, untilX ),
					prng.nextBetween( fromY, untilY ),
					0
				]

				vec3.set( baseSpeed, tmp )
				vec3.scale( tmp, prng.nextBetween( 0.75, 1.0 ) * scaleFactor )

				var index = "_0" + ( 1 + ( i % 6 ) )

				entityManager.createEntity(
					"cloud",
					[ {
						scale     : [ scaleFactor, scaleFactor, 0 ],
						textureId : "environment/" + type + index + ".png",
						pass      : pass,
						speed     : tmp,
						position  : position
					} ]
				)
			}
		}


		return createClouds
	}
)

define(
	"funkysnakes/client/systems/animateClouds",
	[
		"funkysnakes/shared/config/constants",

		"spell/shared/util/math",

		"glmatrix/vec3",
		"underscore"
	],
	function(
		constants,

		math,

		vec3,
		_
	) {
		"use strict"


		var scaleFactor = 1.0
		var fromX  = ( -constants.maxCloudTextureSize ) * scaleFactor
		var fromY  = ( -constants.maxCloudTextureSize ) * scaleFactor
		var untilX = ( constants.maxCloudTextureSize + constants.xSize ) * scaleFactor
		var untilY = ( constants.maxCloudTextureSize + constants.ySize ) * scaleFactor

		var distanceCovered = vec3.create( [ 0, 0, 0 ] )


		var animateClouds = function(
			timeInMs,
			deltaTimeInMs,
			cloudEntities
		) {
			var deltaTimeInS = deltaTimeInMs / 1000

			_.each(
				cloudEntities,
				function( cloud ) {
					vec3.scale( cloud.cloud.speed, deltaTimeInS, distanceCovered )
					vec3.add( cloud.position, distanceCovered )

					if( cloud.position[ 0 ] > untilX ||
						cloud.position[ 0 ] < fromX ) {

						cloud.position[ 0 ] = ( cloud.cloud.speed[ 0 ] > 0 ? fromX : untilX )
					}

					if( cloud.position[ 1 ] > untilY ||
						cloud.position[ 1 ] < fromY ) {

						cloud.position[ 1 ] = ( cloud.cloud.speed[ 1 ] > 0 ? fromY : untilY )
					}
				}
			)
		}


		return animateClouds
	}
)

define(
	"funkysnakes/client/systems/applyPowerupEffects",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		return function(
			heads
		) {
			_.each( heads, function( head ) {
				if ( head.activePowerups.speed === true ) {
					head.appearance.textureId = head.powerupEffects.speedTextureId
				}
				else if ( head.activePowerups.invincibility === true ) {
					head.appearance.textureId = head.powerupEffects.invincibilityTextureId
				}
				else {
					head.appearance.textureId = head.powerupEffects.baseTextureId
				}
			} )
		}
	}
)

define(
	"funkysnakes/client/systems/fade",
	[
		"glmatrix/vec3",
		"underscore"
	],
	function(
		vec3,
		_
	) {
		"use strict"


		function fade(
			timeInMs,
			deltaTimeInMs,
			entityManager,
			fadeEntities
		) {
			_.each(
				fadeEntities,
				function( entity ) {
					var fade = entity.fade
					fade.age += deltaTimeInMs

					if( fade.age < fade.beginAfter ) return

					var delta = ( fade.age - fade.beginAfter ) / fade.duration

					if( delta > 1.0 ) {
						entity.renderData.opacity = fade.end
						entityManager.removeComponent( entity, 'fade' )

						return
					}

					entity.renderData.opacity = fade.start + delta * ( fade.end - fade.start )
				}
			)
		}

		return fade
	}
)

define(
	"funkysnakes/client/systems/interpolateNetworkData",
	[
		"funkysnakes/shared/config/constants",

		"spell/shared/util/network/snapshots",
		"spell/shared/util/math",

		"glmatrix/vec3",
		"underscore"
	],
	function(
		constants,

		snapshots,
		math,

		vec3,
		_
	) {
		"use strict"


		return function(
			timeInMilliseconds,
			entitiesToInterpolate,
			entityManager
		) {
			var renderTime = timeInMilliseconds - constants.interpolationDelay

			_.each( entitiesToInterpolate, function( entity ) {
				var entitySnapshots = entity.synchronizationSlave.snapshots

				snapshots.forwardTo( entitySnapshots, renderTime )
				var current = snapshots.current( entitySnapshots )
				var next    = snapshots.next( entitySnapshots )

				if( current !== undefined &&
					next !== undefined ) {

					var alpha = math.clamp( ( renderTime - current.time ) / ( next.time - current.time ), 0.0, 1.0 )

					if ( current.data.entity.hasOwnProperty( "position" ) ) {
						var beforePosition = current.data.entity[ "position" ]
						var afterPosition  = next.data.entity[ "position" ]
						var position       = [ 0, 0, 0 ]
						vec3.lerp( beforePosition, afterPosition, alpha, position )

						entityManager.addComponent( entity, "position", [ position ] )
					}

					if ( current.data.entity.hasOwnProperty( "orientation" ) ) {
						var beforeOrientation = current.data.entity[ "orientation" ].angle
						var afterOrientation  = next.data.entity[ "orientation" ].angle
						var orientation       = beforeOrientation + alpha * ( afterOrientation - beforeOrientation )

						entity.orientation.angle = orientation
					}

					if ( current.data.entity.hasOwnProperty( "collisionCircle" ) ) {
						entityManager.addComponent( entity, "collisionCircle", [ current.data.entity[ "collisionCircle" ].radius ] )
					}

					// shield
					if( current.data.entity.hasOwnProperty( "shield" ) ) {
						var lifetime

						if( next.data.entity.hasOwnProperty( "shield" ) ) {
							lifetime = current.data.entity.shield.lifetime +
								( next.data.entity.shield.lifetime - current.data.entity.shield.lifetime ) * alpha
						}

						entityManager.addComponent(
							entity,
							"shield",
							[ {
								state:    current.data.entity.shield.state,
								lifetime: lifetime
							} ]
						)
					}

					// handle removal of shield component
					if( !next.data.entity.hasOwnProperty( "shield" ) &&
						current.data.entity.hasOwnProperty( "shield" ) ) {

						entityManager.removeComponent( entity, "shield" )
					}

					// amountTailElements
					if( current.data.entity.hasOwnProperty( "amountTailElements" ) ) {
						entity.amountTailElements.value = current.data.entity.amountTailElements.value
					}

					entity.activePowerups = current.data.entity[ "activePowerups" ]

//					// tailElement
//					if( next.data.entity.hasOwnProperty( "tailElement" ) &&
//						!entity.hasOwnProperty( "tailElement" ) ) {
//
//						entityManager.addComponent(
//							entity,
//							"tailElement",
//							[ next.data.entity.tailElement ]
//						)
//					}

				} else if( current !== undefined ) {
					entityManager.addComponent( entity, "position", [ current.data.entity[ "position" ] ] )
					entity.orientation = current.data.entity[ "orientation" ]
					entity.activePowerups = current.data.entity[ "activePowerups" ]

				} else if( next !== undefined ) {
					entityManager.addComponent( entity, "position", [ next.data.entity[ "position" ] ] )
					entity.orientation = next.data.entity[ "orientation" ]
					entity.activePowerups = next.data.entity[ "activePowerups" ]

					// tailElement
					if( next.data.entity.hasOwnProperty( "tailElement" ) &&
						!entity.hasOwnProperty( "tailElement" ) ) {

						entityManager.addComponent(
							entity,
							"tailElement",
							[ next.data.entity.tailElement ]
						)
					}

				} else {
					// Remove position, effectively removing the entity from the world.
					entityManager.removeComponent( entity, "position" )
				}
			} )
		}
	}
)

define(
	"funkysnakes/client/systems/debugRenderer",
	[
		"funkysnakes/shared/config/constants",
		"spell/shared/util/color",

		"underscore"
	],
	function(
		constants,
		color,

		_
	) {
		"use strict"


		var magicPink = color.createRgb( 1, 0, 1 )
		var green     = color.createRgb( 0, 1, 0 )


		function render(
			timeInMs,
			deltaTimeInMs,
			renderingContext,
			entities
		) {
			_.each( entities, function( entity ) {
				renderingContext.setFillStyleColor( magicPink )

				// client
				var pastPositions = entity.body.pastPositions

				_.each( pastPositions, function( position ) {
					renderingContext.save()
					{
						renderingContext.translate( position )
						renderingContext.fillRect( -2, -2, 4, 4 )
					}
					renderingContext.restore()
				} )


//				// server
//				renderingContext.setFillStyleColor( green )
//
//				var pastPositions = entity.synchronizationSlave.snapshots[ 1 ].data.entity.body.pastPositions
//
//				_.each( pastPositions, function( position ) {
//					renderingContext.save()
//					{
//						renderingContext.translate( position )
//						renderingContext.fillRect( -2, -2, 4, 4 )
//					}
//					renderingContext.restore()
//				} )


//				if( entity.collisionCircle === undefined ) return
//
//
//				var position = entity.position
//				var collisionCircleRadius = entity.collisionCircle.radius
//
//				context.save()
//				{
//					context.beginPath()
//					context.arc( position[0], position[1], collisionCircleRadius, 0, Math.PI * 2, true )
//					context.stroke()
//				}
//				context.restore()
			} )
		}


		return render
	}
)

define(
	"funkysnakes/client/systems/renderPerformanceGraph",
	[
		"funkysnakes/shared/config/constants",
		"spell/shared/util/math",

		"underscore"
	],
	function(
		constants,
		math,

		_
	) {
		"use strict"


		/**
		 * private
		 */

		var sizeX, sizeY, maxFps, valueWidth, startTime, displayPeriodInS
		sizeX            = 1024
		sizeY            = 50
		maxFps           = 100
		valueWidth       = 2
		displayPeriodInS = 5


		var drawGraph = function( renderingContext, config ) {
			renderingContext.save()
			{
				renderingContext.translate( config.position )

				renderingContext.setFillStyleColor( [ 0.0, 0.0, 0.0 ] )
				renderingContext.fillRect( 0, 0, config.size[ 0 ], config.size[ 1 ] )

				// draw series
				_.each(
					config.series,
					function( series ) {
						renderingContext.setFillStyleColor( series.color )
						drawBuffer( renderingContext, series.values, config.maxValue, config.size[ 1 ] )
					}
				)

				// draw tick lines
				_.each(
					config.tickLines,
					function( tickLine ) {
						drawTickLine( renderingContext, config.maxValue, config.size[ 0 ], config.size[ 1 ], tickLine.color, tickLine.y )
					}
				)

//				drawSecondMarkers( renderingContext, config.size[ 0 ], config.size[ 1 ], displayPeriodInS )
			}
			renderingContext.restore()
		}


		var drawBuffer = function( renderingContext, buffer, maxValue, sizeY ) {
			var positionX, positionY, valueHeight
			positionX = 0
			positionY = sizeY

			_.each(
				buffer,
				function( value ) {
					positionX   += valueWidth
					valueHeight = Math.round( math.clamp( value / maxValue * sizeY, 0, sizeY ) )

					renderingContext.fillRect(
						positionX,
						positionY - valueHeight,
						valueWidth,
						valueHeight
					)
				}
			)
		}


		var drawTickLine = function( renderingContext, maxValue, sizeX, sizeY, color, y ) {
			var positionY = Math.floor( ( 1 - y / maxValue ) * sizeY )

			renderingContext.setFillStyleColor( color )
			renderingContext.fillRect( 0, positionY, sizeX, 1 )
		}


//		var drawSecondMarkers = function( renderingContext, sizeX, sizeY, displayPeriodInS ) {
//			var numberOfMarks = Math.max( Math.floor( displayPeriodInS ) - 1, 0 )
//
//			if( numberOfMarks === 0 ) return
//
//			for( var i = 1; i <= numberOfMarks; i++ ) {
//				var positionX = Math.round( sizeX / ( numberOfMarks + 1 ) * i )
//
//				renderingContext.setFillStyleColor( [ 0.5, 0.5, 0.5 ] )
//				renderingContext.fillRect( positionX, 0, 1, sizeY )
//			}
//		}


		/**
		 * public
		 */

		var render = function(
			timeInMs,
			deltaTimeInMs,
			seriesValues,
			renderingContext
		) {
//			// draw FPS graph
//			drawGraph(
//				renderingContext,
//				{
//					position  : [ 0, 0 ],
//					size      : [ sizeX, sizeY ],
//					maxValue  : maxFps,
//					tickLines : [
//						{
//							y : 30,
//							color : [ 0.5, 0.5, 0.5 ]
//						},
//						{
//							y : 60,
//							color : [ 1.0, 0.5, 0.5 ]
//						}
//					],
//					series : [
//						{
//							name   : 'FPS',
//							color  : [ 0.25, 0.35, 0.75 ],
//							values : seriesValues.fps.values
//						}
//					]
//				}
//			)
//
//			// total time spent rendering graph
//			drawGraph(
//				renderingContext,
//				{
//					position  : [ 0, sizeY + 2 ],
//					size      : [ sizeX, sizeY ],
//					maxValue  : 40,
//					tickLines : [
//						{
//							y : 10,
//							color : [ 0.5, 0.5, 0.5 ]
//						},
//						{
//							y : 20,
//							color : [ 0.66, 0.66, 0.66 ]
//						},
//						{
//							y : 30,
//							color : [ 0.5, 0.5, 0.5 ]
//						}
//					],
//					series : [
//						{
//							name   : 'total time spent',
//							color  : [ 0.72, 0.44, 0.32 ],
//							values : seriesValues.totalTimeSpent.values
//						},
//						{
//							name   : 'time spent rendering',
//							color  : [ 0.25, 0.72, 0.32 ],
//							values : seriesValues.timeSpentRendering.values
//						}
//					]
//				}
//			)

//			// draw ping graph
//			drawGraph(
//				renderingContext,
//				{
//					position  : [ 0, constants.ySize - sizeY ],
//					size      : [ sizeX, sizeY ],
//					maxValue  : 150,
//					tickLines : [
//						{
//							y : 50,
//							color : [ 0.5, 0.5, 0.5 ]
//						},
//						{
//							y : 100,
//							color : [ 0.5, 0.5, 0.5 ]
//						}
//					],
//					series : [
//						{
//							name   : 'Ping',
//							color  : [ 0.25, 0.35, 0.75 ],
//							values : seriesValues.ping.values
//						}
//					]
//				}
//			)


//			// draw relativeClockSkew graph
//			drawGraph(
//				renderingContext,
//				{
//					position  : [ 0, constants.ySize - sizeY ],
//					size      : [ sizeX, sizeY ],
//					maxValue  : 2,
//					tickLines : [
//						{
//							y : 1,
//							color : [ 0.5, 0.5, 0.5 ]
//						}
//					],
//					series : [
//						{
//							name   : 'relativeClockSpeed',
//							color  : [ 0.25, 0.35, 0.75 ],
//							values : seriesValues.relativeClockSkew.values
//						}
//					]
//				}
//			)


//			// draw localTime % 2000 graph
//			drawGraph(
//				renderingContext,
//				{
//					position  : [ 0, constants.ySize - ( sizeY + 2 ) * 3 ],
//					size      : [ sizeX, sizeY ],
//					maxValue  : 2000,
//					tickLines : [
//						{
//							y : 1000,
//							color : [ 0.5, 0.5, 0.5 ]
//						}
//					],
//					series : [
//						{
//							name   : 'localTime',
//							color  : [ 0.25, 0.85, 0.75 ],
//							values : seriesValues.localTime.values
//						}
//					]
//				}
//			)
//
//
//			// draw remoteTime % 2000 graph
//			drawGraph(
//				renderingContext,
//				{
//					position  : [ 0, constants.ySize - ( sizeY + 2 ) * 2 ],
//					size      : [ sizeX, sizeY ],
//					maxValue  : 2000,
//					tickLines : [
//						{
//							y : 1000,
//							color : [ 0.5, 0.5, 0.5 ]
//						}
//					],
//					series : [
//						{
//							name   : 'remoteTime',
//							color  : [ 0.91, 0.32, 0.17 ],
//							values : seriesValues.remoteTime.values
//						},
//						{
//							name   : 'newRemoteTimeTransfered',
//							color  : [ 1.0, 0.0, 0.0 ],
//							values : seriesValues.newRemoteTimeTransfered.values
//						}
//					]
//				}
//			)


			// draw received % 10000 graph
			drawGraph(
					renderingContext,
					{
						position  : [ 0, constants.ySize - sizeY ],
						size      : [ sizeX, sizeY ],
						maxValue  : 5000,
						tickLines : [
							{
								y : 1250,
								color : [ 0.5, 0.5, 0.5 ]
							},
							{
								y : 2500,
								color : [ 0.5, 0.5, 0.5 ]
							},
							{
								y : 3750,
								color : [ 0.5, 0.5, 0.5 ]
							}
						],
						series : [
							{
								name   : 'charsSent',
								color  : [ 0.0, 1.0, 0.0 ],
								values : seriesValues.charsSent.values
							},
							{
								name   : 'charsReceived',
								color  : [ 1.0, 0.0, 0.0 ],
								values : seriesValues.charsReceived.values
							}
						]
					}
			)


//			// draw relativeClockSkew graph
//			drawGraph(
//				renderingContext,
//				{
//					position  : [ 0, constants.ySize - ( sizeY + 2 ) * 4 ],
//					size      : [ sizeX, sizeY ],
//					maxValue  : 2,
//					tickLines : [
//						{
//							y : 1,
//							color : [ 0.5, 0.5, 0.5 ]
//						}
//					],
//					series : [
//						{
//							name   : 'relativeClockSkew',
//							color  : [ 0.91, 0.32, 0.17 ],
//							values : seriesValues.relativeClockSkew.values
//						}
//					]
//				}
//			)
//
//
//			// draw deltaLocalRemoteTime graph
//			drawGraph(
//				renderingContext,
//				{
//					position  : [ 0, constants.ySize - ( sizeY + 2 ) * 3 ],
//					size      : [ sizeX, sizeY ],
//					maxValue  : 500,
//					tickLines : [
//						{
//							y : 250,
//							color : [ 0.5, 0.5, 0.5 ]
//						}
//					],
//					series : [
//						{
//							name   : 'deltaLocalRemoteTime',
//							color  : [ 0.7, 0.35, 0.75 ],
//							values : seriesValues.deltaLocalRemoteTime.values
//						}
//					]
//				}
//			)
		}

		return render
	}
)

define(
	"funkysnakes/client/systems/sendInput",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		return function(
			connection,
			player
		) {
			var inputEvents = _.filter( player.inputReceiver.events, function( event ) {
				return event.sequenceNumber > player.inputReceiver.lastSentSeqNumber &&
					player.inputReceiver.lastSentEventTypeByAction[ event.action ] != event.type
			} )

			_.each( inputEvents, function( event ) {
				player.inputReceiver.lastSentEventTypeByAction[ event.action ] = event.type
			} )

			if ( inputEvents.length > 0 ) {
				player.inputReceiver.lastSentSeqNumber = _.last( inputEvents ).sequenceNumber
				connection.send( "input", inputEvents )
			}
		}
	}
)

define(
	"funkysnakes/client/systems/updateHoverAnimations",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		return function(
			timeInMs,
			hoverAnimations
		) {
			_.each( hoverAnimations, function( entity ) {
				var amplitude  = entity.hoverAnimation.amplitude
				var frequency  = entity.hoverAnimation.frequency
				var offsetInMs = entity.hoverAnimation.offsetInMs

				var yPositionOffset = Math.floor( Math.sin( ( timeInMs + offsetInMs ) * frequency ) * amplitude )

				entity.animation.positionOffset[ 1 ] = yPositionOffset
			} )
		}
	}
)

define(
	"funkysnakes/client/systems/updateRenderData",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		return function(
			entities
		) {
			_.each( entities, function( entity ) {
				entity.renderData.position = _.clone( entity.position )
				if ( entity.orientation ) {
					entity.renderData.orientation = entity.orientation.angle
				}
				else {
					entity.renderData.orientation = 0
				}
			} )
		}
	}
)

define(
	"funkysnakes/client/systems/updateScoreDisplays",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		return function( heads, scoreDisplays ) {
			_.each( heads, function( head ) {
				_.each( scoreDisplays, function( display ) {
					if ( head.body.id === display.scoreDisplay.playerId ) {
						display.text.value = "Apples: " + head.score.value
					}
				} )
			} )
		}
	}
)

define(
	"funkysnakes/shared/systems/integrateOrientation",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		return function(
			deltaTimeInS,
			entities
		) {
			_.each( entities, function( entity ) {
				entity.orientation.angle += entity.angularFrequency.radPerS * deltaTimeInS
			} )
		}
	}
)

define(
	"funkysnakes/shared/util/speedOf",
	[
		"funkysnakes/shared/config/constants",
		"spell/shared/util/math"
	],
	function(
		constants,
		math
	) {
		"use strict"


		return function( head ) {
			return math.clamp(
				constants.speedPerSecond + head.head.speedBonus - ( head.amountTailElements.value * 3 ),
				constants.minSpeedPerSecond,
				constants.maxSpeedPerSecond
			)
		}
	}
)

define(
	"funkysnakes/shared/systems/moveTailElements",
	[
		"funkysnakes/shared/config/constants",
		"funkysnakes/shared/util/speedOf",

		"glmatrix/vec3",

		"underscore"
	],
	function(
		constants,
		speedOf,

		vec3,

		_
	) {
		"use strict"


		var pastPositionsDistance = constants.pastPositionsDistance
		var tailElementDistance   = constants.tailElementDistance
		var distanceTailToShip    = constants.distanceTailToShip


		var updatePastPositions = function( head, dtInSeconds ) {
			head.body.distanceCoveredSinceLastSavedPosition += speedOf( head ) * dtInSeconds

			if( head.body.distanceCoveredSinceLastSavedPosition <= pastPositionsDistance ) return


			head.body.distanceCoveredSinceLastSavedPosition = 0

			head.body.pastPositions.unshift( vec3.create( head.position ) )

			var numberOfRequiredPastPositions =
				Math.ceil( ( ( head.amountTailElements.value + 1 ) * tailElementDistance + distanceTailToShip ) / pastPositionsDistance )

			while( head.body.pastPositions.length > numberOfRequiredPastPositions ) {
				head.body.pastPositions.pop()
			}
		}

		var updateTailElementPositions = function( tailElements, positionOfHead, pastPositions ) {
			var tailElementLength = _.size( tailElements )
			if( tailElementLength === 0 || pastPositions.length < 2 ) return


			var distanceToNextSearchedPosition = distanceTailToShip // absolute distance from the beginning of the tail
			var distanceCoveredInTail = 0 // absolute distance from the beginning of the tail
			var i = 0;
			var currentTailElementIndex = 0
			var currentPosition = positionOfHead
			var nextPosition = pastPositions[ i ]


			while(
				( i < pastPositions.length - 1 ) &&
				( currentTailElementIndex < tailElementLength )
			) {
				var delta = vec3.create()
				vec3.subtract( nextPosition, currentPosition, delta )

				var distanceBetweenPositions = vec3.length( delta )
				distanceCoveredInTail += distanceBetweenPositions

				// if this is false the searched position is even further back in the tail
				if( distanceCoveredInTail > distanceToNextSearchedPosition ) {
					// relative position between the two past positions
					var u = ( distanceCoveredInTail - distanceToNextSearchedPosition ) / distanceBetweenPositions
					var tailElement = tailElements[ currentTailElementIndex ]

					vec3.lerp(
						nextPosition,
						currentPosition,
						u,
						tailElement.position
					)

					distanceToNextSearchedPosition += tailElementDistance
					currentTailElementIndex++
				}

				i++
				currentPosition = pastPositions[ i ]
				nextPosition = pastPositions[ i + 1 ]
			}
		}


		return function(
			dtInSeconds,
			heads,
			tailElements
		) {
			_.each( heads, function( head ) {
				updatePastPositions( head, dtInSeconds )
				updateTailElementPositions( tailElements[ head.body.id ], head.position, head.body.pastPositions )
			} )
		}
	}
)

define(
	"spell/client/systems/sound/processSound",
	[
		"underscore",
        "spell/shared/components/sound/soundEmitter"
	],
	function(
		_,
		soundEmitterConstructor
	) {
		"use strict"

		var playing = {}

		return function(
			sounds, entities
		) {

			_.each( entities, function( entity ) {

				if( sounds[ entity.soundEmitter.soundId ] === undefined ) return

				var sound = _.clone(sounds[ entity.soundEmitter.soundId ])

				if( playing[ entity.id ] === undefined ) {

					if( entity.soundEmitter.onComplete === soundEmitterConstructor.ON_COMPLETE_LOOP ) {

						sound.setLoop()

					} else if( entity.soundEmitter.onComplete === soundEmitterConstructor.ON_COMPLETE_STOP ) {

					} else if( entity.soundEmitter.onComplete === soundEmitterConstructor.ON_COMPLETE_REMOVE_COMPONENT ) {
						sound.setOnCompleteRemove()
					}


					if( entity.soundEmitter.start !== false ) {
						sound.setStart( entity.soundEmitter.start )
					}

					if( entity.soundEmitter.stop !== false ) {
						sound.setStop( entity.soundEmitter.stop )
					}

					sound.setBackground( entity.soundEmitter.background )

					sound.setVolume( entity.soundEmitter.volume )

					sound.play();

					playing[ entity.id ] = true
				}

			} )
		}
	}
)

define(
	"spell/client/systems/input/processLocalInput",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		return function(
			timeInMs,
			inputEvents,
			inputDefinitions,
			inputReceivers
		) {
			_.each( inputEvents, function( event ) {
				_.each( inputDefinitions, function( definition ) {
					var action = _.find( definition.inputDefinition.actions, function( action ) {
						return action.key === event.keyCode
					} )

					if( !action ) return


					var type
					if( event.type === "keydown" ) {
						type = "start"

					} else if( event.type === "keyup" ) {
						type = "stop"
					}

					_.each( inputReceivers, function( receiver ) {
						if ( receiver.inputReceiver.inputId === definition.inputDefinition.inputId ) {
							receiver.inputReceiver.events.push( {
								type          : type,
								action        : action.action,
								sequenceNumber: event.sequenceNumber,
								time          : timeInMs
							} )
						}
					} )
				} )
			} )

			inputEvents.length = 0
		}
	}
)

define(
	"spell/client/systems/network/destroyEntities",
	[
		"spell/shared/util/network/snapshots",

		"underscore"
	],
	function(
		snapshots,

		_
	) {
		"use strict"


		return function(
			timeInMilliseconds,
			interpolationDelay,
			directlyUpdatedEntities,
			interpolatedEntities,
			entityManager
		) {
			_.each( directlyUpdatedEntities, function( entity ) {
				entityManager.destroyEntity( entity )
			} )

			_.each( interpolatedEntities, function( entity ) {
				var renderTime     = timeInMilliseconds - interpolationDelay
				var latestSnapshot = snapshots.latest( entity.synchronizationSlave.snapshots )

				if (
					latestSnapshot === undefined ||
					renderTime > latestSnapshot.time
				) {
					entityManager.destroyEntity( entity )
				}
			} )
		}
	}
)

define(
	"spell/client/systems/network/processEntityUpdates",
	[
		"spell/shared/util/network/snapshots",

		"underscore"
	],
	function(
		snapshots,

		_
	) {
		"use strict"


		return function(
			synchronizedEntities,
			entityManager,
			incomingMessages
		) {
			while ( incomingMessages.entityUpdate !== undefined && incomingMessages.entityUpdate.length > 0 ) {
				var entityUpdate = incomingMessages.entityUpdate.shift()

				_.each( entityUpdate.createdEntities, function( createdEntity ) {
					entityManager.createEntity( createdEntity.type, createdEntity.args )
				} )

				_.each( entityUpdate.destroyedEntities, function( entityId ) {
					var entityToDestroy = synchronizedEntities[ entityId ]
					entityManager.addComponent( entityToDestroy, "markedForDestruction" )
				} )

				_.each( entityUpdate.updatedEntities, function( entityGroup ) {
					_.each( entityGroup, function( updatedEntity ) {
						if ( !synchronizedEntities.hasOwnProperty( updatedEntity.id ) ) {
							throw "Unknown synchronized entity. Id: " +updatedEntity.id
						}

						var entity = synchronizedEntities[ updatedEntity.id ]
						delete updatedEntity.id

						var entitySnapshots = entity.synchronizationSlave.snapshots
						snapshots.add( entitySnapshots, entityUpdate.time, {
							lastProcessedInput: entityUpdate.lastProcessedInput,
							entity            : updatedEntity
						} )
					} )
				} )
			}
		}
	}
)

define(
	"spell/shared/systems/input/processInputEvents",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		return function( inputReceivers ) {
			_.each( inputReceivers, function( receiver ) {
				_.each( receiver.inputReceiver.events, function( event ) {
					receiver.inputReceiver.actions[ event.action ] = event.type === "start"
				} )
				receiver.inputReceiver.events.length = 0
			} )
		}
	}
)

define(
	"spell/shared/util/map",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		return {
			create: function( initialElements, listener ) {
				var map = {
					elements: {}
				}

				_.each( initialElements, function( element ) {
					var key   = element[ 0 ]
					var value = element[ 1 ]

					map.elements[ key ] = value
				} )

				if ( listener !== undefined ) {
					listener.onCreate( map )
				}

				return map
			},

			add: function( map, key, value, listener ) {
				var oldValue = map.elements[ key ]

				map.elements[ key ] = value

				if ( oldValue === undefined ) {
					if ( listener !== undefined ) {
						listener.onAdd( map, key, value )
					}
				}
				else {
					if ( listener !== undefined ) {
						listener.onUpdate( map, key, oldValue, value )
					}
				}
			},

			remove: function( map, key, listener ) {
				var entity = map.elements[ key ]
				if ( listener !== undefined && entity !== undefined ) {
					listener.onRemove( map, key, entity )
				}

				delete map.elements[ key ]
			}
		}
	}
)

define(
	"spell/shared/util/entities/Entities",
	[
		"spell/shared/util/map",

		"underscore"
	],
	function(
		map,

		_
	) {
		"use strict"


		function Entities() {
			this.entities = map.create()
			this.queries  = {}

			this.nextQueryId = 0
		}


		Entities.prototype = {
			add: function( entity ) {
				map.add( this.entities, entity.id, entity )

				_.each( this.queries, function( query ) {
					addIfHasAllComponents(
						query.entities,
						entity,
						query.componentTypes,
						query.dataStructure
					)
				} )
			},

			remove: function( entity ) {
				map.remove( this.entities, entity.id )

				_.each( this.queries, function( query ) {
					map.remove( query.entities, entity.id, query.dataStructure )
				} )
			},

			update: function( entity ) {
				_.each( this.queries, function( query ) {
					if ( hasAllComponents( entity, query.componentTypes ) ) {
						map.add( query.entities, entity.id, entity, query.dataStructure )
					}
					else {
						map.remove( query.entities, entity.id, query.dataStructure )
					}
				} )
			},

			prepareQuery: function( componentTypes, dataStructure ) {
				var queryId = getNextQueryId( this )

				var query = {
					componentTypes: componentTypes,
					entities      : map.create( [], dataStructure ),
					dataStructure : dataStructure
				}

				this.queries[ queryId ] = query

				_.each( this.entities.elements, function( entity ) {
					addIfHasAllComponents(
						query.entities,
						entity,
						query.componentTypes,
						dataStructure
					)
				} )

				return queryId
			},

			executeQuery: function( queryId ) {
				return this.queries[ queryId ].entities
			}
		}


		function getNextQueryId( self ) {
			var id = self.nextQueryId

			self.nextQueryId += 1

			return id
		}

		function addIfHasAllComponents(
			entityMap,
			entity,
			componentTypes,
			dataStructure
		) {
			if ( hasAllComponents( entity, componentTypes ) ) {
				map.add( entityMap, entity.id, entity, dataStructure )
			}
		}

		function hasAllComponents( entity, componentTypes ) {
			return _.all( componentTypes, function( componentType ) {
				return entity[ componentType ] !== undefined
			} )
		}


		return Entities
	}
)

define(
	"spell/shared/util/entities/datastructures/entityMap",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		/**
		 * A map that uses an arbitrary property of an entity as its key.
		 * This data structure should be used, if you need to efficiently access entities based on a specific property.
		 *
		 * Let's say, for example, that you have entities with a "profile" component. The profile component has a
		 * "name" property. If you need to access entities efficiently using their name, you can use this data
		 * structure to do it.
		 *
		 * First, initialize the data structure for your specific use case:
		 * var nameMap = entityMap( function( entity ) { return entity.profile.name } )
		 *
		 * When the nameMap is passed into your system later, you can use just access the entities within by their
		 * name:
		 * var entity = entities[ name ]
		 *
		 * Attention: Changing the property afterwards is not supported and will lead to unexpected results! A
		 * workaround for this is to remove the component from the entity and re-add it with the changed property.
		 */

		return function( keyAccessor ) {
			return {
				onCreate: function( map ) {
					map.entityMap = {}
				},
				onAdd: function( map, entityId, entity ) {
					var key = keyAccessor( entity )
					map.entityMap[ key ] = entity
				},
				onUpdate: function( map, entityId, originalEntity, updatedEntity ) {
					delete map.entityMap[ keyAccessor( originalEntity ) ]
					map.entityMap[ keyAccessor( updatedEntity ) ] = updatedEntity
				},
				onRemove: function( map, entityId, entityToRemove ) {
					var key = keyAccessor( entityToRemove )
					if ( key === undefined ) {
						// Key can no longer be retrieved from the entity. We have to rely on brute force.
						_.each( map.entityMap, function( entity, entityKey ) {
							if ( entity === entityToRemove ) {
								key = entityKey
							}
						} )
					}

					delete map.entityMap[ key ]
				}
			}
		}
	}
)

define(
	"spell/shared/util/entities/datastructures/multiMap",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		/**
		 * A multimap that uses an arbitrary property of an entity as its key.
		 * This data structure should be used, if you need to efficiently access groups of entities based on a specific
		 * property.
		 *
		 * Let's say, for example, that you have entities representing persons with a personalData component and want
		 * list those, grouping persons by their age.
		 *
		 * First, initialize the data structure for your specific use case:
		 * var ageMultiMap = multiMap( function( entity ) { return entity.personalData.age } )
		 *
		 * When the multi map is passed into your system later, you can access persons by their age:
		 * var arrayOfElevenYearOlds = entities[ 11 ]
		 *
		 * Attention: Changing the key property afterwards is not supported and will lead to unexpected results! A
		 * workaround for this is to remove the component from the entity and re-add it with the changed key property.
		 */

		return function( keyAccessor ) {
			return {
				onCreate: function( map ) {
					map.multiMap = {}
				},

				onAdd: function( map, key, entity ) {
					var entityKey = keyAccessor( entity )

					if ( !map.multiMap.hasOwnProperty( entityKey ) ) {
						map.multiMap[ entityKey ] = []
					}

					map.multiMap[ entityKey ].push( entity )
				},

				onUpdate: function( map, key, originalEntity, updatedEntity ) {
					this.onRemove( map, key, originalEntity )
					this.onAdd( map, key, updatedEntity )
				},

				onRemove: function( map, key, entityToRemove ) {
					var entityKey = keyAccessor( entityToRemove )

					if ( entityKey === undefined ) {
						_.each( map.multiMap, function( entities, theEntityKey ) {
							_.each( entities, function( entity ) {
								if ( entity === entityToRemove ) {
									entityKey = theEntityKey
								}
							} )
						} )
					}

					map.multiMap[ entityKey ] = map.multiMap[ entityKey ].filter( function( entityInMap ) {
						return entityInMap !== entityToRemove
					} )

					if ( map.multiMap[ entityKey ].length === 0 ) {
						delete map.multiMap[ entityKey ]
					}
				}
			}
		}
	}
)

define(
	"spell/shared/util/entities/datastructures/singleton",
	function() {
		"use strict"


		return {
			SINGLETON_ALREADY_EXISTS_ERROR: "There already is an instance of this singleton.",

			onCreate: function( map ) {
				map.singleton = null
			},

			onAdd: function( map, entityId, entity ) {
				if ( map.singleton === null ) {
					map.singleton = entity
				}
				else {
					throw this.SINGLETON_ALREADY_EXISTS_ERROR
				}
			},

			onUpdate: function( map, entityId, originalEntity, updatedEntity ) {
				this.onRemove( map, entityId, originalEntity )
				this.onAdd( map, entityId, updatedEntity )
			},

			onRemove: function( map, entityId, entity ) {
				map.singleton = null
			}
		}
	}
)

define(
	"spell/shared/util/entities/datastructures/sortedArray",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		/**
		 * An array of entities that are sorted by a specific criteria.
		 * This data structure should be used, if a system expects entities sorted according to a specific criteria.
		 *
		 * Let's say, for example, you need to draw entities, those with the lowest z-index first.
		 *
		 * First, initialize the data structure for your specific use case:
		 * var sortedZIndexArray = sortedArray( function( entityA, entityB ) {
		 *     return entityA.renderData.zIndex - entityB.renderData.zIndex
		 * } )
		 * The sorting function works exactly like the one taken by Array.prototype.sort.
		 *
		 * Attention: Changing the sorting criteria afterwards is not supported and will lead to unexpected results! A
		 * workaround for this is to remove the component from the entity and re-add it with the changed sorting
		 * criteria.
		 */

		return function( compareFunction ) {
			return {
				onCreate: function( map ) {
					map.sortedArray = []
				},

				onAdd: function( map, key, value  ) {
					map.sortedArray.push( value )
					map.sortedArray.sort( compareFunction )
				},

				onUpdate: function( map, key, originalValue, updatedValue ) {
					this.onRemove( map, key, originalValue )
					this.onAdd( map, key, updatedValue )
				},

				onRemove: function( map, key, value ) {
					var indexOfValue = _.indexOf( map.sortedArray, value )
					map.sortedArray.splice( indexOfValue, 1 )
				}
			}
		}
	}
)

define(
	"spell/shared/util/zones/ZoneEntityManager",
	function() {
		"use strict"


		function ZoneEntityManager( globalEntityManager, zoneEntities, listeners ) {
			this.globalEntityManager = globalEntityManager
			this.zoneEntities        = zoneEntities
			this.listeners           = listeners || []
		}


		ZoneEntityManager.prototype = {
			createEntity: function( entityType, args ) {
				var entity = this.globalEntityManager.createEntity.apply( this.globalEntityManager, arguments )
				this.zoneEntities.add( entity )
				this.listeners.forEach( function( listener ) { listener.onCreateEntity( entityType, args, entity ) } )
				return entity
			},

			destroyEntity: function( entity ) {
				this.zoneEntities.remove( entity )
				this.listeners.forEach( function( listener ) { listener.onDestroyEntity( entity ) } )
			},

			addComponent: function( entity, componentType ) {
				var doesNotHaveComponent = !entity.hasOwnProperty( componentType )

				this.globalEntityManager.addComponent.apply( this.globalEntityManager, arguments )

				if ( doesNotHaveComponent ) {
					this.zoneEntities.update( entity )
				}
			},

			removeComponent: function( entity, componentType ) {
				var doesHaveComponent = entity.hasOwnProperty( componentType )

				this.globalEntityManager.removeComponent.apply( this.globalEntityManager, arguments )

				if ( doesHaveComponent ) {
					this.zoneEntities.update( entity )
				}
			}
		}


		return ZoneEntityManager
	}
)

define(
	"funkysnakes/client/zones/game",
	[
		"funkysnakes/client/util/createClouds",
		"funkysnakes/client/systems/animateClouds",
		"funkysnakes/client/systems/applyPowerupEffects",
		"funkysnakes/client/systems/fade",
		"funkysnakes/client/systems/interpolateNetworkData",
		"funkysnakes/client/systems/render",
		"funkysnakes/client/systems/debugRenderer",
		"funkysnakes/client/systems/renderPerformanceGraph",
		"funkysnakes/client/systems/sendInput",
		"funkysnakes/client/systems/updateHoverAnimations",
		"funkysnakes/client/systems/updateRenderData",
		"funkysnakes/client/systems/updateScoreDisplays",
		"funkysnakes/shared/config/constants",
		"funkysnakes/shared/config/players",
		"funkysnakes/shared/systems/integrateOrientation",
		"funkysnakes/shared/systems/moveTailElements",

        "spell/client/systems/sound/processSound",
		"spell/client/systems/input/processLocalInput",
		"spell/client/systems/network/destroyEntities",
		"spell/client/systems/network/processEntityUpdates",
		"spell/shared/systems/input/processInputEvents",
		"spell/shared/util/entities/Entities",
		"spell/shared/util/entities/datastructures/entityMap",
		"spell/shared/util/entities/datastructures/multiMap",
		"spell/shared/util/entities/datastructures/singleton",
		"spell/shared/util/entities/datastructures/sortedArray",
		"spell/shared/util/zones/ZoneEntityManager",
		"spell/shared/util/platform/PlatformKit",
		"spell/shared/util/platform/Types"
	],
	function(
		createClouds,
		animateClouds,
		applyPowerupEffects,
		fade,
		interpolateNetworkData,
		render,
		debugRenderer,
		renderPerformanceGraph,
		sendInput,
		updateHoverAnimations,
		updateRenderData,
		updateScoreDisplays,
		constants,
		players,
		integrateOrientation,
		moveTailElements,

		processSound,
		processLocalInput,
		destroyEntities,
		processEntityUpdates,
		processInputEvents,
		Entities,
		entityMap,
		multiMap,
		singleton,
		sortedArray,
		ZoneEntityManager,
		PlatformKit,
		Types
	) {
		"use strict"


		function addPlatformLogo( entityManager, platform ) {
			var textureId

			if( platform === 'html5' ) {
				textureId = 'html5_logo_64x64.png'

			} else if( platform === 'flash' ) {
				textureId = 'flash_logo_64x64.png'
			}

			if( !textureId ) return

			entityManager.createEntity(
				"widget",
				[ {
					position  : [ 5, 10, 0 ],
					textureId : textureId
				} ]
			)
		}

		function addVirtualKeys( entityManager ) {
			var marginBottom = 25
			var positionY = 768 - 64 - marginBottom

			entityManager.createEntity(
				"widgetThatFades",
				[ {
					position  : [ 138, positionY, 0 ],
					textureId : 'arrow_left.png',
					opacity : 0.0,
					fade : {
						beginAfter : 3000,
						duration   : 250,
						start      : 0.0,
						end        : 1.0
					}
				} ]
			)

			entityManager.createEntity(
				"widgetThatFades",
				[ {
					position  : [ 384, positionY, 0 ],
					textureId : 'space.png',
					opacity : 0.0,
					fade : {
						beginAfter : 3000,
						duration   : 250,
						start      : 0.0,
						end        : 1.0
					}
				} ]
			)

			entityManager.createEntity(
				"widgetThatFades",
				[ {
					position  : [ 822, positionY, 0 ],
					textureId : 'arrow_right.png',
					opacity : 0.0,
					fade : {
						beginAfter : 3000,
						duration   : 250,
						start      : 0.0,
						end        : 1.0
					}
				} ]
			)
		}


		var timeStampInMs, newTimeStampInMs, timeSpentInMs
		timeStampInMs = 0
		newTimeStampInMs = 0
		timeSpentInMs = 0

		function updateZone(
			timeInMs,
			dtInS,
			globals
		) {
			var entities      = this.entities
			var entityManager = this.entityManager
			var queryIds      = this.queryIds

			var connection  = globals.connection
			var inputEvents = globals.inputEvents
		}

		function renderZone(
			timeInMs,
			deltaTimeInMs,
			globals
		) {
			var entities      = this.entities
			var entityManager = this.entityManager
			var queryIds      = this.queryIds

			var connection        = globals.connection
			var renderingContext  = globals.renderingContext
			var textures          = globals.textures
			var inputEvents       = globals.inputEvents
			var statisticsManager = globals.statisticsManager
			var sounds            = globals.sounds

			statisticsManager.startTick()

			processLocalInput(
				timeInMs,
				inputEvents,
				entities.executeQuery( queryIds[ "processLocalInput" ][ 0 ] ).elements,
				entities.executeQuery( queryIds[ "processLocalInput" ][ 1 ] ).elements
			)
			sendInput(
				connection,
				entities.executeQuery( queryIds[ "sendInput" ][ 0 ] ).singleton
			)
			processInputEvents(
				entities.executeQuery( queryIds[ "processInputEvents" ][ 0 ] ).elements
			)
			processEntityUpdates(
				entities.executeQuery( queryIds[ "processEntityUpdates" ][ 0 ] ).entityMap,
				entityManager,
				connection.messages
			)
			interpolateNetworkData(
				timeInMs,
				entities.executeQuery( queryIds[ "interpolateNetworkData" ][ 0 ] ).elements,
				entityManager
			)
			moveTailElements(
				deltaTimeInMs / 1000,
				entities.executeQuery( queryIds[ "moveTailElements" ][ 0 ] ).elements,
				entities.executeQuery( queryIds[ "moveTailElements" ][ 1 ] ).multiMap
			)
			updateScoreDisplays(
				entities.executeQuery( queryIds[ "updateScoreDisplays" ][ 0 ] ).elements,
				entities.executeQuery( queryIds[ "updateScoreDisplays" ][ 1 ] ).elements
			)
			destroyEntities(
				timeInMs,
				constants.interpolationDelay,
				entities.executeQuery( queryIds[ "destroyEntities" ][ 0 ] ).elements,
				entities.executeQuery( queryIds[ "destroyEntities" ][ 1 ] ).elements,
				entityManager
			)
			integrateOrientation(
				deltaTimeInMs / 1000,
				entities.executeQuery( queryIds[ "integrateOrientation" ][ 0 ] ).elements
			)
			animateClouds(
				timeInMs,
				deltaTimeInMs,
				entities.executeQuery( queryIds[ "clouds" ][ 0 ] ).elements
			)
			updateRenderData(
				entities.executeQuery( queryIds[ "updateRenderData" ][ 0 ] ).elements
			)
			applyPowerupEffects(
				entities.executeQuery( queryIds[ "applyPowerupEffects" ][ 0 ] ).elements
			)
			fade(
				timeInMs,
				deltaTimeInMs,
				entityManager,
				entities.executeQuery( queryIds[ "fade" ][ 0 ] ).elements
			)
			processSound(
				sounds,
				entities.executeQuery( queryIds[ "soundEmitters" ][ 0 ] ).elements
			)

			var timeA = Types.Time.getCurrentInMs()

			render(
				timeInMs,
				deltaTimeInMs,
				textures,
				renderingContext,
				entities.executeQuery( queryIds[ "render" ][ 0 ] ).multiMap,
				entities.executeQuery( queryIds[ "render" ][ 1 ] ).elements,
				entities.executeQuery( queryIds[ "shieldRenderer" ][ 0 ] ).elements
			)

			statisticsManager.updateSeries( 'timeSpentRendering', Types.Time.getCurrentInMs() - timeA )

//			debugRenderer(
//				timeInMs,
//				deltaTimeInMs,
//				renderingContext,
//				entities.executeQuery( queryIds[ "debugRenderer" ][ 0 ] ).elements
//			)


			newTimeStampInMs = timeInMs
			timeSpentInMs = newTimeStampInMs - timeStampInMs
			timeStampInMs = newTimeStampInMs

			statisticsManager.updateSeries( 'fps', 1000 / timeSpentInMs )
			statisticsManager.updateSeries( 'totalTimeSpent', timeSpentInMs )


//			renderPerformanceGraph(
//				timeInMs,
//				deltaTimeInMs,
//				statisticsManager.getValues(),
//				renderingContext
//			)
		}

		return {
			onCreate: function( globals ) {
				this.update = updateZone
				this.render = renderZone

				this.entities      = new Entities()
				this.entityManager = new ZoneEntityManager( globals.entityManager, this.entities )

				var thisZone      = this
				var entities      = this.entities
				var entityManager = this.entityManager
				var eventManager  = globals.eventManager
				var inputManager  = globals.inputManager

				inputManager.init()


				entityManager.createEntity( "player", [ "player", players[ 0 ].leftKey, players[ 0 ].rightKey, players[ 0 ].useKey ] )

				entityManager.createEntity(
					"background",
					[ {
						textureId : "environment/ground.jpg"
					} ]
				)


				// add clouds
				createClouds(
					entityManager,
					35,
					[ 16, 14, 0 ],
					"cloud_dark",
					1
				)

				createClouds(
					entityManager,
					25,
					[ 24, 18, 0 ],
					"cloud_light",
					2
				)


				addPlatformLogo( entityManager, globals.configurationManager.platform )


				entityManager.createEntity(
					"widgetThatFades",
					[ {
						position  : [ 256, 256, 0 ],
						textureId : 'help_controls.png',
						fade : {
							beginAfter : 2500,
							duration   : 500,
							start      : 1.0,
							end        : 0.0
						}
					} ]
				)

				if( PlatformKit.features.touch ) {
					addVirtualKeys( entityManager, true )
				}


				entityManager.createEntity( "arena" )


				var synchronizationIdMap = entityMap( function( entity ) {
					return entity.synchronizationSlave.id
				} )

				var passIdMultiMap = multiMap(
					function( entity ) {
						return entity.renderData.pass
					}
				)

				var bodyIdMultiMap = multiMap( function( entity ) {
					if ( entity.hasOwnProperty( "tailElement" ) ) {
						return entity.tailElement.bodyId
					}
					else {
						return undefined
					}
				} )

				this.queryIds = {
					processLocalInput: [
						entities.prepareQuery( [ "inputDefinition" ] ),
						entities.prepareQuery( [ "inputReceiver"   ] )
					],
					processInputEvents: [
						entities.prepareQuery( [ "inputReceiver" ] )
					],
					sendInput: [
						entities.prepareQuery( [ "inputReceiver", "player" ], singleton )
					],
					processEntityUpdates: [
						entities.prepareQuery( [ "synchronizationSlave" ], synchronizationIdMap )
					],
					interpolateNetworkData: [
						entities.prepareQuery( [ "networkInterpolation" ] )
					],
					updateScoreDisplays: [
						entities.prepareQuery( [ "head" ] ),
						entities.prepareQuery( [ "scoreDisplay" ] )
					],
					destroyEntities: [
						entities.prepareQuery( [ "directUpdate"        , "markedForDestruction" ] ),
						entities.prepareQuery( [ "networkInterpolation", "markedForDestruction" ] )
					],
					integrateOrientation: [
						entities.prepareQuery( [ "angularFrequency", "orientation" ] )
					],
					moveTailElements: [
						entities.prepareQuery( [ "head", "active" ]                 ),
						entities.prepareQuery( [ "tailElement"    ], bodyIdMultiMap )
					],
					updateRenderData: [
						entities.prepareQuery( [ "position", "renderData" ] )
					],
					clouds: [
						entities.prepareQuery( [ "cloud" ] )
					],
					fade: [
						entities.prepareQuery( [ "fade" ] )
					],
					render: [
						entities.prepareQuery( [ "position", "appearance", "renderData" ], passIdMultiMap ),
						entities.prepareQuery( [ "background" ] )
					],
					shieldRenderer: [
						entities.prepareQuery( [ "shield" ] )
					],
//					debugRenderer: [
//						entities.prepareQuery( [ "head", "active" ] )
//					],
					applyPowerupEffects: [
						entities.prepareQuery( [ "appearance", "powerupEffects" ] )
					],
					soundEmitters: [
						entities.prepareQuery( [ "soundEmitter" ] )
					]
				}


				this.renderUpdate = function( timeInMs, deltaTimeInMs ) {
					thisZone.render( timeInMs, deltaTimeInMs, globals )
				}

				this.logicUpdate = function( timeInMs, deltaTimeInS ) {
					thisZone.update( timeInMs, deltaTimeInS, globals )
				}

				eventManager.subscribe( [ "renderUpdate" ], this.renderUpdate )
				eventManager.subscribe( [ "logicUpdate", "20" ], this.logicUpdate )
			},

			onDestroy: function( globals ) {
				var eventManager = globals.eventManager
				var inputManager = globals.inputManager

				inputManager.cleanUp()

				eventManager.unsubscribe( [ "renderUpdate" ], this.renderUpdate )
				eventManager.unsubscribe( [ "logicUpdate", "20" ], this.logicUpdate )
			}
		}
	}
)

define(
	"funkysnakes/client/systems/lobby/receiveGameData",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		return function(
			games,
			incomingMessages,
			entityManager
		) {
			while ( incomingMessages.gameData !== undefined && incomingMessages.gameData.length > 0 ) {
				var currentData = incomingMessages.gameData.pop()
				incomingMessages.gameData.length = 0

				var receivedGames = {}

				_.each( currentData, function( gameComponent ) {
					var name = gameComponent.name
					var game = games[ name ]

					if ( game === undefined ) {
						game = entityManager.createEntity( "lobby/game", [ { name: name } ] )
					}

					game.game = gameComponent
					game.game.hasChanged = true

					receivedGames[ name ] = true
				} )

				_.each( games, function( game ) {
					if ( receivedGames[ game.game.name ] !== true ) {
						entityManager.destroyEntity( game )
					}
				} )
			}
		}
	}
)

define(
	"funkysnakes/client/systems/lobby/updateGameData",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		return function(
			lobby,
			games
		) {
			var numberOfGames = _.size( games )

			if( numberOfGames > 0 ) {
				var gamesHaveChanged = _.any(
					games,
					function( game ) {
						return ( game.game.hasChanged === true )
					}
				)

				if( gamesHaveChanged === false ) return
			}

			lobby.setNoGamesOptionVisibility( numberOfGames === 0 )
			lobby.refreshGameList( games )
		}
	}
)

define(
	"funkysnakes/client/zones/lobby",
	[
		"funkysnakes/client/systems/render",
		"funkysnakes/client/systems/lobby/receiveGameData",
		"funkysnakes/client/systems/lobby/updateGameData",

		"spell/client/systems/input/processLocalInput",
		"spell/shared/systems/input/processInputEvents",
		"spell/shared/util/entities/Entities",
		"spell/shared/util/entities/datastructures/entityMap",
		"spell/shared/util/zones/ZoneEntityManager",
		"spell/shared/util/platform/PlatformKit"
	],
	function(
		render,
		receiveGameData,
		updateGameData,

		processLocalInput,
		processInputEvents,
		Entities,
		entityMap,
		ZoneEntityManager,
		PlatformKit
	) {
		"use strict"


		function updateZone(
			timeInMs,
			deltaTimeInS,
			globals
		) {
			var entities      = this.entities
			var entityManager = this.entityManager
			var queryIds      = this.queryIds

			var connection  = globals.connection

			receiveGameData(
				entities.executeQuery( queryIds[ "receiveGameData" ][ 0 ] ).entityMap,
				connection.messages,
				entityManager
			)
			updateGameData(
				this.lobby,
				entities.executeQuery( queryIds[ "updateGameData" ][ 0 ] ).entityMap
			)
		}


		return {
			onCreate: function( globals ) {
				this.update = updateZone
				this.render = function() {}

				this.entities      = new Entities()
				this.entityManager = new ZoneEntityManager( globals.entityManager, this.entities )

				var thisZone      = this
				var entities      = this.entities
				var entityManager = this.entityManager
				var connection    = globals.connection
				var eventManager  = globals.eventManager

				this.lobby = PlatformKit.createLobby( eventManager, connection )
				this.lobby.init()

				entityManager.createEntity( "gameStarter" )


				var gameNameMap = entityMap( function( entity ) {
					return entity.game.name
				} )

				this.queryIds = {
					receiveGameData: [
						entities.prepareQuery( [ "game" ], gameNameMap )
					],
					updateGameData: [
						entities.prepareQuery( [ "game" ], gameNameMap )
					]
				}


				this.lobby.setVisible( true )

				this.logicUpdate = function( timeInMs, deltaTimeInS ) {
					thisZone.update(
						timeInMs,
						deltaTimeInS,
						globals
					)
				}

				eventManager.subscribe( [ "logicUpdate", "20" ], this.logicUpdate )
			},

			onDestroy: function( globals ) {
				var eventManager = globals.eventManager

				eventManager.unsubscribe( [ "logicUpdate", "20" ], this.logicUpdate )

				this.lobby.setVisible( false )
			}
		}
	}
)

define(
	"spell/shared/util/Timer",
	[
		"spell/shared/util/platform/Types",

		"underscore"
	],
	function(
		Types,

		_
	) {
		"use strict"


		/**
		 * private
		 */

//		var checkTimeWarp = function( newRemoteTime, updatedRemoteTime ) {
//			if( updatedRemoteTime > newRemoteTime ) return
//
//			var tmp = newRemoteTime - updatedRemoteTime
//			console.log( 'WARNING: clock reset into past by ' + tmp + ' ms' )
//		}


		/**
		 * public
		 */

		function Timer( eventManager, statisticsManager, initialTime ) {
			this.newRemoteTime        = initialTime
			this.remoteTime           = initialTime
			this.newRemoteTimPending  = false
			this.localTime            = initialTime
			this.previousSystemTime   = Types.Time.getCurrentInMs()
			this.elapsedTime          = 0
			this.deltaLocalRemoteTime = 0
			this.statisticsManager    = statisticsManager

			eventManager.subscribe(
				[ "clockSyncUpdate" ],
				_.bind(
					function( updatedRemoteTime ) {
//						checkTimeWarp( newRemoteTime, updatedRemoteTime )

						this.newRemoteTime = updatedRemoteTime
						this.newRemoteTimPending = true
					},
					this
				)
			)

			// setting up statistics
			statisticsManager.addSeries( 'remoteTime', '' )
			statisticsManager.addSeries( 'localTime', '' )
			statisticsManager.addSeries( 'deltaLocalRemoteTime', '' )
			statisticsManager.addSeries( 'relativeClockSkew', '' )
			statisticsManager.addSeries( 'newRemoteTimeTransfered', '' )
		}

		Timer.prototype = {
			update : function() {
				// TODO: think about incorporating the new value "softly" instead of directly replacing the old one
				if( this.newRemoteTimPending ) {
					this.remoteTime          = this.newRemoteTime
					this.newRemoteTimPending = false
				}

				// measuring time
				var systemTime            = Types.Time.getCurrentInMs()
				this.elapsedTime          = Math.max( systemTime - this.previousSystemTime, 0 ) // it must never be smaller than 0
				this.previousSystemTime   = systemTime

				this.localTime            += this.elapsedTime
				this.remoteTime           += this.elapsedTime
				this.deltaLocalRemoteTime = this.localTime - this.remoteTime

				// relative clock skew
				var factor = 1000000000
				this.relativeClockSkew = ( ( this.localTime / this.remoteTime * factor ) - factor ) * 2 + 1

				// updating statistics
				this.statisticsManager.updateSeries( 'remoteTime', this.remoteTime % 2000 )
				this.statisticsManager.updateSeries( 'localTime', this.localTime % 2000 )
				this.statisticsManager.updateSeries( 'deltaLocalRemoteTime', this.deltaLocalRemoteTime + 250 )
				this.statisticsManager.updateSeries( 'relativeClockSkew', this.relativeClockSkew )
			},
			getLocalTime : function() {
				return this.localTime
			},
			getElapsedTime : function() {
				return this.elapsedTime
			},
			getRemoteTime : function() {
				return this.remoteTime
			}//,
//			getDeltaLocalRemoteTime : function() {
//				return deltaRemoteLocalTime
//			},
//			getRelativeClockSkew : function() {
//				return relativeClockSkew
//			}
		}

		return Timer
	}
)

define(
	"funkysnakes/shared/util/createMainLoop",
	[
		"spell/shared/util/Timer",
		"spell/shared/util/platform/Types",
		"spell/shared/util/platform/PlatformKit",

		"underscore"
	],
	function(
		Timer,
		Types,
		PlatformKit,

		_
	) {
		"use strict"


		var allowedDeltaInMs = 20


		return function(
			eventManager,
			statisticsManager,
			initialRemoteGameTimeInMs
		) {
			var timer         = new Timer( eventManager, statisticsManager, initialRemoteGameTimeInMs )
			var localTimeInMs = initialRemoteGameTimeInMs


			// Since the main loop supports arbitrary update intervals but can't publish events for every possible
			// update interval, we need to maintain a set of all update intervals that subscribers are interested in.
			var updateIntervals = {}

			eventManager.subscribe(
				[ "subscribe" ],
				function( scope, subscriber ) {
					if( scope[ 0 ] !== "logicUpdate" ) return

					var interval = scope[ 1 ]

					if( updateIntervals.hasOwnProperty( interval ) ) return

					updateIntervals[ interval ] = {
						accumulatedTimeInMs : 0,
						localTimeInMs       : localTimeInMs
					}
				}
			)

			var clockSpeedFactor, elapsedTimeInMs
			clockSpeedFactor = 1.0

			var mainLoop = function() {
				timer.update()
				localTimeInMs   = timer.getLocalTime()
				elapsedTimeInMs = timer.getElapsedTime()

				_.each(
					updateIntervals,
					function( updateInterval, deltaTimeInMsAsString ) {
						var deltaTimeInMs = parseInt( deltaTimeInMsAsString )

						updateInterval.accumulatedTimeInMs += elapsedTimeInMs * clockSpeedFactor

						while( updateInterval.accumulatedTimeInMs > deltaTimeInMs ) {
							// Only simulate, if not too much time has accumulated to prevent CPU overload. This can happen, if
							// the browser tab has been in the background for a while and requestAnimationFrame is used.
							if( updateInterval.accumulatedTimeInMs <= 5 * deltaTimeInMs ) {
								eventManager.publish(
									[ "logicUpdate", deltaTimeInMsAsString ],
									[ updateInterval.localTimeInMs, deltaTimeInMs / 1000 ]
								)
							}

							updateInterval.accumulatedTimeInMs -= deltaTimeInMs
							updateInterval.localTimeInMs   += deltaTimeInMs
						}
					}
				)


				eventManager.publish( [ "renderUpdate" ], [ localTimeInMs, elapsedTimeInMs ] )


//				var localGameTimeDeltaInMs = timer.getRemoteTime() - localTimeInMs
//
//				if( Math.abs( localGameTimeDeltaInMs ) > allowedDeltaInMs ) {
//					if( localGameTimeDeltaInMs > 0 ) {
//						clockSpeedFactor = 1.25
//
//					} else {
//						clockSpeedFactor = 0.25
//					}
//
//				} else {
//					clockSpeedFactor = 1.0
//				}

				PlatformKit.callNextFrame( mainLoop )
			}

			return mainLoop
		}
	}
)

define(
	"funkysnakes/shared/components/collisionCircle",
	function() {
		"use strict"


		return function( radius ) {
			this.radius = radius
		}
	}
)

define(
	"funkysnakes/shared/components/shield",
	[
		"funkysnakes/shared/config/constants"
	],
	function(
		constants
	) {
		"use strict"


		return function( args ) {
			this.state = args.state
			this.lifetime = args.lifetime || constants.shieldLifetime // in seconds
		}
	}
)

define(
	"funkysnakes/shared/components/tailElement",
	function() {
		"use strict"


		return function( args ) {
			this.bodyId         = args.bodyId
			this.positionInTail = args.positionInTail
		}
	}
)

define(
	"funkysnakes/shared/util/networkProtocol",
	[
		"spell/shared/util/platform/PlatformKit",

		"underscore"
	],
	function(
		PlatformKit,

		_
	) {
		"use strict"


		var jsonCoder = PlatformKit.getJsonCoder()

		return {
			encode: function( messageType, messageData ) {
				var message = {
					type : messageType,
					data : messageData
				}

				return jsonCoder.encode( message )
			},

			decode: function( encodedMessage ) {
				var message = jsonCoder.decode( encodedMessage )

				if( message.type === "entityUpdate" ) {
					_.each(
						message.data.updatedEntities,
						function( entityGroup, index ) {
							message.data.updatedEntities[ index ] = entityGroup
						}
					)
				}

				return message
			}
		}
	}
)

define(
	"spell/client/components/network/markedForDestruction",
	function() {
		"use strict"


		return function() {}
	}
)

define(
	"spell/shared/util/create",
	function() {
		"use strict"


		var create = function( constructor, args ) {
			if ( constructor.prototype === undefined ) {
				throw create.NO_CONSTRUCTOR_ERROR + constructor
			}

			var object = {}
			object.prototype = constructor.prototype
			var returnedObject = constructor.apply( object, args )
			return returnedObject || object
		}


		create.NO_CONSTRUCTOR_ERROR = "The first argument for create must be a constructor. You passed in "


		return create
	}
)

define(
	"spell/shared/util/entities/EntityManager",
	[
		"spell/shared/util/create"
	],
	function(
		create
	) {
		"use strict"


		var EntityManager = function( entityConstructors, componentConstructors ) {
			this.entityConstructors    = entityConstructors
			this.componentConstructors = componentConstructors

			this.nextId = 0
		}


		EntityManager.COMPONENT_TYPE_NOT_KNOWN = "The type of component you tried to add is not known. Component type: "
		EntityManager.ENTITY_TYPE_NOT_KNOWN    = "The type of entity you tried to create is not known. Entity type: "


		EntityManager.prototype = {
			createEntity: function( entityType, args ) {
				var constructor = this.entityConstructors[ entityType ]

				if ( constructor === undefined ) {
					throw EntityManager.ENTITY_TYPE_NOT_KNOWN + entityType
				}

				var entityId = getNextId( this )
				var entity   = create( constructor, args )
				entity.id    = entityId

				return entity
			},

			addComponent: function( entity, componentType, args ) {
				var constructor = this.componentConstructors[ componentType ]

				if ( constructor === undefined ) {
					throw EntityManager.COMPONENT_TYPE_NOT_KNOWN + componentType
				}

				var component = create( constructor, args )
				entity[ componentType ] = component

				return component
			},

			removeComponent: function( entity, componentType ) {
				var component = entity[ componentType ]

				delete entity[ componentType ]

				return component
			}
		}


		function getNextId( self ) {
			var id = self.nextId

			self.nextId += 1

			return id
		}


		return EntityManager
	}
)

define(
	"spell/shared/util/CircularBuffer",
	function() {
		"use strict"


		function CircularBuffer( length, defaultValue ) {
			if( !length ) throw 'Argument "length" is missing'

			this.length = length
			this.index = 0
			this.array = new Array()

			if( !defaultValue ) return

			for( var i = 0; i < length; i++ ) {
				this.array[ i ] = defaultValue
			}
		}

		CircularBuffer.prototype = {
			push: function( value ) {
				this.array[ this.index ] = value
				this.index = ( this.index + 1 ) % this.length
			},
			toArray: function() {
				return this.array.slice()
			}
		}

		return CircularBuffer
	}
)

define(
	"spell/shared/util/Logger",
	[
		"spell/shared/util/platform/PlatformKit"
	],
	function(
		PlatformKit
	) {
		"use strict"


		/**
		 * private
		 */

		var LOG_LEVEL_DEBUG = 0
		var LOG_LEVEL_INFO  = 1
		var LOG_LEVEL_WARN  = 2
		var LOG_LEVEL_ERROR = 3

		var logLevels = [
			"DEBUG",
			"INFO",
			"WARN",
			"ERROR"
		]

		var currentLogLevel = LOG_LEVEL_INFO


		var setLogLevel = function( level ) {
			currentLogLevel = level
		}

		var log = function( level, message ) {
			if( level < 0 ||
				level > 3 ) {

				throw "Log level '" + level + "' is not supported."
			}

			if( level < currentLogLevel ) return


			PlatformKit.log( logLevels[ level ] + " " + message )
		}

		var debug = function( message ) {
			log( LOG_LEVEL_DEBUG, message )
		}

		var info = function( message ) {
			log( LOG_LEVEL_INFO, message )
		}

		var warn = function( message ) {
			log( LOG_LEVEL_WARN, message )
		}

		var error = function( message ) {
			log( LOG_LEVEL_ERROR, message )
		}


		/**
		 * public
		 */

		return {
			LOG_LEVEL_DEBUG : LOG_LEVEL_DEBUG,
			LOG_LEVEL_INFO  : LOG_LEVEL_INFO,
			LOG_LEVEL_WARN  : LOG_LEVEL_WARN,
			LOG_LEVEL_ERROR : LOG_LEVEL_ERROR,
			setLogLevel     : setLogLevel,
			log             : log,
			debug           : debug,
			info            : info,
			warn            : warn,
			error           : error
		}
	}
)

define(
	"spell/client/util/network/initializeClockSync",
	[
		"spell/shared/util/platform/Types",
		"spell/shared/util/platform/PlatformKit",
		"spell/shared/util/CircularBuffer",
		"spell/shared/util/Logger",

		"underscore"
	],
	function(
		Types,
		PlatformKit,
		CircularBuffer,
		Logger,

		_
	) {
		"use strict"


		var HIGH_SYNC_FREQUENCY = 4
		var MEDIUM_SYNC_FREQUENCY = 2
		var LOW_SYNC_FREQUENCY = 1

		/**
		 * the minimum number of performed clock synchronization round trips until clock synchronization is established
		 */
		var minNumberOfClockSyncRoundTrips = 5

		/**
		 * the frequency at which clock synchronization is performed
		 */
		var synchronizationFrequency = HIGH_SYNC_FREQUENCY

		/**
		 * the number of measurements the computation is based on
		 */
		var numberOfOneWayLatencyMeasurements = 5

		var initialSynchronization = true


		function initializeClockSync( eventManager, statisticsManager, connection ) {
			statisticsManager.addSeries( 'ping', 'ms' )
			statisticsManager.addSeries( 'currentTime', 'ms' )
			statisticsManager.addSeries( 'sendTimeInMs', 'ms' )

			var currentUpdateNumber = 1
			var oneWayLatenciesInMs = new CircularBuffer( numberOfOneWayLatencyMeasurements )

			connection.handlers[ "clockSync" ] = function( messageType, messageData ) {
				var currentTimeInMs            = Types.Time.getCurrentInMs()
				var sendTimeInMs               = messageData.clientTime
				var roundTripLatencyInMs       = currentTimeInMs - sendTimeInMs
				var estimatedOneWayLatencyInMs = roundTripLatencyInMs / 2

				statisticsManager.updateSeries( "ping", roundTripLatencyInMs )
				statisticsManager.updateSeries( "currentTime", currentTimeInMs % 2000 )
				statisticsManager.updateSeries( "sendTimeInMs", sendTimeInMs % 2000 )


				oneWayLatenciesInMs.push( estimatedOneWayLatencyInMs )
				var computedServerTimeInMs = computeServerTimeInMs( oneWayLatenciesInMs.toArray(), messageData.serverTime )


				if( currentUpdateNumber === minNumberOfClockSyncRoundTrips ) {
					eventManager.publish(
						[ "clockSyncEstablished" ],
						[ computedServerTimeInMs ]
					)

					initialSynchronization = false

					Logger.debug( 'clock synchronization established' )

				} else {
//					eventManager.publish(
//						[ "clockSyncUpdate" ],
//						[ computedServerTimeInMs ]
//					)
				}

				currentUpdateNumber++
			}

			var sendClockSyncMessage = function() {
				// TODO: figure out how to perform continuous clock synchronization that is not harmful
				if( !initialSynchronization ) return

				connection.send(
					"clockSync",
					{
						clientTime: Types.Time.getCurrentInMs()
					}
				)

				PlatformKit.registerTimer( sendClockSyncMessage, 1000 / synchronizationFrequency )
			}

			sendClockSyncMessage()
		}


		function computeSynchronizationFrequency( standardDeviationInMs ) {
			if( initialSynchronization ) {
				return HIGH_SYNC_FREQUENCY
			}

			if( standardDeviationInMs > 25 ) {
				return HIGH_SYNC_FREQUENCY

			} else if( standardDeviationInMs > 10 ) {
				return MEDIUM_SYNC_FREQUENCY

			} else {
				return LOW_SYNC_FREQUENCY
			}
		}


		function computeServerTimeInMs( oneWayLatenciesInMs, serverTimeInMs ) {
			oneWayLatenciesInMs.sort( function( a, b ) {
				return a - b
			} )

			var medianLatencyInMs
			if( oneWayLatenciesInMs.length % 2 === 0 ) {
				var a = oneWayLatenciesInMs[ oneWayLatenciesInMs.length / 2 - 1 ]
				var b = oneWayLatenciesInMs[ oneWayLatenciesInMs.length / 2     ]

				medianLatencyInMs = ( a + b ) / 2

			} else {
				medianLatencyInMs = oneWayLatenciesInMs[ Math.floor( oneWayLatenciesInMs.length / 2 ) ]
			}

			var meanLatencyInMs = _.reduce(
				oneWayLatenciesInMs,
				function( a, b ) {
					return a + b
				},
				0
			) / oneWayLatenciesInMs.length

			var varianceInMsSquared = _.reduce(
				oneWayLatenciesInMs,
				function( memo, latencyInMs ) {
					return memo + Math.pow( latencyInMs - meanLatencyInMs, 2 )
				},
				0
			)

			var standardDeviationInMs = Math.sqrt( varianceInMsSquared )

			synchronizationFrequency = computeSynchronizationFrequency( standardDeviationInMs )

			var significantOneWayLatenciesInMs = _.filter(
				oneWayLatenciesInMs,
				function( latencyInMs ) {
					return latencyInMs <= medianLatencyInMs + standardDeviationInMs
				}
			)

			var meanSignificantOneWayLatencyInMs = _.reduce(
				significantOneWayLatenciesInMs,
				function( a, b ) {
					return a + b
				},
				0
			) / significantOneWayLatenciesInMs.length

			return Math.floor( serverTimeInMs + meanSignificantOneWayLatencyInMs )
		}


		return initializeClockSync
	}
)

define(
	"spell/client/util/network/network",
	[
		"spell/client/util/network/initializeClockSync"
	],
	function(
		initializeClockSync
	) {
		"use strict"


		return {
			initializeClockSync       : initializeClockSync
		}
	}
)

define(
	"spell/client/util/network/createServerConnection",
	[
		"spell/shared/util/platform/PlatformKit",
		"spell/shared/util/Logger"
	],
	function(
		PlatformKit,
		Logger
	) {
		"use strict"


		return function( eventManager, statisticsManager, host, protocol ) {
			statisticsManager.addSeries( "charsSent", "chars/s" )
			statisticsManager.addSeries( "charsReceived", "chars/s" )

			var socket = PlatformKit.createSocket( host )

			var connection = {
				protocol : protocol,
				socket   : socket,
				messages : {},
				handlers : {},
				send : function( messageType, messageData ) {
					var message = connection.protocol.encode( messageType, messageData )

					statisticsManager.updateSeries( "charsSent", message.length )

					try {
						socket.send( message )

					} catch ( e ) {
						Logger.debug( 'FIXME: Could not send message, because the socket is not connected yet. Will retry in 0.5 sec' )

						PlatformKit.registerTimer(
							function() {
								socket.send( message )
							},
							500
						)
					}
				}
			}

			socket.setOnMessage(
				function( messageData ) {
					var message = protocol.decode( messageData )

					statisticsManager.updateSeries( "charsReceived", messageData.length )

					eventManager.publish(
						[ "messageReceived", message.type ],
						[ message.type, message.data ]
					)

					if( connection.handlers[ message.type ] === undefined ) {
						if ( !connection.messages.hasOwnProperty( message.type ) ) {
							connection.messages[ message.type ] = []
						}
						connection.messages[ message.type ].push( message.data )

					} else {
						connection.handlers[ message.type ]( message.type, message.data )
					}
				}
			)

			return connection
		}
	}
)

define(
	"spell/shared/util/zones/ZoneManager",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		var ZoneManager = function( eventManager, zoneTemplates, globals ) {
			this.eventManager   = eventManager
			this.zoneTemplates  = zoneTemplates
			this.globals        = globals
			this.theActiveZones = []
		}


		ZoneManager.IS_NO_ACTIVE_ZONE_ERROR            = "The zone you tried to destroy in not an active zone: "
		ZoneManager.ZONE_TEMPLATE_DOES_NOT_EXIST_ERROR = "You tried to create an instance of a zone type that doesn't exist: "


		ZoneManager.prototype = {
			createZone: function( templateId, args ) {
				var zoneTemplate = this.zoneTemplates[ templateId ]

				if ( zoneTemplate === undefined ) {
					throw ZoneManager.ZONE_TEMPLATE_DOES_NOT_EXIST_ERROR + templateId
				}

				var zone = {
					templateId: templateId
				}

				zoneTemplate.onCreate.apply( zone, [ this.globals, args ] )
				this.theActiveZones.push( zone )

				this.eventManager.publish( [ "createZone" ], [ this, zone ] )

				return zone
			},

			destroyZone: function( zone, args ) {
				var wasRemoved = false
				this.theActiveZones = this.theActiveZones.filter( function( activeZone ) {
					if ( activeZone === zone ) {
						wasRemoved = true
						return false
					}

					return true
				} )

				if ( wasRemoved ) {
					this.zoneTemplates[ zone.templateId ].onDestroy.apply( zone, [ this.globals, args ] )

					this.eventManager.publish( [ "destroyZone" ], [ this, zone ] )
				}
				else {
					throw ZoneManager.IS_NO_ACTIVE_ZONE_ERROR + zone
				}
			},

			activeZones: function() {
				return this.theActiveZones
			}
		}


		return ZoneManager
	}
)

define(
	"spell/shared/util/ConfigurationManager",
	[
		"spell/shared/util/platform/PlatformKit",

		"underscore"
	],
	function(
		PlatformKit,

		_
	) {
		"use strict"


		/**
		 * private
		 */

		/**
		 * Generates a structure holding server host configuration information
		 *
		 * The returned structure looks like this:
		 * {
		 * 	host - the host, i.e. "acme.org:8080"
		 * 	type - This can take the value "internal" (same host as client was delivered from) or "external" (different host that the client was delivered from).
		 * }
		 *
		 * @param validValues
		 * @param value
		 */
		var extractServer = function( validValues, value ) {
			if( _.indexOf( validValues, '*' ) === -1 ) return false

			// TODO: validate that the value is a valid host
			var host = ( value === 'internal' ? PlatformKit.getHost() : value )
			var type = ( value === 'internal' ? 'internal' : 'external' )

			return {
				host : host,
				type : type
			}
		}

		var extractScreenSize = function( validValues, value ) {
			if( _.indexOf( validValues, value ) === -1 ) return false

			var parts = value.split( 'x' )

			return {
				width  : parseInt( parts[ 0 ] ),
				height : parseInt( parts[ 1 ] )
			}
		}

		/**
		 * These are the platform agnostic options.
		 *
		 * gameserver/resourceServer - "internal" means "same as the server that the client was delivered from"; "*" matches any valid host/port combination, i.e. "acme.org:8080"
		 */
		var validOptions = {
			screenSize : {
				validValues : [ '640x480', '800x600', '1024x768' ],
				extractor   : extractScreenSize
			},
			gameServer : {
				validValues : [ 'internal', '*' ],
				extractor   : extractServer
			},
			resourceServer : {
				validValues : [ 'internal', '*' ],
				extractor   : extractServer
			}
		}

		/**
		 * These options are used when they are not overridden by the environment configuration set up by the stage-0-loader.
		 */
		var defaultOptions = {
			screenSize     : '1024x768',
			gameServer     : 'internal',
			resourceServer : 'internal'
		}

		var createConfiguration = function( defaultOptions, validOptions ) {
			if( !defaultOptions ) defaultOptions = {}
			if( !validOptions ) validOptions = {}

			// PlatformKit.configurationOptions.* holds the platform specific options
			_.defaults( defaultOptions, PlatformKit.configurationOptions.defaultOptions )
			_.defaults( validOptions, PlatformKit.configurationOptions.validOptions )

			var suppliedParameters = PlatformKit.getUrlParameters()
			_.defaults( suppliedParameters, defaultOptions )

			var config = _.reduce(
				suppliedParameters,
				function( memo, optionValue, optionName ) {
					var option = validOptions[ optionName ]

					var configValue = option.extractor(
						option.validValues,
						optionValue
					)

					if( configValue !== false ) {
						memo[ optionName ] = configValue

					} else {
						// use the default value
						memo[ optionName ] = option.extractor(
							option.validValues,
							defaultOptions[ optionName ]
						)
					}

					return memo
				},
				{}
			)

			config.platform = PlatformKit.getPlatformInfo()

			return config
		}


		/**
		 * public
		 */

		return function() {
			return createConfiguration( defaultOptions, validOptions )
		}
	}
)

define(
	"spell/shared/util/forestMultiMap",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		function createNode() {
			return {
				subNodes: {},
				elements: []
			}
		}

		function getElements( node ) {
			if( !node ) {
				return []

			} else {
				return _.reduce(
					node.subNodes,
					function( elements, subNode ) {
						return elements.concat( getElements( subNode ) )
					},
					node.elements
				)
			}
		}

		function getNode( node, key, eachNode ) {
			return _.reduce(
				key,
				function( node, keyComponent ) {
					if( node === undefined ) return undefined

					if( eachNode !== undefined ) eachNode( node, keyComponent )

					return node.subNodes[ keyComponent ]
				},
				node
			)
		}


		return {
			create: function() {
				return createNode()
			},

			add: function(
				data,
				key,
				element
			) {
				var node = getNode(
					data,
					key,
					function( node, keyComponent ) {
						if ( !node.subNodes.hasOwnProperty( keyComponent ) ) {
							node.subNodes[ keyComponent ] = createNode()
						}
					}
				)

				node.elements.push( element )
			},

			remove: function(
				data,
				key,
				elementToRemove
			) {
				var node = getNode( data, key )

				node.elements = _.filter( node.elements, function( element ) {
					return element !== elementToRemove
				} )
			},

			get: function(
				data,
				key
			) {
				return getElements( getNode( data, key ) )
			}
		}
	}
)

define(
	"spell/shared/util/EventManager",
	[
		"spell/shared/util/forestMultiMap",

		"underscore"
	],
	function(
		forestMultiMap,

		_
	) {
		"use strict"


		function EventManager() {
			this.subscribers = forestMultiMap.create()
			this.eventQueue = []
		}

		EventManager.prototype = {
			subscribe: function(
				scope,
				subscriber
			) {
				if( _.size( this.eventQueue ) > 0 ) {
					this.eventQueue = _.reject(
						this.eventQueue,
						_.bind(
							function( event ) {
								return this.publish( event[ 0 ], event[ 1] )
							},
							this
						)
					)
				}

				forestMultiMap.add(
					this.subscribers,
					scope,
					subscriber
				)

				this.publish( [ "subscribe" ], [ scope, subscriber ] )
			},

			unsubscribe: function(
				scope,
				subscriber
			) {
				forestMultiMap.remove(
					this.subscribers,
					scope,
					subscriber
				)

				this.publish( [ "unsubscribe" ], [ scope, subscriber ] )
			},

			publish: function(
				scope,
				eventArgs
			) {
				var subscribersInScope = forestMultiMap.get(
					this.subscribers,
					scope
				)

				// WORKAROUND: at the moment only the event "setName" is queued
				if( _.size( subscribersInScope ) === 0 &&
					scope[ 1 ] === "setName" ) {
					this.eventQueue.push( [ scope, eventArgs ] )


					return false
				}

				_.each( subscribersInScope, function( subscriber ) {
					subscriber.apply( undefined, eventArgs )
				} )


				return true
			}
		}


		return EventManager
	}
)

define(
	"spell/shared/util/InputManager",
	[
		"spell/shared/util/input/keyCodes",
		"spell/shared/util/math",
		"spell/shared/util/platform/PlatformKit",

		"underscore"
	],
	function(
		keyCodes,
		math,
		PlatformKit,

		_
	) {
		"use strict"


		/**
		 * private
		 */

		var nextSequenceNumber = 0


		/**
		 * public
		 */

		var inputEvents = []
		var virtualKeys = null


		var getVirtualKey = function( virtualKeys, position ) {
			return _.find(
				virtualKeys,
				function( virtualKey ) {
					var x, y, borderLeft, borderRight, borderTop, borderBottom

					x = position[ 0 ]
					y = position[ 1 ]

					borderLeft   = virtualKey.position[ 0 ]
					borderRight  = virtualKey.position[ 0 ] + virtualKey.size[ 0 ]
					borderTop    = virtualKey.position[ 1 ]
					borderBottom = virtualKey.position[ 1 ] + virtualKey.size[ 1 ]

					return ( math.isInInterval( x, borderLeft, borderRight ) &&
							 math.isInInterval( y, borderTop, borderBottom ) )
				}
			)
		}

		var mouseHandler = function( event ) {
			var virtualKey = getVirtualKey( virtualKeys, event.position )

			if( !virtualKey ) return true


			var internalEvent = {
				type           : ( event.type === 'mousedown' ? 'keydown' : 'keyup' ),
				keyCode        : virtualKey.keyCode,
				sequenceNumber : nextSequenceNumber++
			}

			inputEvents.push( internalEvent )
		}

		var keyHandler = function( event ) {
			inputEvents.push( {
				type           : event.type,
				keyCode        : event.keyCode,
				sequenceNumber : nextSequenceNumber++
			} )
		}


		var InputManager = function( screenSizeConfig ) {
			this.nativeInput = PlatformKit.createInput( screenSizeConfig )

			var keyWidth, keyHeight, keyPadding, keyPositionY
			keyWidth     = Math.floor( screenSizeConfig.width / 30 ) * 10
			keyHeight    = screenSizeConfig.height
			keyPadding   = ( screenSizeConfig.width - ( keyWidth * 3 ) ) / 2
			keyPositionY = 0


			virtualKeys = [
				{
					keyCode  : keyCodes[ 'left arrow' ],
					position : [ 0, keyPositionY, 0 ],
					size     : [ keyWidth, keyHeight, 0 ]
				},
				{
					keyCode  : keyCodes[ 'space' ],
					position : [ keyWidth + keyPadding, keyPositionY, 0 ],
					size     : [ keyWidth, keyHeight, 0 ]
				},
				{
					keyCode  : keyCodes[ 'right arrow' ],
					position : [ ( keyWidth + keyPadding ) * 2, keyPositionY, 0 ],
					size     : [ keyWidth, keyHeight, 0 ]
				}
			]
		}

		InputManager.prototype = {
			init : function() {
				if( PlatformKit.features.touch ) {
					this.nativeInput.setInputEventListener( 'mousedown', mouseHandler )
					this.nativeInput.setInputEventListener( 'mouseup', mouseHandler )
				}

				this.nativeInput.setInputEventListener( 'keydown', keyHandler )
				this.nativeInput.setInputEventListener( 'keyup', keyHandler )
			},
			cleanUp : function() {
				if( PlatformKit.features.touch ) {
					this.nativeInput.removeInputEventListener( 'mousedown' )
					this.nativeInput.removeInputEventListener( 'mouseup' )
				}

				this.nativeInput.removeInputEventListener( 'keydown' )
				this.nativeInput.removeInputEventListener( 'keyup' )
			},
			getInputEvents : function() {
				return inputEvents
			}
		}

		return InputManager
	}
)

define(
	'spell/shared/util/ResourceLoader',
	[
		'spell/shared/util/platform/PlatformKit',
		'spell/shared/util/Events',
		'spell/shared/util/Logger',

		'underscore'
	],
	function(
		PlatformKit,
		Events,
		Logger,

		_
	) {
		'use strict'


		/**
		 * private
		 */

		var STATE_WAITING_FOR_PROCESSING = 0
		var STATE_PROCESSING = 1
		var STATE_COMPLETED = 2

		var extensionToLoaderFactory = {
			'png'  : PlatformKit.createImageLoader,
			'jpg'  : PlatformKit.createImageLoader,
			'json' : PlatformKit.createSoundLoader,
			'txt'  : PlatformKit.createTextLoader
		}


		var createResourceBundle = function( name, resources ) {
			return {
				name                  : name,
				state                 : STATE_WAITING_FOR_PROCESSING,
				resources             : resources,
				resourcesTotal        : resources.length,
				resourcesNotCompleted : resources.length
			}
		}

		/**
		 * Returns true if a resource bundle with the provided name exists, false otherwise.
		 *
		 * @param resourceBundles
		 * @param name
		 */
		var resourceBundleExists = function( resourceBundles, name ) {
			return _.has( resourceBundles, name )
		}

		/**
		 * Returns true if a resource with the provided name exists, false otherwise.
		 *
		 * @param resources
		 * @param resourceName
		 */
		var isResourceInCache = function( resources, resourceName ) {
			return _.has( resources, resourceName )
		}

		var updateProgress = function( resourceBundle ) {
			resourceBundle.resourcesNotCompleted -= 1

			var progress = 1.0 - resourceBundle.resourcesNotCompleted / resourceBundle.resourcesTotal

			this.eventManager.publish(
				[ Events.RESOURCE_PROGRESS, resourceBundle.name ],
				[ progress ]
			)

			if( resourceBundle.resourcesNotCompleted === 0 ) {
				resourceBundle.state = STATE_COMPLETED

				this.eventManager.publish( [ Events.RESOURCE_LOADING_COMPLETED, resourceBundle.name ] )
			}
		}

		var checkResourceAlreadyLoaded = function( loadedResources, resourceName ) {
			_.each(
				loadedResources,
				_.bind(
					function( loadedResource, loadedResourceName ) {
						if( !_.has( this.resources, loadedResourceName ) ) return

						throw 'Error: sub-resource "' + loadedResourceName + '" from resource "' + resourceName + '" already exists.'
					},
					this
				)
			)
		}

		var resourceLoadingCompletedCallback = function( resourceBundleName, resourceName, loadedResources ) {
			if( loadedResources === undefined ||
				_.size( loadedResources ) === 0 ) {

				throw 'Resource "' + resourceName + '" from resource bundle "' + resourceBundleName + '" is undefined or empty on loading completed.'
			}

			// making sure the loaded resources were not already returned earlier
			checkResourceAlreadyLoaded.call( this, loadedResources, resourceName )

			// add newly loaded resources to cache
			_.extend( this.resources, loadedResources )

			updateProgress.call( this, this.resourceBundles[ resourceBundleName ] )
		}

		var resourceLoadingTimedOutCallback = function( resourceBundleName, resourceName ) {
			Logger.debug( 'Loading "' + resourceName + '" failed with a timeout. In case the execution environment is safari this message can be ignored.' )

			updateProgress.call( this, this.resourceBundles[ resourceBundleName ] )
		}

		var createLoader = function( eventManager, host, resourceBundleName, resourceName, loadingCompletedCallback, loadingTimedOutCallback ) {
			var extension = _.last( resourceName.split( '.' ) )
			var loaderFactory = extensionToLoaderFactory[ extension ]

			if( loaderFactory === undefined ) {
				throw 'Could not create loader factory for resource "' + resourceName + '".'
			}

			var loader = loaderFactory(
				eventManager,
				host,
				resourceBundleName,
				resourceName,
				loadingCompletedCallback,
				loadingTimedOutCallback
			)

			return loader
		}

		var startLoadingResourceBundle = function( resourceBundle ) {
			_.each(
				resourceBundle.resources,
				_.bind(
					function( resourceName ) {
						if( isResourceInCache( this.resources, resourceName ) ) {
							updateProgress( resourceBundle )

							return
						}

						var loader = createLoader(
							this.eventManager,
							this.host,
							resourceBundle.name,
							resourceName,
							_.bind( resourceLoadingCompletedCallback, this, resourceBundle.name, resourceName ),
							_.bind( resourceLoadingTimedOutCallback, this, resourceBundle.name, resourceName )
						)

						if( loader !== undefined ) {
							loader.start()

						} else {
							throw 'Could not create a loader for resource "' + resourceName + '".'
						}
					},
					this
				)
			)
		}


		/**
		 * public
		 */

		var ResourceLoader = function( eventManager, hostConfig ) {
			if( eventManager === undefined ) throw 'Argument "eventManager" is undefined.'

			this.eventManager = eventManager
			this.resourceBundles = {}
			this.resources = {}
			this.host = ( hostConfig.type === 'internal' ? '' : 'http://' + hostConfig.host )
		}

		ResourceLoader.prototype = {
			addResourceBundle: function( name, resources ) {
				if( _.size( resources ) === 0 ) {
					throw 'Resource group with name "' + name + '" has zero assigned resources.'
				}

				if( resourceBundleExists( this.resourceBundles, name ) ) {
					throw 'Resource group with name "' + name + '" already exists.'
				}


				this.resourceBundles[ name ] = createResourceBundle(
					name,
					resources
				)
			},

			start: function() {
				_.each(
					this.resourceBundles,
					_.bind(
						function( resourceBundle ) {
							if( resourceBundle.state !== STATE_WAITING_FOR_PROCESSING ) return

							resourceBundle.state = STATE_PROCESSING
							startLoadingResourceBundle.call( this, resourceBundle )
						},
						this
					)
				)
			},

			getResources: function() {
				return this.resources
			}
		}

		return ResourceLoader
	}
)

define(
	"spell/shared/util/StatisticsManager",
	[
		"underscore"
	],
	function(
		_
	) {
		"use strict"


		/**
		 * private
		 */

		var numberOfValues = 512

		var createBuffer = function( bufferSize ) {
			var buffer = []

			while( bufferSize > 0 ) {
				buffer.push( 0 )
				bufferSize--
			}

			return buffer
		}

		var createSeries = function( id, name, unit ) {
			return {
				values : createBuffer( numberOfValues ),
				name   : name,
				unit   : unit
			}
		}


		/**
		 * public
		 */

		var StatisticsManager = function() {
			this.series = {}
		}

		StatisticsManager.prototype = {
			init : function() {
				this.addSeries( 'fps', 'frames per second', 'fps' )
				this.addSeries( 'totalTimeSpent', 'total time spent', 'ms' )
				this.addSeries( 'timeSpentRendering', 'time spent rendering', 'ms' )
			},
			/**
			 * call this method to signal the beginning of a new measurement period
			 */
			startTick: function() {
				_.each(
					this.series,
					function( iter ) {
						iter.values.push( 0 )
						iter.values.shift()
					}
				)
			},
			addSeries : function( id, name, unit ) {
				if( !id ) return

				if( _.has( this.series, id ) ) throw 'Series with id "' + id + '" already exists'

				this.series[ id ] = createSeries( id, name, unit )
			},
			updateSeries : function( id, value ) {
				if( !id ) return

				var series = this.series[ id ]

				if( !series ) return

				series.values[ numberOfValues - 1 ] += value
			},
			getValues : function() {
				return this.series
			},
			getSeriesValues : function( id ) {
				return this.series[ id ]
			}
		}

		return StatisticsManager
	}
)

define(
	"spell/client/main",
	[
		"spell/shared/util/ConfigurationManager",
		'spell/shared/util/EventManager',
		'spell/shared/util/InputManager',
		'spell/shared/util/ResourceLoader',
		'spell/shared/util/StatisticsManager',
        'spell/shared/util/platform/PlatformKit'
	],
	function(
		ConfigurationManager,
		EventManager,
		InputManager,
		ResourceLoader,
		StatisticsManager,
        PlatformKit
	) {
		"use strict"


		// return spell entry point
		return function( gameModule, clientMain ) {
			var configurationManager = new ConfigurationManager()
			var eventManager         = new EventManager()
			var inputManager         = new InputManager( configurationManager.screenSize )
			var resourceLoader       = new ResourceLoader( eventManager, configurationManager.resourceServer )
			var statisticsManager    = new StatisticsManager()

			statisticsManager.init()
            PlatformKit.initializeViewport( eventManager )

			var globals = {
				configurationManager : configurationManager,
				eventManager         : eventManager,
				inputManager         : inputManager,
				inputEvents          : inputManager.getInputEvents(),
				resourceLoader       : resourceLoader,
				statisticsManager    : statisticsManager
			}

			clientMain( globals )
		}
	}
)

define(
	'funkysnakes/client/main',
	[
		'funkysnakes/client/entities',
		'funkysnakes/client/systems/render',
		'funkysnakes/client/zones/game',
		'funkysnakes/client/zones/lobby',
		'funkysnakes/shared/config/constants',
		'funkysnakes/shared/util/createMainLoop',
		'funkysnakes/shared/components/position',
		'funkysnakes/shared/components/orientation',
		'funkysnakes/shared/components/collisionCircle',
		'funkysnakes/shared/components/shield',
		'funkysnakes/shared/components/tailElement',
		'funkysnakes/shared/components/amountTailElements',
		'funkysnakes/shared/util/networkProtocol',

		'spell/client/components/network/markedForDestruction',
		'spell/shared/util/entities/Entities',
		'spell/shared/util/entities/EntityManager',
		'spell/client/util/network/network',
		'spell/client/util/network/createServerConnection',
		'spell/shared/util/zones/ZoneManager',
		'spell/shared/util/platform/PlatformKit',
		'spell/shared/util/Events',
		'spell/shared/util/Logger',
		'spell/client/main',

		'underscore'
	],
	function(
		entities,
		render,
		game,
		lobby,
		constants,
		createMainLoop,
		position,
		orientation,
		collisionCircle,
		shield,
		tailElement,
		amountTailElements,
		networkProtocol,

		markedForDestruction,
		Entities,
		EntityManager,
		network,
		createServerConnection,
		ZoneManager,
		PlatformKit,
		Events,
		Logger,
		spellMain,

		_
	) {
		'use strict'


		var resourceUris = [
			'images/4.2.04_256.png',
			'images/web/tile.jpg',
			'images/web/menu.png',
			'images/web/logo.png',
			'images/html5_logo_64x64.png',
			'images/flash_logo_64x64.png',
			'images/help_controls.png',
			'images/environment/cloud_dark_02.png',
			'images/environment/cloud_dark_07.png',
			'images/environment/cloud_light_05.png',
			'images/environment/cloud_light_07.png',
			'images/environment/cloud_dark_03.png',
			'images/environment/cloud_light_04.png',
			'images/environment/arena.png',
			'images/environment/cloud_dark_05.png',
			'images/environment/cloud_dark_06.png',
			'images/environment/cloud_dark_01.png',
			'images/environment/cloud_light_01.png',
			'images/environment/ground.jpg',
			'images/environment/cloud_light_06.png',
			'images/environment/cloud_light_03.png',
			'images/environment/cloud_dark_04.png',
			'images/environment/cloud_light_02.png',
			'images/items/neutral_container.png',
			'images/items/object_energy.png',
			'images/items/player4_container.png',
			'images/items/dropped_container_1.png',
			'images/items/player3_container.png',
			'images/items/player1_container.png',
			'images/items/dropped_container_0.png',
			'images/items/invincible.png',
			'images/items/player2_container.png',
			'images/shadows/object_energy.png',
			'images/shadows/invincible.png',
			'images/shadows/container.png',
			'images/shadows/vehicle.png',
			'images/tile_cloud.png',
			'images/tile_cloud2.png',
			'images/vehicles/ship_player1.png',
			'images/vehicles/ship_player1_speed.png',
			'images/vehicles/ship_player1_invincible.png',
			'images/vehicles/ship_player2.png',
			'images/vehicles/ship_player2_speed.png',
			'images/vehicles/ship_player2_invincible.png',
			'images/vehicles/ship_player3.png',
			'images/vehicles/ship_player3_speed.png',
			'images/vehicles/ship_player3_invincible.png',
			'images/vehicles/ship_player4.png',
			'images/vehicles/ship_player4_speed.png',
			'images/vehicles/ship_player4_invincible.png',
			'images/effects/shield.png',
			'images/arrow_left.png',
			'images/arrow_right.png',
			'images/space.png',
			'sounds/sets/set1.json'
		]


		Logger.setLogLevel( Logger.LOG_LEVEL_DEBUG )

		var main = function( globals ) {
			Logger.debug( 'client started' )


			var configurationManager = globals.configurationManager
			var resourceLoader       = globals.resourceLoader
			var eventManager         = globals.eventManager
			var statisticsManager    = globals.statisticsManager


			resourceLoader.addResourceBundle( 'bundle1', resourceUris )

			eventManager.subscribe(
				[ Events.RESOURCE_LOADING_COMPLETED, 'bundle1' ],
				function( event ) {
					Logger.debug( 'completed loading resources' )


					var componentConstructors = {
						'markedForDestruction': markedForDestruction,
						'position'            : position,
						'orientation'         : orientation,
						'collisionCircle'     : collisionCircle,
						'shield'              : shield,
						'tailElement'         : tailElement,
						'amountTailElements'  : amountTailElements
					}

					var entityManager = new EntityManager( entities, componentConstructors )


					Logger.debug( 'connecting to game-server "' + configurationManager.gameServer.host + '"' )

					var connection = createServerConnection(
						eventManager,
						statisticsManager,
						configurationManager.gameServer.host,
						networkProtocol
					)

					var renderingContext = PlatformKit.RenderingFactory.createContext2d(
                        globals.eventManager,
						globals.configurationManager.screenSize.width,
						globals.configurationManager.screenSize.height,
						globals.configurationManager.renderingBackEnd
					)

					/**
					 * WORKAROUND: In order to support the reduced color buffer resolution of less than 1024x768 pixels a global scale transformation is applied.
					 */
					var scaleFactor = 1.0

					if( globals.configurationManager.screenSize.width === 800 &&
						globals.configurationManager.screenSize.height === 600 ) {

						scaleFactor = 800 / 1024

					} else if( globals.configurationManager.screenSize.width === 640 &&
								globals.configurationManager.screenSize.height === 480 ) {
						scaleFactor = 640 / 1024
					}

					renderingContext.scale( [ scaleFactor, scaleFactor, 1.0 ] )
					renderingContext.save()


					var renderingContextConfig = renderingContext.getConfiguration()
					Logger.debug( 'created rendering context: type=' + renderingContextConfig.type + '; size=' + renderingContextConfig.width + 'x' + renderingContextConfig.height )


					// TODO: the resource loader should create spell texture object instances instead of raw html images

					// HACK: creating textures out of images
					var resources = resourceLoader.getResources()
					var textures = {}

					_.each(
						resources,
						function( resource, resourceId ) {
							var extension =  _.last( resourceId.split( '.' ) )
							if( extension === 'png' || extension === 'jpg' ) {
								textures[ resourceId.replace(/images\//g, '') ] = renderingContext.createTexture( resource )
							}
						}
					)


					_.extend(
						globals,
						{
							renderingContext : renderingContext,
							connection       : connection,
							entityManager    : entityManager,
							eventManager     : eventManager,
							textures         : textures,
							sounds           : resources
						}
					)


					var zones = {
						game : game,
						lobby: lobby
					}

					var zoneManager = new ZoneManager( eventManager, zones, globals )

					globals.zoneManager = zoneManager


					eventManager.subscribe( [ 'messageReceived', 'zoneChange' ],
						function( messageType, messageData ) {
							// discard entity updates from the previous zone
							connection.messages[ 'entityUpdate' ] = []

							var currentZone = zoneManager.activeZones()[ 0 ]
							var newZone     = messageData

							zoneManager.destroyZone( currentZone )
							zoneManager.createZone( newZone )
						}
					)

					eventManager.subscribe( [ 'clockSyncEstablished' ], function( remoteGameTimeInMs ) {
						var mainLoop = createMainLoop(
							eventManager,
							statisticsManager,
							remoteGameTimeInMs
						)

						zoneManager.createZone( 'lobby' )

						PlatformKit.callNextFrame( mainLoop )
					} )

					network.initializeClockSync( eventManager, statisticsManager, connection )
				}
			)

			resourceLoader.start()
		}

		spellMain( 'funkysnakes', main )
	}
)
		}
	}
}
