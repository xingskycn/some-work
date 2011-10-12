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

@class JBHero;

@interface JBTavern : NSObject <JBMultiplayerAdapterGameDelegate>

@property (retain, nonatomic)NSMutableDictionary *heroesInTavern;
@property (retain, nonatomic)JBHero *localPlayer;
@property (assign, nonatomic)JBMultiplayerAdapter *multiplayerAdapter;
@property (assign, nonatomic)JBGameLayer *gameLayer;

- (void)addNewPlayer:(JBHero*)aPlayer;
- (JBHero*)getPlayerWithName:(NSString*)aPlayerName;
- (JBHero*)getPlayerWithReference:(char)reference;
- (NSArray*)getAllPlayers;
- (void)sendPlayerUpdate:(JBHero*)player;

@end
