//
//  APBluetoothAdapter.h
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APAdapter.h"
#import <GameKit/GameKit.h>

@interface APBluetoothAdapter : APAdapter <GKPeerPickerControllerDelegate,GKSessionDelegate> {
	GKSession* gameSession;
	
	NSString* uploadString;
	NSString* activePeer;
	
	int datacounter;
	
	id creator;
	SEL selector;
}

@property (nonatomic, retain) GKSession* gameSession;
@property (nonatomic, retain) NSString* uploadString; 
@property (nonatomic, retain) NSString* activePeer;

- (BOOL)dataForGameSetup:(NSData *)data;

- (BOOL)handleSkinInfo:(NSString *)input;
- (BOOL)handleSkinRequest:(NSString *)input;
- (BOOL)handleSkinImageData:(NSData *)input;
- (BOOL)handleNewMapSelesction:(NSString *)inputString;
- (BOOL)handlePlayerReadyChange:(NSString *)inputString;
- (BOOL)handleGameStartedByPlayer:(NSString *)inputString;
- (void)sendSkinInfo:(NSString *)info;
- (void)sendSkinRequest:(NSString *)skinID;


- (BOOL)handleChrAnnouncement:(NSString *)inputString;
- (BOOL)handleDisconnectedPlayer:(NSString *)inputString;
- (BOOL)handleRequestForPlayerAnnouncement:(NSString *)inputString;
- (BOOL)handleChrGameContextChange:(NSString *)inputString;
- (BOOL)handleChrKilledByPlayer:(NSString *)inputString;
- (void)handlePlayerPositionUpdates:(NSData *)data;

@end
