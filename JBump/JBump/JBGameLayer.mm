//
//  JBGameLayer.m
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JBGameLayer.h"


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

- (id)init {
    self = [super init];
    
    if (self) {
    }
    
    return self;
}


@end
