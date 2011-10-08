//
//  APAdapter.m
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import "APAdapter.h"

#import "APChar.h"

@implementation APAdapter

@synthesize delegate;
@synthesize charUpdates;

static APAdapter* single;

+ (APAdapter *)single
{
	return single;
}

+ (void)setSingle:(APAdapter *)newAdapter
{
	single = newAdapter;
}

- (void)sendPlayer:(APChar *)chr
{
	NSLog(@"no adapter selected!");
}

- (void)setupConnectionForSender:(id)sender callback:(SEL)selector;
{
	NSLog(@"no adapter selected!");
}

- (id)init
{
	if (self = [super init]) {
		self.charUpdates = [NSMutableDictionary dictionary];
	}
	
	return self;
}

- (void)announcePlayerWithNewID:(BOOL)newIDRequest;
{
	NSLog(@"no adapter selected!");
}

- (void)disconnectPlayer;
{
	NSLog(@"no adapter selected!");
}

- (void)requestForPlayerAnnouncement:(NSString *)chrID;
{
	NSLog(@"no adapter selected!");
}

- (void)playerKilledByChar:(APChar *)chr
{
	NSLog(@"no adapter selected!");
}

- (void)shoutPlayerGameContextChange:(APChar *)chr
{
	NSLog(@"no adapter selected!");
}

- (void)sendNewMapID:(NSString *)mapID
{
	NSLog(@"no adapter selected!");
}

- (void)sendPlayer:(NSString *)playerName readyChange:(NSString *)ready
{
	NSLog(@"no adapter selected!");
}

- (void)sendGameStartedByPlayer:(NSString *)playerName
{
	NSLog(@"no adapter selected!");
}


@end
