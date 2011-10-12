//
//  JBMultiplayerAdapter.h
//  JBump
//
//  Created by Sebastian Pretscher on 11.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class JBTavern;
@class JBHero;

@protocol JBProgressDelegate

- (void)transferWithID:(NSString*)transferID updatedProgress:(float)progress;

@end

@protocol JBMultiplayerAdapterPregameDelegate <NSObject>

- (void)newPlayerAnnounced:(JBHero *)hero;
- (void)playerDisconnected:(JBHero *)hero;
- (void)player:(NSString *)playerID didReadyChange:(BOOL)ready;
- (void)playerDidStartGame:(JBHero *)hero;
- (void)mapChangeToID:(NSString *)mapID;
- (void)newMapReceiving;
- (void)mapRequestReceivedForID:(NSString *)mapID;
- (void)mapTransferCompleted;

@end

@protocol JBMultiplayerAdapterGameDelegate <NSObject>

- (void)newPlayerAnnounced:(JBHero *)hero;
- (JBHero *)requestPlayerAnnouncement:(NSString *)playerID;
- (void)receivedPlayerInfo:(JBHero *)hero;
- (void)player:(JBHero *)hero didChangeContext:(NSDictionary *)context;

@end



@interface JBMultiplayerAdapter : NSObject
@property (nonatomic, retain)JBTavern *tavern;

- (void)sendPlayer;
- (void)announcePlayerWithNewID:(BOOL)newIDRequest;
- (void)sendPlayerReadyChange:(BOOL)ready;
- (void)disconnectPlayer;
- (void)requestForPlayerAnnouncement:(NSString *)playerID;
- (void)playerKilledByChar:(JBHero *)player;
- (void)shoutPlayerGameContextChange;
- (void)shoutMapChangeToMap:(NSString *)mapID;
- (void)playerKilledByChar:(JBHero *)player;
- (void)sendData:(NSData *)data info:(NSDictionary *)info selector:(SEL)sel delegate:(id)delegate;
- (void)continueDataTransfer:(NSString *)transferID;
- (void)aboardDataTransferWithID:(NSString *)transferID;
- (void)askForNextDataTransferWithID:(NSString *)transferID;
- (void)askForMapWithID:(NSString *)mapID;
- (void)sendMapForID:(NSString *)mapID;

@end
