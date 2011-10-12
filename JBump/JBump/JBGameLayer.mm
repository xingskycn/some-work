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

#import "JBSkinManager.h"
#import "JBSkin.h"

#import "JBTavern.h"

static JBHero* player;

class MyContactListener : public b2ContactListener {
public:
    void BeginContact(b2Contact* contact)
    { /* handle begin event */ 
        
    }
    void EndContact(b2Contact* contact) { /* handle end event */ 
        
    }
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold) { /* handle pre-solve event */ 
         b2WorldManifold worldManifold; contact->GetWorldManifold(&worldManifold);
        if ([(NSObject*)contact->GetFixtureB()->GetUserData() isKindOfClass:[JBBrush class]]
            &&worldManifold.points[0].y>contact->GetFixtureA()->GetBody()->GetWorldCenter().y) {
            JBBrush *brush = (JBBrush*)contact->GetFixtureB()->GetUserData();
            if ([brush.ID isEqualToString:jbBRUSH_PLATFORM]) {
                //if (worldManifold.normal.y < 0.2f) {
                if (contact->GetFixtureA()->GetBody()->GetLinearVelocity().y>0.0f) {
                    contact->SetEnabled(false);
                    player.desiredRotation = 0;
                }
                
            }
        }else if ([(NSObject*)contact->GetFixtureA()->GetUserData() isKindOfClass:[JBBrush class]]
            &&worldManifold.points[0].y>contact->GetFixtureB()->GetBody()->GetWorldCenter().y) {
            JBBrush *brush = (JBBrush*)contact->GetFixtureA()->GetUserData();
            if ([brush.ID isEqualToString:jbBRUSH_PLATFORM]) {
                //if (worldManifold.normal.y < -0.5f) {
                if (contact->GetFixtureB()->GetBody()->GetLinearVelocity().y>0.0f) {
                    contact->SetEnabled(false);
                    player.desiredRotation = 0;
                }
            }
        }

        
        if(contact->GetFixtureA()->GetBody()==player.body) {
            float product = -acosf(worldManifold.normal.x)*180/M_PI+90;
            
            player.desiredRotation = product;
            
            if (worldManifold.normal.y > 0.5f) {
                player.onGround=true; 
            }
        }else if (contact->GetFixtureB()->GetBody()==player.body) {
            float product = -acosf(worldManifold.normal.x)*180/M_PI+90;
            
            player.desiredRotation = product;
            
            if (worldManifold.normal.y > 0.5f) {
                player.onGround=true; 
            }
            
        }
        if ([(NSObject*)contact->GetFixtureA()->GetBody()->GetUserData() isKindOfClass:[CCSprite class]]) {
            if ([(NSObject*)contact->GetFixtureB()->GetBody()->GetUserData() isKindOfClass:[CCSprite class]]) {
                if (contact->GetFixtureA()->GetBody()->GetWorldCenter().y>(contact->GetFixtureB()->GetBody()->GetWorldCenter().y+5.0f/PTM_RATIO)) {
                    if (((CCSprite*)contact->GetFixtureB()->GetBody()->GetUserData()).userData) {
                        NSLog(@"Player: %@ has lost a life.", ((CCSprite*)contact->GetFixtureB()->GetBody()->GetUserData()).userData);
                    }
                } else if (contact->GetFixtureB()->GetBody()->GetWorldCenter().y>(contact->GetFixtureA()->GetBody()->GetWorldCenter().y+5.0f/PTM_RATIO)){
                    if (((CCSprite*)contact->GetFixtureA()->GetBody()->GetUserData()).userData) {
                        NSLog(@"Player: %@ has lost a life.", ((CCSprite*)contact->GetFixtureA()->GetBody()->GetUserData()).userData);
                    }
                }
            }
            
        } /*else if ([(NSObject*)contact->GetFixtureB()->GetBody()->GetUserData() isKindOfClass:[CCSprite class]]) {
            
        } */
    }
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
    { /* handle post-solve event */ 
    
    } 
};

