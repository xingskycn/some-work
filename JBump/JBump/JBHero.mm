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
@synthesize body;

- (id)initWithNode:(CCNode*)parent {
    self = [super init];
    
    if (self) {
        JBSkin *heroSkin = [JBSkinManager getSkinWithID:[[NSUserDefaults standardUserDefaults] objectForKey:@"skinID"]];
        self.sprite = [CCSprite spriteWithFile:heroSkin.imageLocation];
        self.sprite.scale=(30.0/self.sprite.textureRect.size.height);
        [parent addChild:sprite z:0 tag:[@"Player" hash]];
    }
    
    return self;
    
}

@end
