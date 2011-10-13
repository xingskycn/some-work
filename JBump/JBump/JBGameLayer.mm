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
        
        if ([(NSObject*)contact->GetFixtureB()->GetUserData() isKindOfClass:[JBEntity class]])
        {
            JBEntity* entity = (JBEntity*)contact->GetFixtureB()->GetUserData();
            if (entity.shootable) 
            {
                if(contact->GetFixtureA()->GetBody()==player.body)
                {
                    if (player.jumpTouched) 
                    {
                        if (player.body->GetWorldCenter().y<entity.body->GetWorldCenter().y) {
                            if (entity.shottime+0.2<[[NSDate date] timeIntervalSince1970]) 
                            {    
                                entity.shottime = [[NSDate date] timeIntervalSince1970];
                                NSLog(@"playerA!");
                                
                                float forceX;
                                if (worldManifold.normal.x!=0) {
                                    forceX = worldManifold.normal.x;
                                    forceX = forceX/fabs(forceX)*500;
                                }
                                entity.needsSend = TRUE;
                                
                                entity.body->ApplyForce(b2Vec2(forceX, 1000), entity.body->GetWorldCenter());
                                return;
                            }
                        }
                    }
                }else if([(NSObject*)contact->GetFixtureA()->GetUserData() isKindOfClass:[JBBrush class]])
                {
                    JBBrush *brush = (JBBrush*)contact->GetFixtureA()->GetUserData();
                    if ([brush.ID isEqualToString:jBBRUSH_GOALLINE_TEAM1]) {
                        entity.hitGoalLine = 1;
                        NSLog(@"HAS HIT GOAL LINE 1");
                    }else if([brush.ID isEqualToString:jBBRUSH_GOALLINE_TEAM2]){
                        entity.hitGoalLine = 2;
                        NSLog(@"HAS HIT GOAL LINE 2");
                    }
                }
            }
        }
        
        if ([(NSObject*)contact->GetFixtureA()->GetUserData() isKindOfClass:[JBEntity class]])
        {
            JBEntity* entity = (JBEntity*)contact->GetFixtureA()->GetUserData();
            if (entity.shootable) 
            {
                if(contact->GetFixtureB()->GetBody()==player.body)
                {
                    if (player.body->GetWorldCenter().y<entity.body->GetWorldCenter().y) 
                    {
                        if (player.jumpTouched) 
                        {
                            if (entity.shottime+0.2<[[NSDate date] timeIntervalSince1970]) 
                            {                        
                                entity.shottime = [[NSDate date] timeIntervalSince1970];
                                NSLog(@"playerB! %f",worldManifold.normal.x);
                                
                                float forceX;
                                if (worldManifold.normal.x!=0) {
                                    forceX = worldManifold.normal.x;
                                    forceX = forceX/fabs(forceX)*-1000;
                                }
                                entity.needsSend = TRUE;
                                entity.body->ApplyForce(b2Vec2(forceX, 1000), entity.body->GetWorldCenter());
                                return;
                            }
                        }
                    }
                }else if([(NSObject*)contact->GetFixtureB()->GetUserData() isKindOfClass:[JBBrush class]])
                {
                    JBBrush *brush = (JBBrush*)contact->GetFixtureB()->GetUserData();
                    if ([brush.ID isEqualToString:jBBRUSH_GOALLINE_TEAM1]) {
                        entity.hitGoalLine = 1;
                        NSLog(@"HAS HIT GOAL LINE 1");
                    }else if([brush.ID isEqualToString:jBBRUSH_GOALLINE_TEAM2]){
                        entity.hitGoalLine = 2;
                        NSLog(@"HAS HIT GOAL LINE 2");
                    }
                }
            }
        }
        
        
        if ([(NSObject*)contact->GetFixtureB()->GetUserData() isKindOfClass:[JBBrush class]]
            &&worldManifold.points[0].y>contact->GetFixtureA()->GetBody()->GetWorldCenter().y) {
            JBBrush *brush = (JBBrush*)contact->GetFixtureB()->GetUserData();
            if ([brush.ID isEqualToString:jbBRUSH_PLATFORM]||[brush.ID isEqualToString:jbBRUSH_HORIZONTAL_PLATFORM]) {
                //if (worldManifold.normal.y < 0.2f) {
                if (contact->GetFixtureA()->GetBody()->GetLinearVelocity().y>0.0f) {
                    contact->SetEnabled(false);
                    player.desiredRotation = 0;
                }
                
            }
        }else if ([(NSObject*)contact->GetFixtureA()->GetUserData() isKindOfClass:[JBBrush class]]
            &&worldManifold.points[0].y>contact->GetFixtureB()->GetBody()->GetWorldCenter().y) {
            JBBrush *brush = (JBBrush*)contact->GetFixtureA()->GetUserData();
            if ([brush.ID isEqualToString:jbBRUSH_PLATFORM]||[brush.ID isEqualToString:jbBRUSH_HORIZONTAL_PLATFORM]) {
                //if (worldManifold.normal.y < -0.5f) {
                if (contact->GetFixtureB()->GetBody()->GetLinearVelocity().y>0.0f) {
                    contact->SetEnabled(false);
                    player.desiredRotation = 0;
                }
            }
        }

        //Rotate a Player acording to the grounf
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
        
        //Detect Colision between two Players
        if ([(NSObject*)contact->GetFixtureA()->GetBody()->GetUserData() isKindOfClass:[CCSprite class]]&&
             [(NSObject*)contact->GetFixtureB()->GetBody()->GetUserData() isKindOfClass:[CCSprite class]]) {
                 CCSprite *cSpriteA = (CCSprite*)contact->GetFixtureA()->GetBody()->GetUserData();
                 CCSprite *cSpriteB = (CCSprite*)contact->GetFixtureB()->GetBody()->GetUserData();
            if (cSpriteA.userData != nil 
                && cSpriteB.userData !=nil 
                && [(NSObject*)cSpriteA.userData isKindOfClass:[JBHero class]] 
                && [(NSObject*)cSpriteB.userData isKindOfClass:[JBHero class]]) {
                JBHero *cHeroA = (JBHero*)cSpriteA.userData;
                JBHero *cHeroB = (JBHero*)cSpriteB.userData;
                
                if (!cHeroA.isDead && !cHeroB.isDead && contact->GetFixtureA()->GetBody()->GetWorldCenter().y>(contact->GetFixtureB()->GetBody()->GetWorldCenter().y+5.0f/PTM_RATIO)) {
                    if (cHeroB.playerID==player.playerID) {
                        NSLog(@"Player: %@ has lost a life.", cHeroB.name);
                        cHeroB.isDead=YES;
                        cHeroB.isDeadSended=NO;
                        cHeroB.killingPlayerID=cHeroA.playerID;
                    }
                } else if (!cHeroA.isDead && !cHeroB.isDead && contact->GetFixtureB()->GetBody()->GetWorldCenter().y>(contact->GetFixtureA()->GetBody()->GetWorldCenter().y+5.0f/PTM_RATIO)) {
                    if (cHeroA.playerID==player.playerID) {
                        NSLog(@"Player: %@ has lost a life.", cHeroA.name);
                        cHeroA.isDead=YES;
                        cHeroA.isDeadSended=NO;
                        cHeroA.killingPlayerID=cHeroB.playerID;
                    }
                }
                
            }
        }
        /*else if ([(NSObject*)contact->GetFixtureB()->GetBody()->GetUserData() isKindOfClass:[CCSprite class]]) {
            
        } */
    }
    void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse)
    { /* handle post-solve event */ 
    
    } 
};

