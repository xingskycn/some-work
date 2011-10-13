//
//  JBTavern.h
//  JBump
//
//  Created by Sebastian Pretscher on 11.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBMultiplayerAdapter.h"
#import "JBGameLayer.h"
#import "JBEntity.h"

@class JBHero;

@interface JBTavern : NSObject <JBMultiplayerAdapterGameDelegate>

@property (retain, nonatomic)NSMutableDictionary *heroesInTavern;
@property (retain, nonatomic)JBHero *localPlayer;
@property (assign, nonatomic)JBMultiplayerAdapter *multiplayerAdapter;
@property (assign, nonatomic)JBGameLayer *gameLayer;
@property (retain, nonatomic)JBEntity* ball;

- (void)addNewPlayer:(JBHero*)aPlayer;
- (JBHero*)getPlayerWithName:(NSString*)aPlayerName;
- (JBHero*)getPlayerWithReference:(char)reference;
- (NSArray*)getAllPlayers;
- (void)sendPlayerUpdate;
- (void)exchangeLocalPlayer;

- (void)player:(char)aPlayerID changedPosition:(CGPoint)position velocityX:(float)x velocityY:(float)y forceX:(float)forceX forceY:(float)forceY withPackageNR:(int)packageNR;
- (void)Player:(char)aPlayerID isDead:(bool)isDead;
- (void)updateBallWithPositionx:(CGPoint)position velocityX:(float)x andVelocityY:(float)y;
@end
