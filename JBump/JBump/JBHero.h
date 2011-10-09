//
//  JBHero.h
//  JBump
//
//  Created by Sebastian Pretscher on 10.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCSprite;
@class CCNode;

@interface JBHero : NSObject

@property(nonatomic,retain) CCSprite *sprite;

- (id)initWithSprite:(CCNode*)parent;

@end
