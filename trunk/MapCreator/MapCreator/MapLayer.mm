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

#define jbSCROLLSPEED 1.5f

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

@interface MapLayer()

@property (nonatomic, retain) LineSprite* activeLine;
@property (nonatomic, retain) CCSprite* activeEntity;
@property (nonatomic, retain) NSDate* creationTimeEntity;

@end


// MapLayer implementation
@implementation MapLayer
@synthesize magnifier,userSelection,history;
//private
@synthesize activeLine,activeEntity,creationTimeEntity;

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

CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};

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
    
        self.history = [NSMutableArray array];
            
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
    if ([[[touches anyObject] view] isKindOfClass:[EAGLView class]]) {
        
        if ([touches count]==1) {
            UITouch *touch = [touches anyObject];
            CGPoint current = [touch locationInView:[touch view] ];
            float x,y,z;
            [self.camera centerX:&x centerY:&y centerZ:&z];
            
            float sliderPos =0;
            if (magnifier) {
                sliderPos = magnifier.value;
            }
            current = [[CCDirector sharedDirector] convertToGL:current];
            current = CGPointMake(x+(current.x)/(1-sliderPos*0.75)-180/(1-sliderPos*0.75)*sliderPos,
                                  y+(current.y)/(1-sliderPos*0.75)-120/(1-sliderPos*0.75)*sliderPos);
            
            if ([[userSelection objectForKey:@"kind" ] isEqualToString:@"brush"]) {
                if (!self.activeLine) {
                    self.activeLine = [LineSprite node];
                    NSMutableDictionary* historyDict = [[userSelection mutableCopy] autorelease];
                    self.activeLine.historyObj = historyDict;
                    [historyDict setObject:self.activeLine forKey:@"sprite"];
                    
                    [self.history addObject:historyDict];
                    activeLine.red = [[userSelection objectForKey:@"red"] floatValue];
                    activeLine.green = [[userSelection objectForKey:@"green"] floatValue];
                    activeLine.blue = [[userSelection objectForKey:@"blue"] floatValue];
                    activeLine.alpha = [[userSelection objectForKey:@"alpha"] floatValue];
                    [activeLine.pointArray addObject:NSStringFromCGPoint(current)];
                    
                    activeLine.visible = TRUE;
                    if ([[userSelection objectForKey:@"kind" ] isEqualToString:@"brush"]) {
                        activeLine.red = [[userSelection objectForKey:@"red"] floatValue];
                        activeLine.green = [[userSelection objectForKey:@"green"] floatValue];
                        activeLine.blue = [[userSelection objectForKey:@"blue"] floatValue];
                        activeLine.alpha = [[userSelection objectForKey:@"alpha"] floatValue];
                    }
                    [self addChild:activeLine];
                }
            }else if ([[userSelection objectForKey:@"kind" ] isEqualToString:@"entity"]) {
                NSDate* now = [NSDate date];
                float delta = [now timeIntervalSinceReferenceDate]-[creationTimeEntity timeIntervalSinceReferenceDate];
                if (delta>0.5f) {
                    self.activeEntity = [CCSprite spriteWithFile:[userSelection objectForKey:@"imageLocation"]];
                    self.activeEntity.position = current;
                    NSMutableDictionary* historyDict = [[userSelection mutableCopy] autorelease];
                    [historyDict setObject:self.activeEntity forKey:@"sprite"];
                    [self.history addObject:historyDict];
                    [self addChild:self.activeEntity];
                    self.creationTimeEntity = now;
                }
            }else{
                self.activeLine = nil;
            }
        }
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[[touches anyObject] view] isKindOfClass:[EAGLView class]]) {
        if ([touches count]==1) {
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
            
            current = CGPointMake(x+(current.x)/(1-sliderPos*0.75)-180/(1-sliderPos*0.75)*sliderPos,
                                  y+(current.y)/(1-sliderPos*0.75)-120/(1-sliderPos*0.75)*sliderPos);
            last = CGPointMake(x+(last.x)/(1-sliderPos*0.75)-180/(1-sliderPos*0.75)*sliderPos,
                               y+(last.y)/(1-sliderPos*0.75)-120/(1-sliderPos*0.75)*sliderPos);
            
            if (activeLine) {
                [activeLine.pointArray addObject:NSStringFromCGPoint(current)];
                [activeLine.pointArray addObject:NSStringFromCGPoint(last)];
            }else if(activeEntity){
                activeEntity.position = current;
            }
        }else if (touches.count==2){
            if (activeLine) {
                if (activeLine.pointArray.count>6) {
                    return;
                }else{
                    [self removeChild:activeLine cleanup:YES];
                    [self.history removeObject:activeLine.historyObj];
                    self.activeLine = nil;
                }
            }else if(activeEntity){
                [self.history removeLastObject];
                [self removeChild:self.activeEntity cleanup:YES];
                self.activeEntity = nil;
            }
            
            float x,y,z;
            [self.camera eyeX:&x eyeY:&y eyeZ:&z];
            
            NSArray* touchArray = [touches allObjects];
            
            float touchX = 0;
            float touchY = 0;
            for (int i=0; i<2; i++) {
                UITouch* touch = [touchArray objectAtIndex:i];
                touchX+=[touch locationInView:[touch view]].x
                -[touch previousLocationInView:[touch view]].x;
                touchY+=[touch locationInView:[touch view]].y
                -[touch previousLocationInView:[touch view]].y;
            }
            x = x-touchX/2 * jbSCROLLSPEED/(1-magnifier.value*0.5);
            y = y+touchY/2 * jbSCROLLSPEED/(1-magnifier.value*0.5);
            
            [self.camera setEyeX:x eyeY:y eyeZ:z];
            [self.camera setCenterX:x centerY:y centerZ:0];
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[[touches anyObject] view] isKindOfClass:[EAGLView class]]) {
        if ([touches count]==1) {
            UITouch *touch = [touches anyObject];
            CGPoint current = [touch locationInView:[touch view] ];
            float x,y,z;
            [self.camera centerX:&x centerY:&y centerZ:&z];
            
            float sliderPos =0;
            if (magnifier) {
                sliderPos = magnifier.value;
            }
            current = [[CCDirector sharedDirector] convertToGL:current];
            
            current = CGPointMake(x+(current.x)/(1-sliderPos*0.75)-180/(1-sliderPos*0.75)*sliderPos,
                                  y+(current.y)/(1-sliderPos*0.75)-120/(1-sliderPos*0.75)*sliderPos);
            
            if (activeLine) {
                [activeLine.pointArray addObject:NSStringFromCGPoint(current)];
                
                float length = 0;
                if (activeLine.pointArray.count) {
                    CGPoint start = CGPointFromString([activeLine.pointArray objectAtIndex:0]);
                    CGPoint end;
                    for (int i=1; i<activeLine.pointArray.count; i++) {
                        end = CGPointFromString([activeLine.pointArray objectAtIndex:i]);
                        length +=DistanceBetweenTwoPoints(start, end);
                    }
                }
                NSLog(@"length: %f",length);
                if (length<15) {
                    [self removeChild:activeLine cleanup:YES];
                    [self.history removeObject:activeLine.historyObj];
                }
            }
            
            self.activeLine = nil;
            self.activeEntity = nil;
        }
    }
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