@implementation JBGameLayer

@synthesize gameViewController,spawnPoints;
@synthesize tavern;

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
        gravity.Set(.0f, -0.1f);
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
        
        self.spawnPoints = [NSMutableDictionary dictionary];
        
        [self schedule:@selector(tick:)];
        
        
        JBMap* map = [JBMapManager getMapWithID:@"C__custom map"];
        
        CCSprite* image = [CCSprite spriteWithFile:@"island.png"];
        
        [self addChild:image z:0];
        
        [self insertCurves:map.curves];
        [self insertEntities:map.mapEntities];
        multiplayer=NO;
        sendCounter=1;
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
            if ([(NSObject*)body->GetUserData() isKindOfClass:[JBBrush class]]) {
                continue;
            }
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
        
        if(player.onGround)
        {
            timePlayerOnGround +=(float)deltaTime;
        }else{
            timePlayerOnGround =0;
        }
    }
    
    if (self.gameViewController.jumpButton.isTouchInside) {
        [player jump:(float)deltaTime timeOnGround:timePlayerOnGround];
        player.jumpTouched = YES;
    }
    
    if (self.gameViewController.moveLeftButton.isTouchInside) {
        [player moveLeft:(float)deltaTime];
    }
    
    if (self.gameViewController.moveRightButton.isTouchInside) {
        [player moveRight:(float)deltaTime];
    }
    if (!player.onGround) {
        if (player.sprite.rotation<180) {
            //player.sprite.rotation=player.sprite.rotation/1.14;
            player.desiredRotation=0;
        }
    }
    
    [player.sprite setRotation:player.desiredRotation+((player.sprite.rotation-player.desiredRotation)/1.14)];
    
    if (player.body->GetLinearVelocity().y>6.5f) {
        player.body->SetLinearVelocity(b2Vec2(player.body->GetLinearVelocity().x, 6.5f));
    }
    
    
    if (multiplayer){
        if (sendCounter>=2) {
            sendCounter=1;
            [self.tavern sendPlayerUpdate];
        } else {
            sendCounter++;
        }
    }
}

- (void)insertCurves:(NSArray *)objects
{
    for (NSDictionary* dict in objects) {
        JBBrush* brush = [JBBrushManager getBrushForID:[dict objectForKey:jbID]];
        JBLineSprite* line = [JBLineSprite node];
        line.alpha = brush.alpha;
        line.red = brush.red;
        line.blue = brush.blue;
        line.green = brush.green;
        NSArray* points = [dict objectForKey:jBMAPITEM_POINTS];
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
                JBBrush *brush = [JBBrushManager getBrushForID:[dict objectForKey:jbID]];
                [brush retain];
                curveFix.userData=brush;
                curveBody->CreateFixture(&curveFix);
                start = end;
            }
        }
    }
}