@implementation JBGameLayer

@synthesize gameViewController,spawnPoints;
@synthesize tavern,mapSize;

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
#ifdef __jbDEBUG_GAMEVIEW
        
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );

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
        
        multiplayer=NO;
        sendCounter=1;
    }
    
    return self;
}

- (void)loadMap:(JBMap*)map {
    CCSprite* image = [CCSprite spriteWithFile:map.arenaImageLocal];
    
    [self addChild:image z:0];
    
    [self insertCurves:map.curves];
    [self insertEntities:map.mapEntities];
    
    
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(-map.arenaImage.size.width/2/PTM_RATIO, -map.arenaImage.size.height/2/PTM_RATIO); // bottom-left corner
    
    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.
    b2PolygonShape groundBox;		
    
    // bottom
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(map.arenaImage.size.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // top
    groundBox.SetAsEdge(b2Vec2(0,map.arenaImage.size.height/PTM_RATIO), b2Vec2(map.arenaImage.size.width/PTM_RATIO,map.arenaImage.size.height/PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    
    // left
    groundBox.SetAsEdge(b2Vec2(0,map.arenaImage.size.height/PTM_RATIO), b2Vec2(0,0));
    groundBody->CreateFixture(&groundBox,0);
    
    // right
    groundBox.SetAsEdge(b2Vec2(map.arenaImage.size.width/PTM_RATIO,map.arenaImage.size.height/PTM_RATIO), b2Vec2(map.arenaImage.size.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
    self.mapSize = map.arenaImage.size;
    
    for (NSDictionary* setting in map.settings) {
        if ([[setting objectForKey:jbID] isEqualToString:jbMAPSETTINGS_SOCCER]&&[[setting objectForKey:jbMAPSETTINGS_DATA] boolValue]) {
            [self insertBallAtPosition:CGPointMake(0, 0)];
            [self resetBall];
        }
    }
    
    [self insertHeroAtPosition:CGPointMake(0, 0)];
    
    [self setupSprites:[self.gameViewController.multiplayerAdapter.tavern getAllPlayers]];
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
            if ([(NSObject*)myActor.userData isKindOfClass:[JBHero class]]) {
                JBHero *checkHero = (JBHero*)myActor.userData;
                if (checkHero.isDead&&!checkHero.isDeadSended) {
                    [self.tavern Player:checkHero.playerID isDead:YES];
                    checkHero.isDeadSended=YES;
                }
            }
		}	
	}
    
    if (player) {
        float newX = player.sprite.position.x - [[CCDirector sharedDirector] winSize].width/2;
        float newY = player.sprite.position.y - [[CCDirector sharedDirector] winSize].height/2;
        if (newX<-self.mapSize.width/2) {
            newX=-self.mapSize.width/2;
        }
        if (newY<-self.mapSize.height/2) {
            newY=-self.mapSize.height/2;
        }
        if (newX+[[CCDirector sharedDirector] winSize].width>self.mapSize.width/2) {
            newX = self.mapSize.width/2-[[CCDirector sharedDirector] winSize].width;
        }
        if (newY+[[CCDirector sharedDirector] winSize].height>self.mapSize.height) {
            newY = self.mapSize.height/2- [[CCDirector sharedDirector] winSize].height;
        }
        
        [self.camera setCenterX:newX centerY:newY centerZ:0];
        [self.camera setEyeX:newX eyeY:newY eyeZ:1];
        
        
        if(player.onGround)
        {
            timePlayerOnGround +=(float)deltaTime;
        }else{
            timePlayerOnGround =0;
        }
        if (player.isDead) {
            [self resetOwnPositionAfterDeath];
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
    
    if (player.body!=nil&&player.body->GetLinearVelocity().y>6.5f) {
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
    
    if (tavern.ball.hitGoalLine) {
        [self resetBall];
        [self.tavern.multiplayerAdapter sendBall];
        self.tavern.ball.needsSend = FALSE;
    }
    if (tavern.ball.needsSend) {
        [self.tavern.multiplayerAdapter sendBall];
        self.tavern.ball.needsSend = FALSE;
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
#ifdef __jbDEBUG_GAMEVIEW
        line.visible = TRUE;
#endif
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
        
        
        if ([entity.bodyType isEqualToString:jbENTITY_BODYTYPE_DENSE]) {
           [self addChild:entity.sprite];
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
#ifdef __jbDEBUG_GAMEVIEW
            [self addChild:entity.sprite];
#endif
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


- (void)insertBallAtPosition:(CGPoint)position
{
    if (self.tavern!=nil) {
        tavern.ball = [JBEntityManager getEntityWithID:@"ball_04"];
        tavern.ball.shootable = YES;
        tavern.ball.sprite = [CCSprite spriteWithFile:tavern.ball.imageLocal];
        tavern.ball.sprite.scale=(50.0/tavern.ball.sprite.textureRect.size.height);
        [self addChild:tavern.ball.sprite z:0 tag:[tavern.ball.name hash]];
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        
        bodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
        bodyDef.userData = tavern.ball.sprite;
        b2Body *body = world->CreateBody(&bodyDef);
        
        b2CircleShape shape;
        shape.m_radius = 25/PTM_RATIO;
        
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &shape;	
        fixtureDef.friction = 0.1f;
        fixtureDef.density = 1.0f;
        fixtureDef.restitution = 0.050f;
        fixtureDef.userData = tavern.ball;
        body->CreateFixture(&fixtureDef);
        
        tavern.ball.sprite.userData = tavern.ball;
        tavern.ball.body=body;
    }
}

- (void)insertHeroAtPosition:(CGPoint)position
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
    player.sprite.userData=player;
    [self addChild:player.sprite z:0 tag:[player.name hash]];
    
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
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
    
    player.sprite.userData = player;
    
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

- (void)setPhysicsForBallWithPosition:(CGPoint)position velocityX:(float)x andVelocityY:(float)y {
    
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(position.x, position.y);
	bodyDef.userData = self.tavern.ball.sprite;
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
    if(self.tavern.ball.body!=nil)
        world->DestroyBody(self.tavern.ball.body);
    self.tavern.ball.body=nil;
    self.tavern.ball.body=body;
    
}

- (void)setupSprites:(NSArray*)heroes {
    for (JBHero *aHero in heroes) {
        if(aHero.playerID == player.playerID){
            continue;
        }
        aHero.sprite = [CCSprite spriteWithFile:aHero.skinLocation];
        aHero.sprite.scale=(30.0/aHero.sprite.textureRect.size.height);
        aHero.sprite.userData = aHero;
        [self addChild:aHero.sprite z:0 tag:[aHero.name hash]];

    }
}

- (void)resetOwnPositionAfterDeath {
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    CGPoint pos = [self getSpawnPositionForID:@"spawnpoint"];
    
	bodyDef.position.Set(pos.x/PTM_RATIO, pos.y/PTM_RATIO);
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

    world->DestroyBody(player.body);
    player.body=nil;
    player.body=body;
    player.isDead=NO;
}

- (CGPoint)getSpawnPositionForID:(NSString *)spawnID
{
    NSArray* spawns = [self.spawnPoints objectForKey:spawnID];
    if (spawns.count) {
        int index = rand()%spawns.count;
        JBEntity* spawn = [spawns objectAtIndex:index];
        return spawn.position;
    }
    return CGPointMake(0, 0);
}

- (void)resetBall
{
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    CGPoint pos = [self getSpawnPositionForID:@"spawnpoint_ball"];
    
    bodyDef.position.Set(pos.x/PTM_RATIO, pos.y/PTM_RATIO);
    bodyDef.userData = tavern.ball.sprite;
    b2Body *body = world->CreateBody(&bodyDef);
    
    b2CircleShape shape;
    shape.m_radius = 25/PTM_RATIO;
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;	
    fixtureDef.friction = 0.1f;
    fixtureDef.density = 1.0f;
    fixtureDef.restitution = 0.050f;
    fixtureDef.userData = tavern.ball;
    body->CreateFixture(&fixtureDef);
    
    world->DestroyBody(self.tavern.ball.body);
    self.tavern.ball.body=nil;
    self.tavern.ball.body=body;
    self.tavern.ball.hitGoalLine = 0;
}

@end
