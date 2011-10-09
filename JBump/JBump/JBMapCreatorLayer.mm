//
//  JBMapCreatorLayer.m
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBMapCreatorLayer.h"

#import "JBLineSprite.h"

#define jbSCROLLSPEED 1.5f

@interface JBMapCreatorLayer()

@property (nonatomic, retain) JBLineSprite* activeLine;
@property (nonatomic, retain) CCSprite* activeEntity;
@property (nonatomic, retain) NSDate* creationTimeEntity;

@end

@implementation JBMapCreatorLayer
@synthesize magnifier,userSelection,history;
//private
@synthesize activeLine,activeEntity,creationTimeEntity;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	JBMapCreatorLayer *layer = [JBMapCreatorLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer z:0 tag:0];
	
	// return the scene
	return scene;
}

CGFloat DistanceBetweenPoints(CGPoint point1,CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};



- (id)init
{
    self = [super init];
    if (self) {
		self.isTouchEnabled = YES;
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
                    self.activeLine = [JBLineSprite node];
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
                        length +=DistanceBetweenPoints(start, end);
                    }
                }
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

- (void) dealloc
{
    self.magnifier = nil;
    self.userSelection = nil;
    self.history = nil;
    self.activeLine = nil;
    self.activeEntity = nil;
    self.creationTimeEntity = nil;
	[super dealloc];
}

@end
