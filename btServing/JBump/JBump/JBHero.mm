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

@synthesize name;
@synthesize skinID;
@synthesize playerID;
@synthesize gameContext;
@synthesize sprite;
@synthesize friction, restitution;
@synthesize body;
@synthesize skinLocation;

@synthesize onGround;
@synthesize jumpTouched;
@synthesize jumpForce;

@synthesize desiredRotation;
@synthesize packageNr;

@synthesize maxLeft, maxRight;
@synthesize isDead;
@synthesize isDeadSended;
@synthesize killingPlayerID;
@synthesize force;
@synthesize userInput;

- (id)init {
    self = [super init];
    
    if (self) {
        maxLeft=-5.0f;
        maxRight=5.0f;
        isLeft=YES;
        isRight=NO;
        jumpTouched=NO;
        self.gameContext = [NSMutableDictionary dictionary];
        [self.gameContext setObject:[[NSUserDefaults standardUserDefaults] objectForKey:jbUSERDEFAULTS_SKIN] forKey:jbGAMECONTEXT_SKIN_ID];
        self.packageNr=-1;
    }
    
    return self;
}

- (id)initWithPlayerId:(char)aPlayerID playerName:(NSString *)playerName gameContext:(NSDictionary *)context {
    self = [self init];
    
    if (self) {
        self.playerID = aPlayerID;
        self.name = playerName;
        self.gameContext = [context mutableCopy];
        self.skinID = [gameContext objectForKey:jbGAMECONTEXT_SKIN_ID];
        self.skinLocation = [[JBSkinManager getSkinWithID:skinID] imageLocation];
        isDead=NO;
        isDeadSended=NO;
    }
    
    return self;
}

- (void)jump:(float)time timeOnGround:(float)playerTimeOnGround {
    if(onGround && !jumpTouched) {
        jumpForce=1.0f;
        if (body->GetLinearVelocity().y<6.5f) {
            body->ApplyForce(b2Vec2(0, (42*time*60*jumpForce)), body->GetWorldCenter());
        }
           }else {
        jumpForce=jumpForce*exp(log(0.990)*time*1000);
        if (body->GetLinearVelocity().y<6.5f) {
            body->ApplyForce(b2Vec2(0, (42*time*60*jumpForce)), body->GetWorldCenter());
        }
    }
}

- (void)moveLeft:(float)time {
    b2Vec2 velocity = body->GetLinearVelocityFromLocalPoint(body->GetLocalCenter());
    
    if (velocity.x>maxLeft) {
        body->ApplyForce(b2Vec2((-10.0f*time*60), 0), body->GetWorldCenter());
    }
    if (isRight) {
        sprite.flipX=YES;
    } else {
        sprite.flipX=NO;
    }
}

- (void)moveRight:(float)time {
    b2Vec2 velocity = body->GetLinearVelocityFromLocalPoint(body->GetLocalCenter());
    
    if (velocity.x<maxRight) {
        body->ApplyForce(b2Vec2((10.0f*time*60), 0), body->GetWorldCenter());
    }
    
    if (isLeft) {
        sprite.flipX=YES;
    } else {
        sprite.flipX=NO;
    }

}

@end
