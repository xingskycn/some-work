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

#define PTM_RATIO 32

@implementation JBGameLayer

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
        gravity.Set(.0f, -10.f);
        world = new b2World(gravity,false);
        
        world->SetContinuousPhysics(true);
		
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
    
    int32 velocityIterations = 8;
	int32 positionIterations = 1;
	world->Step(deltaTime, velocityIterations, positionIterations);
    
	for (b2Body* body = world->GetBodyList(); body; body = body->GetNext())
	{
		if (body->GetUserData() != NULL) {
			CCSprite *myActor = (CCSprite*)body->GetUserData();
			myActor.position = CGPointMake( body->GetPosition().x * PTM_RATIO,
                                            body->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(body->GetAngle());
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
                curveFix.restitution = 0.5f;
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

- (void)insertHero
{
    
    JBHero *hero = [[JBHero alloc] initWithNode:self];
    
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(70./PTM_RATIO, 1000./PTM_RATIO);
	bodyDef.userData = hero.sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
    fixtureDef.restitution = 0.0f;
	body->CreateFixture(&fixtureDef);
}

@end
