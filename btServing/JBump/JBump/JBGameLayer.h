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

//#define __jbDEBUG_GAMEVIEW

@class JBHero;
@class JBGameViewController;
@class JBTavern;
@class JBMap;

@interface JBGameLayer : CCLayer {
    b2World* world;
#ifdef __jbDEBUG_GAMEVIEW
    GLESDebugDraw *m_debugDraw;
#endif
    float timePlayerOnGround;
    int sendCounter;
    bool multiplayer;
}

@property(nonatomic, assign)JBGameViewController *gameViewController;
@property(nonatomic, retain)NSMutableDictionary* spawnPoints;
@property(nonatomic, assign)JBTavern *tavern;
@property(assign)CGSize mapSize;
@property (assign) bool isServer;

+(CCScene *) scene;

- (void)loadMap:(JBMap*)map;
- (void)insertCurves:(NSArray *)objects;
- (void)insertEntities:(NSArray *)objects;
- (void)insertHero:(JBHero *)hero atPosition:(CGPoint)position;

- (void)resetJumpForce;
- (void)resetOwnPositionAfterDeath;

- (void)setPositionForPlayer:(JBHero*)aPlayer withPosition:(CGPoint)position velocityX:(float)x andVelocityY:(float)y;
- (void)setupSprites:(NSArray*)heroes;
- (void)insertBallAtPosition:(CGPoint)position;
- (CGPoint)getSpawnPositionForID:(NSString *)spawnID;
- (void)resetBall;
- (void)setPhysicsForBallWithPosition:(CGPoint)position velocityX:(float)x andVelocityY:(float)y;
@end
