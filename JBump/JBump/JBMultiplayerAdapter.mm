//
//  JBMultiplayerAdapter.m
//  JBump
//
//  Created by Sebastian Pretscher on 11.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBMultiplayerAdapter.h"
#import "JBHero.h"
#import "JBTavern.h"

@implementation JBMultiplayerAdapter
@synthesize tavern;

- (id)init {
    self = [super init];
    
    if (self) {
        self.tavern = [[[JBTavern alloc] init] autorelease];
        tavern.multiplayerAdapter = self;
    }
    
    return self;
}

- (void)sendPlayer{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)announcePlayerWithNewID:(BOOL)newIDRequest{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)disconnectPlayer{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)requestForPlayerAnnouncement:(NSString *)playerID{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)playerKilledByChar:(JBHero *)player{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)shoutPlayer:(JBHero*)player GameContextChange:(NSDictionary *)context{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)sendNewMapID:(NSString *)mapID{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)sendPlayer:(NSString *)playerName readyChange:(NSString *)ready{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)sendGameStartedByPlayer:(NSString *)playerName{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)sendPlayerReadyChange:(BOOL)ready
{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)sendImage:(UIImage *)image info:(NSDictionary *)info
{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)shoutPlayerWantsMapChange:(NSString *)mapID
{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)sendData:(NSData *)data info:(NSDictionary *)info{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)askForNextDataTransferWithID:(NSString *)transferID
{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)askForMapWithID:(NSString *)mapID
{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)sendMapForID:(NSString *)mapID
{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)shoutPlayerGameContextChange
{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)continueDataTransfer:(NSString *)transferID
{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)aboardDataTransferWithID:(NSString *)transferID
{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}

- (void)shoutMapChangeToMap:(NSString *)mapID
{
    NSLog(@"%@ Not Yet Implemented?",NSStringFromSelector(_cmd));
}


- (void)dealloc {
    self.tavern = nil;
    [super dealloc];
}

@end
