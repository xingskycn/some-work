//
//  APWebAdapter.h
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APAdapter.h"
#import "UDPEcho.h"

@interface APWebAdapter : APAdapter <UDPEchoDelegate>{
	NSThread* downloaderThread;
	NSString* ID;
	NSString* uploadString;
	NSString* oldUploadString;
	id caller;
	SEL callback;
	
}

@property (nonatomic, retain) NSThread* downloaderThread;
@property (nonatomic, retain) NSString* ID;
@property (nonatomic, copy) NSString* uploadString;
@property (nonatomic, copy) NSString* oldUploadString;
@property (nonatomic, retain)UDPEcho* UDPClient;

+ (APAdapter *)single;

- (void)echo:(UDPEcho *)echo didReceiveData:(NSData *)data fromAddress:(NSData *)addr;
- (void)echo:(UDPEcho *)echo didStartWithAddress:(NSData *)address;

- (void)handleWebInput:(NSData *)response;

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
