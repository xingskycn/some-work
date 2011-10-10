//
//  JBGameLayer.m
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JBGameLayer.h"

#import "JBEntity.h"
#import "JBEntityManager.h"
#import "JBBrush.h"
#import "JBBrushManager.h"
#import "JBHero.h"

#import "JBMap.h"

#import "JBMapManager.h"

#import "JBLineSprite.h"
#import "JBGameViewController.h"

#define PTM_RATIO 32

static JBHero* player;

class MyContactListener : public b2ContactListener {
public:
    void BeginContact(b2Contact* contact)
    { /* handle begin event */ 
        
    }
    void EndContact(b2Contact* contact) { /* handle end event */ 
        
    }
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold) { /* handle pre-solve event */ 
        if(contact->GetFixtureA()->GetBody()==player.body) {
            b2WorldManifold worldManifold; contact->GetWorldManifold(&worldManifold);
            float product = -acosf(worldManifold.normal.x)*180/M_PI+90;
            
            [player.sprite setRotation:product];
            
            if (worldManifold.normal.y > 0.5f) {
                player.onGround=true; 
            }
        }else if (contact->GetFixtureB()->GetBody()==player.body) {
            b2WorldManifold worldManifold; contact->GetWorldManifold(&worldManifold);
            float product = -acosf(worldManifold.normal.x)*180/M_PI+90;
            
            [player.sprite setRotation:product];
            
            if (worldManifold.normal.y > 0.5f) {
                player.onGround=true; 
            }
        }
    }
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
    { /* handle post-solve event */ 
    
    } 
};

@implementation JBGameLayer

@synthesize gameViewController;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	JBGameLayer *layer = [JBGameLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer z:0 tag:0];
	
	// return the scene
	return scene;
}

-(void) draw
{
#ifdef __jbDEBUG_GAMEVIEW
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glLineWidth(1.0f);
	world->DrawDebugData();
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
#endif
}


- (id)init {
    self = [super init];
    if (self) {
        self.isTouchEnabled = YES;
        
        b2Vec2 gravity;
        gravity.Set(.0f, -10.0f);
        world = new b2World(gravity,false);
        
        world->SetContinuousPhysics(true);
		world->SetContactListener(new MyContactListener);
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
#ifdef __jbDEBUG_GAMEVIEW
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
        //		flags += b2DebugDraw::e_jointBit;
        //		flags += b2DebugDraw::e_aabbBit;
        //		flags += b2DebugDraw::e_pairBit;
        //		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);
#endif
        
        [self schedule:@selector(tick:)];
        
        
        JBMap* map = [JBMapManager getMapWithID:@"custom map"];
        
        CCSprite* image = [CCSprite spriteWithFile:@"island.png"];
        
        [self addChild:image z:0];
        
        [self insertCurves:map.curves];
        [self insertHero];
        
        
    }
    
    return self;
}


- (void)tick:(ccTime)deltaTime{
    player.onGround=NO;
    int32 velocityIterations = 8;
	int32 positionIterations = 1;
	world->Step(deltaTime, velocityIterations, positionIterations);
    
	for (b2Body* body = world->GetBodyList(); body; body = body->GetNext())
	{
		if (body->GetUserData() != NULL) {
			CCSprite *myActor = (CCSprite*)body->GetUserData();
			myActor.position = CGPointMake( body->GetPosition().x * PTM_RATIO,
                                            body->GetPosition().y * PTM_RATIO);
            if(player.sprite!=myActor){
                myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());
            }
		}	
	}
    
    if (player) {
        float newX = player.sprite.position.x - [[CCDirector sharedDirector] winSize].width/2;
        float newY = player.sprite.position.y - [[CCDirector sharedDirector] winSize].height/2;
        
        [self.camera setCenterX:newX centerY:newY centerZ:0];
        [self.camera setEyeX:newX eyeY:newY eyeZ:1];
    }
    
    if (self.gameViewController.jumpButton.isTouchInside) {
        [player jump:(float)deltaTime];
    }
    
    if (self.gameViewController.moveLeftButton.isTouchInside) {
        [player moveLeft:(float)deltaTime];
    }
    
    if (self.gameViewController.moveRightButton.isTouchInside) {
        [player moveRight:(float)deltaTime];
    }
    if (!player.onGround) {
        if (player.sprite.rotation<180) {
            player.sprite.rotation=player.sprite.rotation/1.18;
        }
    }
}

- (void)insertCurves:(NSArray *)objects
{
    for (NSDictionary* dict in objects) {
        //JBBrush* brush = [[JBBrushManager getAllBrushes] lastObject];
        JBLineSprite* line = [JBLineSprite node];
        line.alpha = 1.f;
        line.red = 1.f;
        NSArray* points = [dict objectForKey:@"points"];
        line.pointArray = [points mutableCopy];
        line.visible = TRUE;
        [self addChild:line];
        if (points.count>1) {
            CGPoint start = CGPointFromString([points objectAtIndex:0]);
            CGPoint end;
            b2BodyDef curveDef;
            curveDef.position.Set(0 , 0);
            b2Body* curveBody = world->CreateBody(&curveDef);
            b2FixtureDef curveFix;
            b2PolygonShape curve;
            for (int i=1; i<points.count; i++) {
                end = CGPointFromString([points objectAtIndex:i]);
                curve.SetAsEdge(b2Vec2(start.x/PTM_RATIO,start.y/PTM_RATIO), b2Vec2(end.x/PTM_RATIO,end.y/PTM_RATIO));
                curveFix.shape = &curve;
                curveFix.friction = 0.4f;
                curveFix.restitution = 0.0f;
                curveBody->CreateFixture(&curveFix);
                start = end;
            }
        }
    }
}

- (void)insertEntities:(NSArray *)objects
{
    for (NSDictionary* dict in objects) {
        //JBEntity* entity = [JBEntityManager getEntityWithID:[dict objectForKey:@"ID"]];
        //entity.sprite = [CCSprite node];
        //entity.sprite.position = CGPointFromString([dict objectForKey:@"position"]);
        
    }
}

- (void)resetJumpForce{
    player.jumpForce=0.0f;
}

- (void)insertHero
{
    
    player = [[JBHero alloc] initWithNode:self];
    
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(70./PTM_RATIO, 1000./PTM_RATIO);
	bodyDef.userData = player.sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
    b2CircleShape shape;
    shape.m_radius = 0.45f;
	b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;	
	fixtureDef.friction = 0.1f;
    fixtureDef.restitution = 0.05f;
	body->CreateFixture(&fixtureDef);
    
    player.body=body;
}

@end
