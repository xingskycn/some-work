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

@synthesize onGround;
@synthesize jumpForce;

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

- (void)jump:(float)time {
    if(onGround) {
        jumpForce=1.0f;
        
        body->ApplyForce(b2Vec2(0, (10*jumpForce)), body->GetLocalCenter());
    }else {
        jumpForce=jumpForce*exp(log(0.9)*time*(1000*0.8));
        body->ApplyForce(b2Vec2(0, (10*jumpForce)), body->GetLocalCenter());
    }
    
}
@end
