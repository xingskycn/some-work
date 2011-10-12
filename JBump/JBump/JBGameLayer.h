//
//  JBGameLayer.h
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#define __jbDEBUG_GAMEVIEW

@class JBHero;
@class JBGameViewController;
@class JBTavern;

@interface JBGameLayer : CCLayer {
    b2World* world;
#ifdef __jbDEBUG_GAMEVIEW
    GLESDebugDraw *m_debugDraw;
#endif
    float timePlayerOnGround;
    int sendCounter;
}

@property(nonatomic, assign)JBGameViewController *gameViewController;
@property(nonatomic, retain)NSMutableDictionary* spawnPoints;
@property(nonatomic, assign)JBTavern *tavern;

+(CCScene *) scene;

- (void)insertCurves:(NSArray *)objects;
- (void)insertEntities:(NSArray *)objects;
- (void)insertHero;

- (void)resetJumpForce;

- (void)setPositionForPlayer:(JBHero*)aPlayer;
@end
