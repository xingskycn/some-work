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

@interface JBHero : NSObject

@property(nonatomic,retain) CCSprite *sprite;

@property(assign)float friction;
@property(assign)float restitution;
@property(assign)bool onGround;
@property(assign)float jumpForce;
@property(assign)b2Body *body;

- (id)initWithNode:(CCNode*)parent;
- (void)jump:(float)time;
- (void)resetJump;

@end
