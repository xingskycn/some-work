//
//  JBHero.h
//  JBump
//
//  Created by Sebastian Pretscher on 10.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"

@class CCSprite;
@class CCNode;

@interface JBHero : NSObject {
    @private
    bool isLeft, isRight;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* skinID;
@property (nonatomic, retain) NSMutableDictionary* gameContext;
@property (assign) int packageNr;
@property (assign) char playerID;
@property (nonatomic, retain)NSString *skinLocation;

@property(nonatomic,retain) CCSprite *sprite;

@property(assign)float friction;
@property(assign)float restitution;

@property(assign)b2Body *body;

@property(assign)bool onGround;
@property(assign)bool jumpTouched;
@property(assign)float jumpForce;
@property(assign)float maxLeft;
@property(assign)float maxRight;

@property(assign)float desiredRotation;

- (id)initWithPlayerId:(char)aPlayerID playerName:(NSString*)name gameContext:(NSDictionary*)context;
- (void)jump:(float)time timeOnGround:(float)playerTimeOnGround;
- (void)moveLeft:(float)time;
- (void)moveRight:(float)time;


@end
