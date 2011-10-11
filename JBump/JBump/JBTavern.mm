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
    }
    
    return self;
}

- (void)addNewPlayer:(JBHero *)aPlayer {
    [self.heroesInTavern setObject:aPlayer forKey:aPlayer.name];
}

- (JBHero*)getPlayerWithName:(NSString *)aPlayerName {
    return [self.heroesInTavern objectForKey:aPlayerName];
}

- (JBHero*)getPlayerWithReference:(char)reference {
    for (JBHero *hero in [self.heroesInTavern allValues]) {
        if (hero.reference == reference) {
            return hero;
        }
    }
    return nil;

}

- (NSArray *)getAllPlayers {
    return [self.heroesInTavern allValues];
}

@end
