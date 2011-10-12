//
//  JBBluetoothAdapter.h
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBMultiplayerAdapter.h"
#import <GameKit/GameKit.h>

@class SBJsonWriter;
@class SBJsonParser;
@class JBPreGameViewController;

@interface JBBluetoothAdapter : JBMultiplayerAdapter <GKPeerPickerControllerDelegate,GKSessionDelegate> {
    int datacounter;
	id creator;
	SEL selector;
}

@property (nonatomic, retain) GKSession *gameSession;
@property (nonatomic, retain) NSString* activePeer;
@property (nonatomic, retain) JBPreGameViewController *preGameDelegate;
@property (nonatomic, retain) SBJsonWriter* jsonWriter;
@property (nonatomic, retain) SBJsonParser* jsonParser;
@property (nonatomic, retain) NSMutableDictionary* activeDataTransfers;

- (void)setupConnectionForPreGameViewController:(JBPreGameViewController*)aPreGameDelegate;
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context;
@end
