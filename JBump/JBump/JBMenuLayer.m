//
//  JBMenuLayer.m
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JBMenuLayer.h"

@implementation JBMenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	JBMenuLayer *layer = [JBMenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init {
    self = [super init];
    
    if (self) {
        CCSprite *sprite = [CCSprite spriteWithFile:@"island.png"];
        sprite.position = CGPointMake(0, 0);
        [self addChild:sprite];
    }
    
    return self;
}
@end