- (void)insertEntities:(NSArray *)objects
{
    for (JBEntity* entity in objects) {
        entity.sprite = [CCSprite spriteWithFile:entity.imageLocal];
        entity.sprite.position = entity.position;
        [self addChild:entity.sprite];
        
        if ([entity.bodyType isEqualToString:jbENTITY_BODYTYPE_DENSE]) {
            b2BodyDef bodyDef;
            bodyDef.type = b2_dynamicBody;
            
            bodyDef.position.Set(entity.position.x/PTM_RATIO, entity.position.y/PTM_RATIO);
            bodyDef.userData = entity.sprite;
            b2Body *body = world->CreateBody(&bodyDef);
            
            if ([entity.shape isEqualToString:jbENTITY_SHAPE_CIRCLE]) {
                b2FixtureDef fixtureDef;
                b2CircleShape shape;
                shape.m_radius = entity.size.width/2/PTM_RATIO;
                fixtureDef.shape = &shape;
                fixtureDef.friction = entity.friction;
                fixtureDef.restitution = entity.restitution;
                fixtureDef.density = entity.density;
                body->CreateFixture(&fixtureDef);
            }
            if ([entity.shape isEqualToString:jbENTITY_SHAPE_BOX]) {
                b2FixtureDef fixtureDef;
                b2PolygonShape shape;
                shape.SetAsBox(entity.size.width/PTM_RATIO/2,entity.size.height/PTM_RATIO/2);
                fixtureDef.shape = &shape;
                fixtureDef.friction = entity.friction;
                fixtureDef.restitution = entity.restitution;
                fixtureDef.density = entity.density;
                body->CreateFixture(&fixtureDef);
            }
        }
        
        if ([entity.ID hasPrefix:@"spawnpoint"]) {
            if (![self.spawnPoints objectForKey:entity.ID]) {
                [self.spawnPoints setObject:[NSMutableArray array] forKey:entity.ID];
            }
            [[self.spawnPoints objectForKey:entity.ID] addObject:entity];
        }
    }
}

- (void)resetJumpForce{
    player.jumpTouched=NO;
    player.jumpForce=0.0f;
}

- (void)insertHero
{
    if (self.tavern!=nil) {
        player = self.tavern.localPlayer;
        multiplayer=YES;
    } else {
        player = [[JBHero alloc] init];
        player.name = [[NSUserDefaults standardUserDefaults] objectForKey:jbUSERDEFAULTS_PLAYER_NAME];
        player.skinID = [[NSUserDefaults standardUserDefaults] objectForKey:jbUSERDEFAULTS_SKIN];
    }
    JBSkin *heroSkin = [JBSkinManager getSkinWithID:player.skinID];
    player.sprite = [CCSprite spriteWithFile:heroSkin.imageLocation];
    player.sprite.scale=(30.0/player.sprite.textureRect.size.height);
    [self addChild:player.sprite z:0 tag:[player.name hash]];
    
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(70./PTM_RATIO, 700./PTM_RATIO);
	bodyDef.userData = player.sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
    b2CircleShape shape;
    shape.m_radius = 0.45f;
    //b2PolygonShape shape;
    //shape.SetAsBox(30.0f/2/PTM_RATIO, 30.0f/2/PTM_RATIO);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;	
	fixtureDef.friction = 0.1f;
    fixtureDef.density = 1.0f;
    fixtureDef.restitution = 0.050f;
	body->CreateFixture(&fixtureDef);
    
    player.sprite.userData = player.name;
    
    player.body=body;
}

- (void)setPositionForPlayer:(JBHero*)aPlayer withPosition:(CGPoint)position velocityX:(float)x andVelocityY:(float)y {
    
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(position.x, position.y);
	bodyDef.userData = aPlayer.sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
    b2CircleShape shape;
    shape.m_radius = 0.45f;
    //b2PolygonShape shape;
    //shape.SetAsBox(30.0f/2/PTM_RATIO, 30.0f/2/PTM_RATIO);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;	
	fixtureDef.friction = 0.1f;
    fixtureDef.density = 1.0f;
    fixtureDef.restitution = 0.050f;
	body->CreateFixture(&fixtureDef);
    body->SetLinearVelocity(b2Vec2(y, y));
    if(aPlayer.body!=nil)
        world->DestroyBody(aPlayer.body);
    aPlayer.body=nil;
    aPlayer.body=body;

}

- (void)setupSprites:(NSArray*)heroes {
    for (JBHero *aHero in heroes) {
        if([aHero.name isEqualToString:player.name]){
            continue;
        }
        aHero.sprite = [CCSprite spriteWithFile:aHero.skinLocation];
        aHero.sprite.scale=(30.0/player.sprite.textureRect.size.height);
        aHero.sprite.userData = aHero.name;
        [self addChild:aHero.sprite z:0 tag:[aHero.name hash]];

    }
}

@end
