//
//  JBTavern.h
//  JBump
//
//  Created by Sebastian Pretscher on 11.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBHero;

@interface JBTavern : NSObject

@property (retain, nonatomic)NSMutableDictionary *heroesInTavern;
@property (retain, nonatomic)JBHero *localPlayer;

- (void)addNewPlayer:(JBHero*)aPlayer;
- (JBHero*)getPlayerWithName:(NSString*)aPlayerName;
- (JBHero*)getPlayerWithReference:(char)reference;
- (NSArray*)getAllPlayers;

@end
