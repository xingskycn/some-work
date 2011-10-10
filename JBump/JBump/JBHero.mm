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

@synthesize maxLeft, maxRight;

- (id)initWithNode:(CCNode*)parent {
    self = [super init];
    
    if (self) {
        JBSkin *heroSkin = [JBSkinManager getSkinWithID:[[NSUserDefaults standardUserDefaults] objectForKey:@"skinID"]];
        maxLeft=-5.0f;
        maxRight=5.0f;
        self.sprite = [CCSprite spriteWithFile:heroSkin.imageLocation];
        self.sprite.scale=(30.0/self.sprite.textureRect.size.height);
        [parent addChild:sprite z:0 tag:[@"Player" hash]];
    }
    
    return self;
    
}

- (void)jump:(float)time {
    if(onGround) {
        jumpForce=1.0f;
        NSLog(@"TimeDelta: %f",(time*60));
        body->ApplyForce(b2Vec2(0, (55*time*60*jumpForce)), body->GetLocalCenter());
    }else {
        jumpForce=jumpForce*exp(log(0.993)*time*1000);
        body->ApplyForce(b2Vec2(0, (55*time*60*jumpForce)), body->GetLocalCenter());
    }
    
}

- (void)moveLeft:(float)time {
    b2Vec2 velocity = body->GetLinearVelocityFromLocalPoint(body->GetLocalCenter());
    
    if (velocity.x>maxLeft) {
        body->ApplyForce(b2Vec2((-10.0f*time*60), 0), body->GetLocalCenter());
    }
}

- (void)moveRight:(float)time {
    b2Vec2 velocity = body->GetLinearVelocityFromLocalPoint(body->GetLocalCenter());
    
    if (velocity.x<maxRight) {
        body->ApplyForce(b2Vec2((10.0f*time*60), 0), body->GetLocalCenter());
    }
}
@end
