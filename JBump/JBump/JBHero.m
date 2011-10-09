//
//  JBHero.m
//  JBump
//
//  Created by Sebastian Pretscher on 10.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBHero.h"
#import "cocos2d.h"
#import "JBSkinManager.h"
#import "JBSkin.h"

@implementation JBHero

@synthesize sprite;
@synthesize friction, restitution;

- (id)initWithSprite:(CCNode*)parent {
    self = [super init];
    
    if (self) {
        JBSkin *heroSkin = [JBSkinManager getSkinWithID:[[NSUserDefaults standardUserDefaults] objectForKey:@"skinID"]];
        self.sprite = [CCSprite spriteWithFile:heroSkin.imageLocation];
        //[parent addChild:sprite z:0 tag:2];
    }
    
    return self;
    
}

@end
