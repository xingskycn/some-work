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

//		Method to send the player position to others
- (void)sendPlayer:(JBHero *)player;

//		Tells the network about the new player
//		If newIDRequest ist TRUE, a new chrID will be generated
- (void)announcePlayerWithNewID:(BOOL)newIDRequest;

//		Tells the network that the player will disconnect
- (void)disconnectPlayer;

//		Asks the network for player information
- (void)requestForPlayerAnnouncement:(NSString *)playerID;

//		Tells the network that the player died, killed by player
- (void)playerKilledByChar:(JBHero *)player;

//		Tells the network that the player context did change
- (void)shoutPlayer:(JBHero*)player GameContextChange:(NSDictionary *)context;

//		User selected a new map to play
- (void)sendNewMapID:(NSString *)mapID;

//		User changed his ready state in pregameview
- (void)sendPlayer:(NSString *)playerID readyChange:(NSString *)ready;

//		User started the game
- (void)sendGameStartedByPlayer:(NSString *)playerID;

- (void)sendPlayerReadyChange:(BOOL)ready;

- (void)sendImage:(UIImage *)image info:(NSDictionary *)info;

@end
