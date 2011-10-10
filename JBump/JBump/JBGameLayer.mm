//
//  JBGameLayer.m
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JBGameLayer.h"

#import "JBEntity.h"
#import "JBBrush.h"
#import "JBBrushManager.h"
#import "JBHero.h"

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
        
        
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setObject:[[JBBrushManager getAllBrushes] lastObject] forKey:@"mapItem"];
        
        NSString* point1 = NSStringFromCGPoint(CGPointMake(30,30));
        NSString* point2 = NSStringFromCGPoint(CGPointMake(60,30));
        NSString* point3 = NSStringFromCGPoint(CGPointMake(60,60));
        NSString* point4 = NSStringFromCGPoint(CGPointMake(90,90));
        NSString* point5 = NSStringFromCGPoint(CGPointMake(200,70));
        NSArray* points = [NSArray arrayWithObjects:point1,point2,point3,point4,point5,nil];
        [dict setObject:points forKey:@"points"];
        NSArray* objects = [NSArray arrayWithObject:dict];
        [self insertObjects:objects];
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

- (void)insertObjects:(NSArray *)objects
{
    for (NSDictionary* dict in objects) {
        JBMapItem* mapItem = [dict objectForKey:@"mapItem"];
        if ([mapItem isKindOfClass:[JBBrush class]]) {
            JBBrush* brush = (JBBrush *)mapItem;
            
            NSArray* points = [dict objectForKey:@"points"];
            
            if (points.count>1) {
                CGPoint start = CGPointFromString([points objectAtIndex:0]);
                CGPoint end;
                b2BodyDef curveDef;
                curveDef.position.Set(start.x/PTM_RATIO , start.y/PTM_RATIO);
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
