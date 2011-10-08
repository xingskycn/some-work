//
//  HelloWorldLayer.mm
//  Frapp
//
//  Created by Nils Ziehn on 10/7/11.
//  Copyright ziehn.org 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Map.h"
#import "DELineSprite.h"
#import "AppDelegate.h"



//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


class MyContactListener : public b2ContactListener
{
public:
    void Add(const b2ContactPoint* point)
    {
        //Handle add point
    }
    void Persist(const b2ContactPoint* point)
    {
        // handle persist point
    }
    void Remove(const b2ContactPoint* point)
    {
        // handle remove point
    }
    void Result(const b2ContactResult* point)
    {
        // handle results
    }
    
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
    {
        b2WorldManifold worldManifold;
        
        contact->GetWorldManifold(&worldManifold);
        
        if (worldManifold.normal.y < -0.5f)   
        {
            contact->SetEnabled(false);
        }
    }
};


// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        map = [Map new];
		map.width = 75 ;
        map.height = 75;
        map.mapFieldDef = (char *)malloc(sizeof(char)*5625);
        for (int i=0; i<map.width; i++) {
            for (int j=0; j<map.height; j++) {
                if((i*j)%2+(2*i*j)%3) {
                    map.mapFieldDef[i+map.width*j] = 0;
                }else   
                {
                    map.mapFieldDef[i+map.width*j] = 1;
                }
            }
        }
        
        
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -10.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
		flags += b2DebugDraw::e_jointBit;
//		flags += b2DebugDraw::e_aabbBit;
//		flags += b2DebugDraw::e_pairBit;
//		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);		
		
		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
		// bottom
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(map.width*40/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// top
		groundBox.SetAsEdge(b2Vec2(0,40*map.height/PTM_RATIO), b2Vec2(map.width*40/PTM_RATIO,map.height*40/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		
		// left
		groundBox.SetAsEdge(b2Vec2(0,40*map.height/PTM_RATIO), b2Vec2(0,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// right
		groundBox.SetAsEdge(b2Vec2(40*map.width/PTM_RATIO,40*map.height/PTM_RATIO), b2Vec2(40*map.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		
		//Set up sprite
		
        CCSprite * back = [CCSprite spriteWithFile:@"behindall.png"];
        back.position = CGPointMake(1500, 1500);
        [self addChild:back];
        
        
        CCSprite * mapImg = [CCSprite spriteWithFile:@"back.png"];
        mapImg.position = CGPointMake(1500, 1500);
        [self addChild:mapImg];
		CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"singleField.png" capacity:150];
		[self addChild:batch z:0 tag:kTagBatchNode];
		
        CCSprite * overlay = [CCSprite spriteWithFile:@"overlay.png"];
        overlay.position = CGPointMake(1500, 1500);
        [self addChild:overlay];
        
        
		//[self addNewSpriteWithCoords:ccp(screenSize.width/2, screenSize.height/2)];
		
		label = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( screenSize.width/2, screenSize.height-50);
        
        for (int i=0; i<map.width; i++) {
            for (int j=0; j<map.height; j++) {
                if (map.mapFieldDef[i+map.width*j]) {
                        //[self addNewSpriteWithCoords:CGPointMake(20+40*i, 20+40*j)];
                }

            }
        }
		
        //world->SetContactListener(new MyContactListener);
        
		[self schedule: @selector(tick:)];
	}
	return self;
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}



-(void) tick: (ccTime) dt
{
    if (drawLineEnabled) {
        
    }
    
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);

	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
            
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
    if (player) {
        
        float newX = player->GetPosition().x*PTM_RATIO - [[CCDirector sharedDirector] winSize].width/2;
        float newY = player->GetPosition().y*PTM_RATIO - [[CCDirector sharedDirector] winSize].height/2;
        
        UISlider* slider = ((AppDelegate *)[UIApplication sharedApplication].delegate ).slider;
        float sliderPos = slider.value;
        
        [self.camera setCenterX:newX centerY:newY centerZ:0];
        [self.camera setEyeX:newX eyeY:newY eyeZ:1];
        [self setScale:1-sliderPos*0.5];
        
    }else{
        CCLOG(@"camerapos: %@",self.camera);
    }
    
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"the touch is at %@",NSStringFromCGPoint([touch locationInView:[touch view]]));
    activeLine = [DELineSprite node];
    [self addChild:activeLine];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint current = [touch locationInView:[touch view] ];
    CGPoint last = [touch previousLocationInView:[touch view]];
    
    float x,y,z;
    [self.camera centerX:&x centerY:&y centerZ:&z];
    current = [[CCDirector sharedDirector] convertToGL:current];
    last = [[CCDirector sharedDirector] convertToGL:last];
    
    UISlider* slider = ((AppDelegate *)[UIApplication sharedApplication].delegate ).slider;
    float sliderPos = slider.value;
    
    current = CGPointMake(x +[[CCDirector sharedDirector] winSize].width/2 + 
                          (current.x-[[CCDirector sharedDirector] winSize].width/2)/(1-sliderPos*0.5),
                          y +[[CCDirector sharedDirector] winSize].height/2 + 
                          (current.y-[[CCDirector sharedDirector] winSize].height/2)/(1-sliderPos*0.5));
    last = CGPointMake(x +[[CCDirector sharedDirector] winSize].width/2 + 
                          (last.x-[[CCDirector sharedDirector] winSize].width/2)/(1-sliderPos*0.5),
                          y +[[CCDirector sharedDirector] winSize].height/2 + 
                          (last.y-[[CCDirector sharedDirector] winSize].height/2)/(1-sliderPos*0.5));
    
    // throw to console my inappropriate touches
    //NSLog(@"current x=%2f,y=%2f",currentTouchArea.x, currentTouchArea.y);
    //NSLog(@"last x=%2f,y=%2f",lastTouchArea.x, lastTouchArea.y);  
    
    // add my touches to the naughty touch array 
    [activeLine.touchArray addObject:NSStringFromCGPoint(current)];
    [activeLine.touchArray addObject:NSStringFromCGPoint(last)];
}

CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (activeLine.touchArray.count) {
        CGPoint last = CGPointFromString([activeLine.touchArray objectAtIndex:0]);
        b2BodyDef newMapDef;
        newMapDef.position.Set(0, 0); // bottom-left corner
        
        b2Body* newMapBody = world->CreateBody(&newMapDef);
        
        b2PolygonShape newMapShape;		
        
        
        
        
        for (int i=0; i<activeLine.touchArray.count; i++) {
            CGPoint current = CGPointFromString([activeLine.touchArray objectAtIndex:i]);
            float dist = DistanceBetweenTwoPoints(last, current);
            if (dist>15) {
                newMapShape.SetAsEdge(b2Vec2(last.x/PTM_RATIO,last.y/PTM_RATIO), b2Vec2(current.x/PTM_RATIO,current.y/PTM_RATIO));
                newMapBody->CreateFixture(&newMapShape,0);
                last = current;
            }
        }
    }
    
    
    //Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
        float x,y,z;
        [self.camera eyeX:&x eyeY:&y eyeZ:&z];
        
        UISlider* slider = ((AppDelegate *)[UIApplication sharedApplication].delegate ).slider;
        float sliderPos = slider.value;
        
        
        
        location = CGPointMake(x +[[CCDirector sharedDirector] winSize].width/2 + 
                               (location.x-[[CCDirector sharedDirector] winSize].width/2)/(1-sliderPos*0.5),
                               y +[[CCDirector sharedDirector] winSize].height/2 + 
                               (location.y-[[CCDirector sharedDirector] winSize].height/2)/(1-sliderPos*0.5));
        
		[self addNewBallWithCoords: location];
        
	}
}



- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * 10, accelX * 10);
	
	world->SetGravity( gravity );
}


 
-(void) addNewSpriteWithCoords:(CGPoint)p
{
    CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
    CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
 
    CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(0,0,40,40)];
    [batch addChild:sprite];
 
    sprite.position = ccp( p.x, p.y);
 
    // Define the dynamic body.
    //Set up a 1m squared box in the physics world
    b2BodyDef bodyDef;
 
    bodyDef.type = b2_staticBody;
    //bodyDef.type = b2_dynamicBody;
 
    bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    bodyDef.userData = sprite;
    b2Body *body = world->CreateBody(&bodyDef);
 
    // Define another box shape for our dynamic body.
    b2PolygonShape dynamicBox;
    dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
 
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;	
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    body->CreateFixture(&fixtureDef);
 
    [label setString:[NSString stringWithFormat:@"%d",[label.string intValue]+1]];
}

-(void) addNewBallWithCoords:(CGPoint)p
{
    CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
    CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
    
    CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(0,0,40,40)];
    [batch addChild:sprite];
    
    sprite.position = ccp( p.x, p.y);
    
    // Define the dynamic body.
    //Set up a 1m squared box in the physics world
    b2BodyDef bodyDef;
    
    //bodyDef.type = b2_staticBody;
    bodyDef.type = b2_dynamicBody;
    
    bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    bodyDef.userData = sprite;
    b2Body *body = world->CreateBody(&bodyDef);
    
    // Define another box shape for our dynamic body.
    b2PolygonShape dynamicBox;
    dynamicBox.SetAsBox(0.5f, 0.5f);//These are mid points for our 1m box
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;	
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    body->CreateFixture(&fixtureDef);
    player = body;
    
    [label setString:[NSString stringWithFormat:@"%d",[label.string intValue]+1]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;

	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
