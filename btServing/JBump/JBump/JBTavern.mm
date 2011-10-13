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
@synthesize entitiesInTavern;

@synthesize localPlayer;
@synthesize multiplayerAdapter;
@synthesize gameLayer;
@synthesize ball;

- (id)init {
    self = [super init];
    
    if (self) {
        lastHeroPackageNumber = 0;
        lastHeroPackageNumber = 0;
        self.heroesInTavern = [NSMutableDictionary dictionary];
        self.entitiesInTavern = [NSMutableDictionary dictionary];
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

- (void)player:(char)heroID didChangeContext:(NSDictionary *)context {
    JBHero *changeH = [self getPlayerWithReference:heroID];
    changeH.gameContext=[context mutableCopy];
}

- (void)player:(char)aPlayerID changedPosition:(CGPoint)position velocityX:(float)x velocityY:(float)y forceX:(float)forceX forceY:(float)forceY withPackageNR:(int)packageNR {
    JBHero *aPlayer = [self getPlayerWithReference:aPlayerID];
    aPlayer.force = CGPointMake(forceX, forceY);
    if (aPlayer==nil) {
        NSLog(@"No Player with ID: %i in Tavern", aPlayerID);
        return;
    }
    if (aPlayer.packageNr<packageNR) {
        aPlayer.packageNr=packageNR;
        if (self.gameLayer!=nil) {
            [self.gameLayer setPositionForPlayer:aPlayer withPosition:position velocityX:x andVelocityY:y];
        }
    }
    else {
        NSLog(@"Heroes in Tavern: %@", self.heroesInTavern);
        NSLog(@"Recieved PackageNR: %i, localPackageNR: %i",packageNR ,aPlayer.packageNr);
    }
}
- (void)Player:(char)aPlayerID isDead:(bool)isDead {
    [self.multiplayerAdapter playerKilledByChar:[self getPlayerWithReference:self.localPlayer.killingPlayerID]];
    NSLog(@"Want send that Player with ID: %i is dead", aPlayerID);
    NSNumber *deathCount= [self.localPlayer.gameContext objectForKey:jbGAMECONTEXT_DEATH_COUNT];
    if (deathCount) {
        int kills= [deathCount intValue];
        deathCount = [NSNumber numberWithInt:(kills++)];
    } else {
        deathCount = [NSNumber numberWithInt:1];
    }
    [self.localPlayer.gameContext setObject:deathCount forKey:jbGAMECONTEXT_DEATH_COUNT];
    [self.multiplayerAdapter shoutPlayerGameContextChange];
}

- (void)receivedAKill:(char)killingPlayerID {
    if (self.localPlayer.playerID==killingPlayerID) {
        NSNumber *killCount= [self.localPlayer.gameContext objectForKey:jbGAMECONTEXT_KILL_COUNT];
        if (killCount) {
            int kills= [killCount intValue];
            killCount = [NSNumber numberWithInt:(kills++)];
        } else {
            killCount = [NSNumber numberWithInt:1];
        }
        [self.localPlayer.gameContext setObject:killCount forKey:jbGAMECONTEXT_KILL_COUNT];
    }
    
    [self.multiplayerAdapter shoutPlayerGameContextChange];
}

- (void)updateBallWithPositionx:(CGPoint)position velocityX:(float)x andVelocityY:(float)y
{
    [self.gameLayer setPhysicsForBallWithPosition:position velocityX:x andVelocityY:y];
}

- (void)setAllHeroSpritesInWorld:(NSArray*)allSprites withPackageNumber:(int)packageNumber {
    if (packageNumber<lastHeroPackageNumber) {
        return;
    }
    lastHeroPackageNumber=packageNumber;

    for (NSDictionary *spriteDict in allSprites) {
        JBHero *hero = [self.heroesInTavern objectForKey:[spriteDict objectForKey:jbID]];
        if (hero) {
            hero.sprite.position=CGPointFromString([spriteDict objectForKey:jbPOSITION]);
            hero.sprite.rotation=[[spriteDict objectForKey:jbROTATION] floatValue];
            hero.sprite.flipX = [[spriteDict objectForKey:jbFLIPX] intValue];
        } else {
            self.localPlayer.sprite.position = CGPointFromString([spriteDict objectForKey:jbPOSITION]);
            self.localPlayer.sprite.rotation = [[spriteDict objectForKey:jbROTATION] floatValue];
            self.localPlayer.sprite.flipX = [[spriteDict objectForKey:jbFLIPX] intValue];

        }
    }
}

- (void)setAllEntitiesInWorld:(NSArray*)allEntities withPackageNumber:(int)packageNumber {
    if (packageNumber<lastEntityPackageNumber) {
        return;
    }
    lastEntityPackageNumber=packageNumber;
    for (NSDictionary *entityDict in allEntities) {
        JBEntity *entity = [self.heroesInTavern objectForKey:[entityDict objectForKey:jbID]];
        if (entity) {
            entity.sprite.position=CGPointFromString([entityDict objectForKey:jbPOSITION]);
            entity.sprite.rotation=[[entityDict objectForKey:jbROTATION] floatValue];
            entity.sprite.flipX = [[entityDict objectForKey:jbFLIPX] intValue];
        }
    }
}

@end
