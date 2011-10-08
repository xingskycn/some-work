//
//  APChar.h
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APGameViewController;

@interface APChar : UIImageView {
	CGPoint speed;
	CGPoint position;
	CGSize size;
	
	CGFloat maxXSpeed;
	CGFloat jumpPower;
	
	NSMutableDictionary* userInput;
	APGameViewController* gameView;
	CGFloat direction; //running direction
	BOOL dead;
	
	NSString* chrID;
	BOOL skipPhysicsStep;
	
	CGPoint userInputSpeed;
	
	CGPoint adaPosition;
	
	int packageNumber;
	
	UILabel* nameLabel;
	
	NSString* gameContext; //Used to store scores, deaths...
	
	int timeToLive; // is reduced during physics steps and increased during webupdates
}

@property (readwrite) CGPoint speed;
@property (readwrite) CGPoint position;
@property (readwrite) CGFloat gravitation;
@property (readwrite) CGSize size;
@property (readwrite) BOOL onFloor;
@property (readwrite) BOOL inWater;
@property (readwrite) BOOL onLadder;
@property (nonatomic, retain) NSMutableDictionary* userInput;
@property (nonatomic, assign) APGameViewController* gameView;
@property (readwrite) CGFloat direction;
@property (readwrite) BOOL dead;
@property (readwrite) BOOL skipPhysicsStep;
@property (nonatomic, copy) NSString *chrID;
@property (readwrite) CGPoint userInputSpeed;
@property (readwrite) CGPoint adaPosition;
@property (readwrite) int packageNumber;
@property (nonatomic, retain) UILabel* nameLabel;
@property (nonatomic, retain) NSString* gameContext;
@property (readwrite) int timeToLive;
@property (readwrite) CGFloat maxXSpeed;

- (id)initWithDict:(NSDictionary *)initDict;
- (void)updateAppearance;
- (void)interactWith:(APChar *)sndchr;

- (void)willBeSpawned; //?

- (void)updateUserInputSpeed;

- (NSComparisonResult)compareByKills:(APChar *)chr;
- (NSComparisonResult)compareByDeaths:(APChar *)chr;


- (NSString *)getGameContentsForKey:(NSString *)key;
- (void)setGameContents:(NSString *)content ForKey:(NSString *)key;

@end
