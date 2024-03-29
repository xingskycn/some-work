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
                if(contact->GetFixtureA()->GetUserData()) {
                    if ([(NSObject *)contact->GetFixtureA()->GetUserData() isKindOfClass:[JBHero class]]) {
                        JBHero* hero = (JBHero *)contact->GetFixtureA()->GetUserData();
                        if (hero.jumpTouched) 
                        {
                            if (hero.body->GetWorldCenter().y<entity.body->GetWorldCenter().y) {
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
            if([entity.ID isEqualToString:@"deadly_2"])
            {
                if(contact->GetFixtureA()->GetUserData()) {
                    if ([(NSObject *)contact->GetFixtureA()->GetUserData() isKindOfClass:[JBHero class]]) {
                        JBHero* hero = (JBHero *)contact->GetFixtureA()->GetUserData();
                        hero.isDead = TRUE;
                    }
                }
                contact->SetEnabled(false);
            }
        }
        
        if ([(NSObject*)contact->GetFixtureA()->GetUserData() isKindOfClass:[JBEntity class]])
        {
            JBEntity* entity = (JBEntity*)contact->GetFixtureA()->GetUserData();
            if (entity.shootable) 
            {
                if(contact->GetFixtureB()->GetUserData()) {
                    if ([(NSObject *)contact->GetFixtureB()->GetUserData() isKindOfClass:[JBHero class]]) {
                        JBHero* hero = (JBHero *)contact->GetFixtureB()->GetUserData(); 
                        if (hero.body->GetWorldCenter().y<entity.body->GetWorldCenter().y) 
                        {
                            if (hero.jumpTouched) 
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
            if([entity.ID isEqualToString:@"deadly_2"])
            {
                if(contact->GetFixtureB()->GetUserData()) {
                    if ([(NSObject *)contact->GetFixtureB()->GetUserData() isKindOfClass:[JBHero class]]) {
                        JBHero* hero = (JBHero *)contact->GetFixtureB()->GetUserData();
                        hero.isDead = TRUE;
                        
                    }
                }
                contact->SetEnabled(false);
            }
        }
        
        
        if ([(NSObject*)contact->GetFixtureB()->GetUserData() isKindOfClass:[JBBrush class]]
            &&worldManifold.points[0].y>contact->GetFixtureA()->GetBody()->GetWorldCenter().y
            &&contact->GetFixtureA()->GetUserData()!=nil
            &&[(NSObject *)contact->GetFixtureA()->GetUserData() isKindOfClass:[JBHero class]]) {
            JBBrush *brush = (JBBrush*)contact->GetFixtureB()->GetUserData();
            JBHero *hero = (JBHero *)contact->GetFixtureA()->GetUserData();
            if ([brush.ID isEqualToString:jbBRUSH_PLATFORM]||[brush.ID isEqualToString:jbBRUSH_HORIZONTAL_PLATFORM]) {
                //if (worldManifold.normal.y < 0.2f) {
                if (contact->GetFixtureA()->GetBody()->GetLinearVelocity().y>0.0f) {
                    contact->SetEnabled(false);
                    hero.desiredRotation = 0;
                }
                
            }
        }else if ([(NSObject*)contact->GetFixtureA()->GetUserData() isKindOfClass:[JBBrush class]]
            &&worldManifold.points[0].y>contact->GetFixtureB()->GetBody()->GetWorldCenter().y
            &&contact->GetFixtureB()->GetUserData()!=nil&&[((NSObject*)contact->GetFixtureB()->GetUserData()) isKindOfClass:[JBHero class]]) {
            
            JBHero *hero = (JBHero*)contact->GetFixtureB()->GetUserData();
            
            JBBrush *brush = (JBBrush*)contact->GetFixtureA()->GetUserData();
            if ([brush.ID isEqualToString:jbBRUSH_PLATFORM]||[brush.ID isEqualToString:jbBRUSH_HORIZONTAL_PLATFORM]) {
                //if (worldManifold.normal.y < -0.5f) {
                if (contact->GetFixtureB()->GetBody()->GetLinearVelocity().y>0.0f) {
                    contact->SetEnabled(false);
                    hero.desiredRotation = 0;
                }
            }
        }

        //Rotate a Player acording to the grounf
        if(contact->GetFixtureA()->GetUserData()) {
            if ([(NSObject *)contact->GetFixtureA()->GetUserData() isKindOfClass:[JBHero class]]) {
                JBHero* hero = (JBHero *)contact->GetFixtureA()->GetUserData(); 
                float product = -acosf(worldManifold.normal.x)*180/M_PI+90;
                
                hero.desiredRotation = product;
                
                if (worldManifold.normal.y > 0.5f) {
                    hero.onGround=true; 
                }
            }
        }   
        if(contact->GetFixtureB()->GetUserData()) {
            if ([(NSObject *)contact->GetFixtureB()->GetUserData() isKindOfClass:[JBHero class]]) {
                JBHero* hero = (JBHero *)contact->GetFixtureB()->GetUserData(); 
                float product = -acosf(worldManifold.normal.x)*180/M_PI+90;
                
                hero.desiredRotation = product;
                
                if (worldManifold.normal.y > 0.5f) {
                    hero.onGround=true; 
                }
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
                        NSLog(@"Player: %@ has lost a life.", cHeroB.name);
                        cHeroB.isDead=YES;
                        cHeroB.isDeadSended=NO;
                        cHeroB.killingPlayerID=cHeroA.playerID;
                } else if (!cHeroA.isDead && !cHeroB.isDead && contact->GetFixtureB()->GetBody()->GetWorldCenter().y>(contact->GetFixtureA()->GetBody()->GetWorldCenter().y+5.0f/PTM_RATIO)) {
                        NSLog(@"Player: %@ has lost a life.", cHeroA.name);
                        cHeroA.isDead=YES;
                        cHeroA.isDeadSended=NO;
                        cHeroA.killingPlayerID=cHeroB.playerID;
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
@synthesize isServer;
@synthesize gameType;
@synthesize deadlies;

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
        self.deadlies = [NSMutableArray array];
        
        [self schedule:@selector(tick:)];
        
        multiplayer=NO;
        sendCounter=1;
        self.isServer=NO;
    }
    
    return self;
}

- (void)loadMap:(JBMap*)map {
    CCSprite* image = [CCSprite spriteWithFile:map.arenaImageLocal];
    
    NSArray* allHeroIDs = [[[tavern.heroesInTavern allKeys] retain] autorelease];
    self.isServer = YES;
    for(NSString* heroID in allHeroIDs) {
        if (self.tavern.localPlayer.playerID>[heroID intValue]) {
            self.isServer=NO;
        }
    }
    
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
    
    [self insertHero:nil atPosition:CGPointMake(0, 0)];
    
    NSArray* allHeroes = [[[self.tavern.heroesInTavern allValues] retain] autorelease];
    for (JBHero *aHero in allHeroes) {
        [aHero.gameContext setObject:@"0" forKey:jbGAMECONTEXT_KILL_COUNT];
    }
    
    for (NSDictionary* setting in map.settings) {
        if ([[setting objectForKey:jbID] isEqualToString:jbMAPSETTINGS_SOCCER]&&[[setting objectForKey:jbMAPSETTINGS_DATA] boolValue])
        {
            JBEntity* ball = [JBEntityManager getEntityWithID:@"ball_04"];
            [self.tavern.entitiesInTavern addObject:ball];
            ball.shootable = YES;
            self.gameType = jbMAPSETTINGS_SOCCER;
            for (JBHero *aHero in allHeroes) {
                [aHero.gameContext setObject:@"0" forKey:jbGAMECONTEXT_GOALS];
            }
        }
    }
    
    [self setupHeroSprites:[self.tavern getAllPlayers]];
    [self setupEntitySprites:self.tavern.entitiesInTavern];
}

- (void)tick:(ccTime)deltaTime{
    
    NSArray* allHeroIDs = [[[tavern.heroesInTavern allKeys] retain] autorelease];
    self.isServer = YES;
    for(NSString* heroID in allHeroIDs) {
        if (self.tavern.localPlayer.playerID>[heroID intValue]) {
            //[self.tavern.multiplayerAdapter sendBall];
            self.isServer=NO;
        }
    }
    [self spawnDeadlies];
    
    if (self.isServer) {
        
        [tavern testForBodies];
        
        NSArray* allHeroes = [[[self.tavern.heroesInTavern allValues] retain] autorelease];
        for (JBHero *aHero in allHeroes) {
            aHero.onGround=NO;
        }
        
        //player.onGround=NO;
        int32 velocityIterations = 8;
        int32 positionIterations = 1;
        if (self.isServer) {
            world->Step(deltaTime, velocityIterations, positionIterations);
        }
        
        
        for (b2Body* body = world->GetBodyList(); body; body = body->GetNext())
        {
            if (body->GetUserData() != NULL) {
                if ([(NSObject*)body->GetUserData() isKindOfClass:[JBBrush class]]) {
                    continue;
                }
                CCSprite *myActor = (CCSprite*)body->GetUserData();
                myActor.position = CGPointMake( body->GetPosition().x * PTM_RATIO,
                                               body->GetPosition().y * PTM_RATIO);
                bool rotate=YES;
                if (myActor.userData&&[(id)myActor.userData isKindOfClass:[JBHero class]]) {
                    rotate=NO;
                }
                if(rotate){
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
        
        NSString* userInput = @"";
        if (self.gameViewController.moveLeftButton.isTouchInside) {
            userInput = [userInput stringByAppendingString:@"L"];
        }else{
            userInput = [userInput stringByAppendingString:@"X"];
        }
        if (self.gameViewController.moveRightButton.isTouchInside) {
            userInput = [userInput stringByAppendingString:@"R"];
        }else{
            userInput = [userInput stringByAppendingString:@"X"];
        }
        if (self.gameViewController.jumpButton.isTouchInside) {
            userInput = [userInput stringByAppendingString:@"J"];
            
        } else {
            if ([[player.userInput substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"J"]) {
                player.jumpTouched = NO;
            }
            userInput = [userInput stringByAppendingString:@"X"];
        }
        player.userInput = userInput;
        
        for (JBHero* hero in allHeroes)
        {
            [self performUserInputsOnHero:hero withTimeDelta:(float)deltaTime];
            [hero.sprite setRotation:hero.desiredRotation+((hero.sprite.rotation-hero.desiredRotation)/1.14)];
            
            if (hero.body!=nil&&hero.body->GetLinearVelocity().y>6.5f) {
                hero.body->SetLinearVelocity(b2Vec2(hero.body->GetLinearVelocity().x, 6.5f));
            }
            
            if (hero.isDead) {
                [self resetPositionAfterDeathForPlayer:hero];
            }
        }
        
        for (JBEntity* entity in self.tavern.entitiesInTavern)
        {
            if (entity.hitGoalLine==1) {
                int goals = [[self.tavern.localPlayer.gameContext objectForKey:jbGAMECONTEXT_GOALS] intValue];
                goals++;
                [self.tavern.localPlayer.gameContext setObject:[NSString stringWithFormat:@"%i", goals] forKey:jbGAMECONTEXT_GOALS];
                [self.gameViewController.scoreTableView reloadData];
                [self.tavern.multiplayerAdapter shoutPlayerGameContextChange:self.tavern.localPlayer];
            }
            else if (entity.hitGoalLine==2) {
                NSArray* allHeros = [[[tavern.heroesInTavern allValues] retain] autorelease];
                for (JBHero *aHero in allHeros) {
                    if (aHero.playerID!=self.tavern.localPlayer.playerID) {
                        int goals = [[aHero.gameContext objectForKey:jbGAMECONTEXT_GOALS] intValue];
                        goals++;
                        [aHero.gameContext setObject:[NSString stringWithFormat:@"%i", goals] forKey:jbGAMECONTEXT_GOALS];
                        [self.gameViewController.scoreTableView reloadData];
                        [self.tavern.multiplayerAdapter shoutPlayerGameContextChange:aHero];
                    }
                }
            }
            if (entity.hitGoalLine) {
                [self resetPositionForEntity:entity];
            }
        }
        
        [self.tavern sendPlayerUpdate];
    }else {
        NSString *userInput = @"";
        if (gameViewController.moveLeftButton.isTouchInside) {
            userInput = [userInput stringByAppendingString:@"L"];
        } else {
            userInput = [userInput stringByAppendingString:@"X"];
        }
        if (gameViewController.moveRightButton.isTouchInside) {
            userInput = [userInput stringByAppendingString:@"R"];
        } else {
            userInput = [userInput stringByAppendingString:@"X"];
        }
        if (gameViewController.jumpButton.isTouchInside) {
            userInput = [userInput stringByAppendingString:@"J"];
        } else {
            userInput = [userInput stringByAppendingString:@"X"];
        }
        
        [self.tavern.multiplayerAdapter sendUserInput:userInput];

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

- (void)insertHero:(JBHero *)hero atPosition:(CGPoint)position
{
    if (!hero) {
        if (self.tavern!=nil) {
            hero = self.tavern.localPlayer;
            player = hero;
            multiplayer=YES;
            JBSkin *heroSkin = [JBSkinManager getSkinWithID:hero.skinID];
            if (self.gameType == jbMAPSETTINGS_SOCCER) {
                hero.sprite = [CCSprite spriteWithFile:heroSkin.imageLocation];
            }else{
                if (self.isServer) {
                    hero.sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_red",heroSkin.imageLocation]];
                }else{
                    hero.sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_blue",heroSkin.imageLocation]];
                }
                
            }
            hero.sprite.scale=(30.0/hero.sprite.textureRect.size.height);
            hero.sprite.userData=hero;
            [self addChild:hero.sprite z:0 tag:[hero.name hash]];
        } else {
            hero = [[JBHero alloc] init];
            hero.name = [[NSUserDefaults standardUserDefaults] objectForKey:jbUSERDEFAULTS_PLAYER_NAME];
            hero.skinID = [[NSUserDefaults standardUserDefaults] objectForKey:jbUSERDEFAULTS_SKIN];
            JBSkin *heroSkin = [JBSkinManager getSkinWithID:hero.skinID];
            hero.sprite = [CCSprite spriteWithFile:heroSkin.imageLocation];
            hero.sprite.scale=(30.0/hero.sprite.textureRect.size.height);
            hero.sprite.userData=hero;
            [self addChild:hero.sprite z:0 tag:[hero.name hash]];
        }
    }
    
    position = [self getSpawnPositionForID:@"spawnpoint"];
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
	bodyDef.userData = hero.sprite;
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
    fixtureDef.userData = hero;
	body->CreateFixture(&fixtureDef);
    
    hero.sprite.userData = hero;
    
    hero.body=body;
}

- (void)insertEntity:(JBEntity *)entity atPosition:(CGPoint)position
{
    if (entity.shootable) {
        position = [self getSpawnPositionForID:@"spawn_ball"];
    }
    
    if (!entity.sprite) {
        entity.sprite = [CCSprite spriteWithFile:entity.imageLocal];
        [self addChild:entity.sprite z:0 tag:[@"deadly" hash]];
    }
    
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
	bodyDef.userData = entity.sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
    b2CircleShape shape;
    shape.m_radius = entity.sprite.textureRect.size.width/2/PTM_RATIO;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;	
	fixtureDef.friction = 0.1f;
    fixtureDef.density = 1.0f;
    fixtureDef.restitution = 0.050f;
    fixtureDef.userData = entity;
	body->CreateFixture(&fixtureDef);
    
    entity.sprite.userData = entity;
    
    entity.body=body;
}

- (void)setupHeroSprites:(NSArray*)heroes {
    for (JBHero *aHero in heroes) {
        if(aHero.playerID == player.playerID){
            continue;
        }
        
        if (self.gameType == jbMAPSETTINGS_SOCCER) {
            aHero.sprite = [CCSprite spriteWithFile:aHero.skinLocation];
        }else{
            if (self.isServer) {
                aHero.sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_blue",aHero.skinLocation]];
            }else{
                aHero.sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_red",aHero.skinLocation]];
            }
            
        }
        aHero.sprite = [CCSprite spriteWithFile:aHero.skinLocation];
        aHero.sprite.scale=(30.0/aHero.sprite.textureRect.size.height);
        aHero.sprite.userData = aHero;
        [self addChild:aHero.sprite z:0 tag:[aHero.name hash]];

    }
}

- (void)setupEntitySprites:(NSArray *)entities
{
    for (JBEntity *entity in entities) {
        entity.sprite = [CCSprite spriteWithFile:entity.imageLocal];
        entity.sprite.userData = entity;
        [self addChild:entity.sprite z:0 tag:[entity.ID hash]];
        
    }
}


- (void)resetPositionAfterDeathForPlayer:(JBHero*)aHero {
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    CGPoint pos = [self getSpawnPositionForID:@"spawnpoint"];
    
	bodyDef.position.Set(pos.x/PTM_RATIO, pos.y/PTM_RATIO);
	bodyDef.userData = aHero.sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
    b2CircleShape shape;
    shape.m_radius = 0.45f;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;	
	fixtureDef.friction = 0.1f;
    fixtureDef.density = 1.0f;
    fixtureDef.restitution = 0.050f;
    fixtureDef.userData = aHero;
	body->CreateFixture(&fixtureDef);

    world->DestroyBody(aHero.body);
    aHero.body=nil;
    aHero.body=body;
    aHero.isDead=NO;
    aHero.isDeadSended=YES;
}

- (void)resetPositionForEntity:(JBEntity*)entity {
    b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    CGPoint pos = [self getSpawnPositionForID:@"spawnpoint_ball"];
    
	bodyDef.position.Set(pos.x/PTM_RATIO, pos.y/PTM_RATIO);
	bodyDef.userData = entity.sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
    b2CircleShape shape;
    shape.m_radius = entity.sprite.textureRect.size.width/2/PTM_RATIO;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;	
	fixtureDef.friction = 0.1f;
    fixtureDef.density = 1.0f;
    fixtureDef.restitution = 0.050f;
    fixtureDef.userData = entity;
	body->CreateFixture(&fixtureDef);
    
    world->DestroyBody(entity.body);
    entity.body=nil;
    entity.body=body;
    entity.hitGoalLine = 0;
    entity.needsSend = 0;
}

- (void)spawnDeadlies{
    for (JBEntity* spawn in [self.spawnPoints objectForKey:@"spawnpoint_deadly"]) {
        if(rand()%10005/10000.f>1-0.002)
        {
            JBEntity* entity = [[JBEntityManager getEntityWithID:@"deadly_2"] retain];
            [self insertEntity:entity atPosition:spawn.position];
            [self.deadlies addObject:entity];
            [entity autorelease];
        }
    }
    NSMutableArray* toDelete = [NSMutableArray array];
    for (JBEntity* entity in self.deadlies) {
        if (entity.sprite.position.y<-1000) {
            [toDelete addObject:entity];
            [self removeChild:entity.sprite cleanup:YES];
            world->DestroyBody(entity.body);
            entity.body = nil;
            entity.sprite = nil;
        }
    }
    for (JBEntity* entity in toDelete) {
        [self.deadlies removeObject:entity];
    }
    [toDelete removeAllObjects];
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

- (void)performUserInputsOnHero:(JBHero*)hero withTimeDelta:(float)timeDelta {
    NSString *userInput = hero.userInput;
    if ([[userInput substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"J"]) {
        [hero jump:(float)timeDelta timeOnGround:0.1f];
        hero.jumpTouched = YES;
    }
    
    if ([[userInput substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"L"]) {
        [hero moveLeft:(float)timeDelta];
    }
    
    if ([[userInput substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"R"]) {
        [hero moveRight:(float)timeDelta];
    }
    if (!hero.onGround) {
        if (hero.sprite.rotation<180) {
            hero.desiredRotation=0;
        }
    }
}

@end
