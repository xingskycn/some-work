//
//  JBMultiplayerAdapter.h
//  JBump
//
//  Created by Sebastian Pretscher on 11.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "JBProgressView.h"

@class JBTavern;
@class JBHero;

@protocol JBMultiplayerAdapterPregameDelegate <NSObject>

- (void)newPlayerAnnounced:(JBHero *)hero;
- (void)playerDisconnected:(JBHero *)hero;
- (void)player:(NSString *)playerID didReadyChange:(BOOL)ready;
- (void)playerDidStartGame:(JBHero *)hero;
- (void)mapChangeToID:(NSString *)mapID;
- (id<JBProgressDelegate>)newMapReceiving;
- (void)mapRequestReceivedForID:(NSString *)mapID;
- (void)mapTransferCompleted;

@end

@protocol JBMultiplayerAdapterGameDelegate <NSObject>

- (void)newPlayerAnnounced:(JBHero *)hero;
- (JBHero *)requestPlayerAnnouncement:(NSString *)playerID;
- (void)receivedPlayerInfo:(JBHero *)hero;
- (void)player:(char)heroID didChangeContext:(NSDictionary *)context;
- (void)receivedAKill:(char)killingPlayerID;

@end



@interface JBMultiplayerAdapter : NSObject
@property (nonatomic, retain)JBTavern *tavern;

- (void)sendPlayer;
- (void)announcePlayerWithNewID:(BOOL)newIDRequest;
- (void)sendPlayerReadyChange:(BOOL)ready;
- (void)disconnectPlayer;
- (void)requestForPlayerAnnouncement:(NSString *)playerID;
- (void)playerKilledByChar:(JBHero *)player;
- (void)shoutPlayerGameContextChange:(JBHero*)aHero;
- (void)shoutMapChangeToMap:(NSString *)mapID;
- (void)playerKilledByChar:(JBHero *)player;
- (void)continueDataTransfer:(NSString *)transferID;
- (void)aboardDataTransferWithID:(NSString *)transferID;
- (void)askForNextDataTransferWithID:(NSString *)transferID;
- (void)askForMapWithID:(NSString *)mapID;
- (void)sendData:(NSData *)data 
            info:(NSDictionary *)info 
        selector:(SEL)sel 
  finishDelegate:(id)fDelegate
progressDelegate:(id<JBProgressDelegate>)pDelegate;
- (void)sendMapForID:(NSString *)mapID progrossDelegate:(id<JBProgressDelegate>)delegate;
- (void)sendBall;
- (void)sendUserInput:(NSString *)inputs;

@end
