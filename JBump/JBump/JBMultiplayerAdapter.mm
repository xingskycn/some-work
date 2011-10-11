//
//  JBMultiplayerAdapter.m
//  JBump
//
//  Created by Sebastian Pretscher on 11.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBMultiplayerAdapter.h"
#import "JBHero.h"

@implementation JBMultiplayerAdapter
@synthesize tavern;

- (void)sendPlayer:(JBHero *)player{
    NSLog(@"%@ Not Yet Implemented?",_cmd);
}

- (void)announcePlayerWithNewID:(BOOL)newIDRequest{
    NSLog(@"%@ Not Yet Implemented?",_cmd);
}

- (void)disconnectPlayer{
    NSLog(@"%@ Not Yet Implemented?",_cmd);
}

- (void)requestForPlayerAnnouncement:(NSString *)playerID{
    NSLog(@"%@ Not Yet Implemented?",_cmd);
}

- (void)playerKilledByChar:(JBHero *)player{
    NSLog(@"%@ Not Yet Implemented?",_cmd);
}

- (void)shoutPlayer:(JBHero*)player GameContextChange:(NSDictionary *)context{
    NSLog(@"%@ Not Yet Implemented?",_cmd);
}

- (void)sendNewMapID:(NSString *)mapID{
    NSLog(@"%@ Not Yet Implemented?",_cmd);
}

- (void)sendPlayer:(NSString *)playerName readyChange:(NSString *)ready{
    NSLog(@"%@ Not Yet Implemented?",_cmd);
}

- (void)sendGameStartedByPlayer:(NSString *)playerName{
    NSLog(@"%@ Not Yet Implemented?",_cmd);
}

@end
