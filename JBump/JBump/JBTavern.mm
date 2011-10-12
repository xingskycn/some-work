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
@synthesize multiplayerAdapter;
@synthesize gameLayer;

- (id)init {
    self = [super init];
    
    if (self) {
        self.heroesInTavern = [NSMutableDictionary dictionary];
        self.localPlayer = [[[JBHero alloc] init] autorelease];
        self.localPlayer.name = [[NSUserDefaults standardUserDefaults] objectForKey:jbUSERDEFAULTS_PLAYER_NAME];
        self.localPlayer.skinID = [[NSUserDefaults standardUserDefaults] objectForKey:jbUSERDEFAULTS_SKIN];
        [self.localPlayer.gameContext setObject:self.localPlayer.skinID forKey:jbGAMECONTEXT_SKIN_ID];
        
        [self.heroesInTavern setObject:self.localPlayer forKey:self.localPlayer.name];
    }
    
    return self;
}

- (void)addNewPlayer:(JBHero *)aPlayer {
    [self.heroesInTavern setObject:aPlayer forKey:[NSString stringWithFormat:@"%d",aPlayer.playerID]];
}

- (JBHero*)getPlayerWithName:(NSString *)aPlayerName {
    for (JBHero *hero in [self.heroesInTavern allValues]) {
        if ([hero.name isEqualToString:aPlayerName]) {
            return hero;
        }
    }
    return nil;
}

- (void)sendPlayerUpdate {
    [self.multiplayerAdapter sendPlayer];
}

- (void)exchangeLocalPlayer {
    [self.heroesInTavern removeObjectForKey:self.localPlayer.name];
    [self.heroesInTavern setObject:self.localPlayer forKey:[NSString stringWithFormat:@"%d",self.localPlayer.playerID]];
    
}

- (JBHero*)getPlayerWithReference:(char)reference {
    return [self.heroesInTavern objectForKey:[NSString stringWithFormat:@"%d",reference]];
}

- (NSArray *)getAllPlayers {
    return [self.heroesInTavern allValues];
}

- (void)newPlayerAnnounced:(JBHero *)hero {
    
}

- (JBHero *)requestPlayerAnnouncement:(NSString *)playerID {
    return [self getPlayerWithReference:[playerID intValue]];
}

- (void)receivedPlayerInfo:(JBHero *)hero {
    
}

- (void)player:(JBHero *)hero didChangeContext:(NSDictionary *)context {
    
}

- (void)player:(char)aPlayerID changedPosition:(CGPoint)position velocityX:(float)x velocityY:(float)y withPackageNR:(int)packageNR {
    JBHero *aPlayer = [self getPlayerWithReference:aPlayerID];
    if (aPlayer==nil) {
        NSLog(@"No Player with ID: %i in Tavern", aPlayerID);
        return;
    }
    if (aPlayer.packageNr<packageNR) {
        //aPlayer.packageNr=packageNR;
        
        [self.gameLayer setPositionForPlayer:aPlayer withPosition:position velocityX:x andVelocityY:y];
    }
    else {
        NSLog(@"Heroes in Tavern: %@", self.heroesInTavern);
        NSLog(@"Recieved PackageNR: %i, localPackageNR: %i",packageNR ,aPlayer.packageNr);
    }
}


@end
