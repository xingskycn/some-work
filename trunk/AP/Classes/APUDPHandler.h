//
//  APUDPHandler.h
//  AP
//
//  Created by Ziehn Nils on 8/6/11.
//  Copyright 2011 ziehn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>

@protocol APUDPHandler;


@interface APUDPHandler : NSObject {
	CFSocketRef cfSocket;
	CFHostRef cfHost;
	id<APUDPHandler>   delegate;
}

@property (nonatomic, assign, readwrite) id<APUDPHandler>  delegate;
@property (readwrite) NSUInteger port;
@property (nonatomic, copy) NSString* hostName;
@property (nonatomic, retain) NSData* hostAddress;

- (void)stopHostResolution;
- (void)stopWithStreamError:(CFStreamError)streamError;
- (void)stopWithError:(NSError *)streamError;
- (void)startConnectedToHostName:(NSString *)hostName port:(NSUInteger)port;

@end


@protocol APUDPHandler <NSObject>

@optional

- (void)sender:(APUDPHandler *)echo didReceiveData:(NSData *)data fromAddress:(NSData *)addr;


- (void)sender:(APUDPHandler *)echo didReceiveError:(NSError *)error;


- (void)sender:(APUDPHandler *)echo didSendData:(NSData *)data toAddress:(NSData *)addr;


- (void)sender:(APUDPHandler *)echo didFailToSendData:(NSData *)data toAddress:(NSData *)addr error:(NSError *)error;


- (void)sender:(APUDPHandler *)echo didStartWithAddress:(NSData *)address;


- (void)sender:(APUDPHandler *)echo didStopWithError:(NSError *)error;

@end