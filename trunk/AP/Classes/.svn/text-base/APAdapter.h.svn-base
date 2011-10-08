//
//  APAdapter.h
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "APPhysics.h"
#import "APGameViewController.h"
#import "APChar.h"


@class APChar;

@interface APAdapter : NSObject {
	id delegate;
	NSMutableDictionary* charUpdates;
}


+ (APAdapter *)single;
+ (void)setSingle:(APAdapter *)newAdapter;

//!		delegate:
//!		Class to handle incomming Char Updates
//!		
//!		Has to implement:
//!		- (void)addChar:(APChar *)chr;
//!		- (void)charDisconnected:(APChar *)chr; 
@property (nonatomic, retain) id delegate;

//!		charUpdates:
//!		This dictionary contains APChars for every charID that was updated since last step
@property (nonatomic, retain) NSMutableDictionary* charUpdates;

//!		Method to send the player/chr position to others
- (void)sendPlayer:(APChar *)chr;

//!		Method to setup a connection ( bluetooth / internet server ) 
- (void)setupConnectionForSender:(id)sender callback:(SEL)selector;

//!		Tells the network about the new player
//!		If newIDRequest ist TRUE, a new chrID will be generated
- (void)announcePlayerWithNewID:(BOOL)newIDRequest;

//!		Tells the network that the player will disconnect
- (void)disconnectPlayer;

//!		Asks the network for player information
- (void)requestForPlayerAnnouncement:(NSString *)chrID;

//!		Tells the network that the player died, killed by !chr
- (void)playerKilledByChar:(APChar *)chr;

//!		Tells the network that the player context did change
- (void)shoutPlayerGameContextChange:(APChar *)chr;

//!		User selected a new map to play
- (void)sendNewMapID:(NSString *)mapID;

//!		User changed his ready state in pregameview
- (void)sendPlayer:(NSString *)playerName readyChange:(NSString *)ready;

//!		User started the game
- (void)sendGameStartedByPlayer:(NSString *)playerName;


@end
