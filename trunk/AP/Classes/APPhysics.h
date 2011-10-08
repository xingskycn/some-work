//
//  APPhysics.h
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <Foundation/Foundation.h>


@class APMap;
@class APChar;
@class APAdapter;
@class APGameViewController;

@interface APPhysics : NSObject {
	NSMutableDictionary* characters;
	APChar* player;
	NSMutableArray* maps;
	NSTimer* physTimer;
	
	APAdapter* adapter;
	
	BOOL stopped;
	
	int inputSkipCounter;
	
	CGFloat maxSpeed;
	
	APGameViewController* gameView;
	
	NSString* gameMode;
	
	CGPoint mapPosition;
	
	CGPoint mapVelocity;
}

+(APPhysics *)single;


@property (nonatomic, copy) NSString* gameMode;
@property (nonatomic, retain) NSMutableDictionary* characters;
@property (nonatomic, retain) NSMutableArray* maps;
@property (nonatomic, retain) NSTimer* physTimer;
@property (nonatomic, retain) APChar* player;
@property (nonatomic, assign) APAdapter* adapter;
@property (nonatomic, assign) APGameViewController* gameView;
@property (readwrite) CGPoint mapPosition;
@property (readwrite) CGPoint mapVelocity;

@property (readwrite) BOOL stopped;

- (void)step;

- (BOOL)calculateUserInputTiming;
- (void)calculatePhysicsForChar:(APChar *)chr withUserInput:(BOOL)activeUserInput;
- (void)spawnCharacter:(APChar *)chr;

- (void)addChar:(APChar *)chr;
- (void)charDisconnected:(APChar *)chr;
- (void)playerKilledByChar:(APChar *)chr;
- (void)playerKilledChar:(APChar *)chr;
- (void)gameContextUpdateForChr:(APChar *)chr;

@end
