package Spielmeister.Spell.Platform.Private.Box2D {
	import Box2D.Common.Math.*
	import Box2D.Dynamics.*
	import Box2D.Collision.Shapes.*

	public function createBox2DObject() : Object {
		return {
			Common : {
				Math : {
					b2Vec2 : b2Vec2,
					createB2Vec2 : function( x, y ) : b2Vec2 {
						return new b2Vec2( x, y )
					}
				}
			},
			Dynamics : {
				b2Body : b2Body,
				createB2Body : function( bd : b2BodyDef, world : b2World ) : b2Body {
					return new b2Body( bd, world )
				},
				b2BodyDef : b2BodyDef,
				createB2BodyDef : function() : b2BodyDef {
					return new b2BodyDef()
				},
				b2ContactListener : b2ContactListener,
				createB2ContactListener : function( beginContact : Function, endContact : Function, preSolve : Function, postSolve : Function ) : b2ContactListener {
					return new ContactListenerWrapper( beginContact, endContact, preSolve,  postSolve )
				},
				b2FixtureDef : b2FixtureDef,
				createB2FixtureDef : function() : b2FixtureDef{
					return new b2FixtureDef()
				},
				b2World : b2World,
				createB2World : function( gravity, doSleep ) : b2World {
					return new b2World( gravity, doSleep )
				}
			},
			Collision : {
				Shapes : {
					b2PolygonShape : b2PolygonShape,
					createB2PolygonShape : function() : b2PolygonShape {
						return new b2PolygonShape()
					},
					b2CircleShape : b2CircleShape,
					createB2CircleShape : function( radius ) : b2CircleShape {
						return new b2CircleShape( radius )
					}
				}
			}
		}
	}
}
