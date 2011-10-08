//
//  MapLayer.mm
//  MapCreator
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright ziehn.org 2011. All rights reserved.
//


// Import the interfaces
#import "MapLayer.h"
#import "LineSprite.h"

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


// MapLayer implementation
@implementation MapLayer
@synthesize magnifier;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MapLayer *layer = [MapLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer z:0 tag:0];
	
	// return the scene
	return scene;
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

- (id)init
{
    self = [super init];
    if (self) {
        
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
    
        
            
        [self schedule: @selector(tick:)];
    }
    return self;
}

-(void) tick: (ccTime) dt
{
    
    float sliderPos =0;
    if (magnifier) {
        sliderPos = magnifier.value;
    }

    [self setScale:1-sliderPos*0.75];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    cameraVelocity = CGPointMake(cameraVelocity.x+acceleration.x,cameraVelocity.y+acceleration.y);
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    activeLine = [LineSprite node];
    UITouch *touch = [touches anyObject];
    CGPoint current = [touch locationInView:[touch view] ];
    float x,y,z;
    [self.camera centerX:&x centerY:&y centerZ:&z];
    
    float sliderPos =0;
    if (magnifier) {
        sliderPos = magnifier.value;
    }
    current = [[CCDirector sharedDirector] convertToGL:current];
    current = CGPointMake(x +[[CCDirector sharedDirector] winSize].width/2 + 
                          (current.x-[[CCDirector sharedDirector] winSize].width/2)/(1-sliderPos*0.5),
                          y +[[CCDirector sharedDirector] winSize].height/2 + 
                          (current.y-[[CCDirector sharedDirector] winSize].height/2)/(1-sliderPos*0.5));
    [activeLine.pointArray addObject:NSStringFromCGPoint(current)];
    
    activeLine.visible = TRUE;
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
    
    float sliderPos =0;
    if (magnifier) {
        sliderPos = magnifier.value;
    }
    
    current = CGPointMake((x+current.x)/(1-sliderPos*0.75),
                          (y+current.y)/(1-sliderPos*0.75));
    last = CGPointMake((x+last.x)/(1-sliderPos*0.75),
                       (y+last.y)/(1-sliderPos*0.75));
    
    [activeLine.pointArray addObject:NSStringFromCGPoint(current)];
    [activeLine.pointArray addObject:NSStringFromCGPoint(last)];
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint current = [touch locationInView:[touch view] ];
    float x,y,z;
    [self.camera centerX:&x centerY:&y centerZ:&z];
    
    float sliderPos =0;
    if (magnifier) {
        sliderPos = magnifier.value;
    }
    current = CGPointMake((x+current.x)/(1-sliderPos*0.75),
                          (y+current.y)/(1-sliderPos*0.75));

    [activeLine.pointArray addObject:NSStringFromCGPoint(current)];
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

- (void)enteredMode:(int)mode
{
    
}


@end
