//
//  JBMultiplayerAdapter.h
//  JBump
//
//  Created by Sebastian Pretscher on 11.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "JBTavern.h"

@class JBHero;



@protocol JBMultiplayerAdapterPregameDelegate <NSObject>

- (void)newPlayerAnnounced:(JBHero *)hero;
- (void)playerDisconnected:(JBHero *)hero;
- (void)player:(NSString *)playerID didReadyChange:(BOOL)ready;
- (void)playerDidStartGame:(JBHero *)hero;

@end

@protocol JBMultiplayerAdapterGameDelegate <NSObject>

- (void)newPlayerAnnounced:(JBHero *)hero;
- (JBHero *)requestPlayerAnnouncement:(NSString *)playerID;
- (void)receivedPlayerInfo:(JBHero *)hero;
- (void)player:(JBHero *)hero didChangeContext:(NSDictionary *)context;

@end



@interface JBMultiplayerAdapter : NSObject
@property (nonatomic, retain)JBTavern* tavern;

- (void)sendPlayer:(JBHero *)player;
- (void)announcePlayerWithNewID:(BOOL)newIDRequest;
- (void)sendPlayerReadyChange:(BOOL)ready;
- (void)disconnectPlayer;
- (void)requestForPlayerAnnouncement:(NSString *)playerID;
- (void)playerKilledByChar:(JBHero *)player;
- (void)shoutPlayerGameContextChange;
- (void)shoutPlayerWantsMapChange;
- (void)playerKilledByChar:(JBHero *)player;
- (void)sendData:(NSData *)data info:(NSDictionary *)info;
- (void)continueDataTransfer:(NSString *)transferID;
- (void)aboardDataTransferWithID:(NSString *)transferID;
- (void)askForNextDataTransferWithID:(NSString *)transferID;

@end
