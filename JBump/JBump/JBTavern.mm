//
//  JBTavern.m
//  JBump
//
//  Created by Sebastian Pretscher on 11.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBTavern.h"
#import "JBHero.h"

@implementation JBTavern

@synthesize heroesInTavern;
@synthesize localPlayer;

- (id)init {
    self = [super init];
    
    if (self) {
        self.heroesInTavern = [NSMutableDictionary dictionary];
        self.localPlayer = [[JBHero alloc] init];
        self.localPlayer.name = [[NSUserDefaults standardUserDefaults] objectForKey:jbUSERDEFAULTS_PLAYER_NAME];
        self.localPlayer.skinID = [[NSUserDefaults standardUserDefaults] objectForKey:jbUSERDEFAULTS_SKIN];
        [self.heroesInTavern setObject:self.localPlayer forKey:self.localPlayer.name];
    }
    
    return self;
}

- (void)addNewPlayer:(JBHero *)aPlayer {
    [self.heroesInTavern setObject:aPlayer forKey:[NSString stringWithFormat:@"%d",aPlayer.playerID]];
}

- (JBHero*)getPlayerWithName:(NSString *)aPlayerName {
    for (JBHero *hero in [self.heroesInTavern allValues]) {
        if (hero.name == aPlayerName) {
            return hero;
        }
    }
    return nil;
}

- (JBHero*)getPlayerWithReference:(char)reference {
    return [self.heroesInTavern objectForKey:[NSString stringWithFormat:@"%d",reference]];
}

- (NSArray *)getAllPlayers {
    return [self.heroesInTavern allValues];
}


@end
