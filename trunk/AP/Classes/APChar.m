//
//  APChar.m
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import "APChar.h"
#import "APGameViewController.h"
#import "APRay.h"
#import "APPhysics.h"
#import "APSkinDict.h"
#import "APStatsViewController.h"

@implementation APChar

@synthesize speed, position,gravitation,size,onFloor,skipPhysicsStep;
@synthesize userInput,gameView,direction,dead,chrID,userInputSpeed,adaPosition,packageNumber;
@synthesize nameLabel,gameContext,timeToLive,maxXSpeed,inWater,onLadder;


- (id)initWithDict:(NSDictionary *)initDict
{
	UIImage* anImage = [initDict objectForKey:@"image"];
	
	if (!anImage) {
		self.gameContext = [initDict objectForKey:@"game_context"];
		NSString* skinID = [self getGameContentsForKey:@"SKIN_ID{}:"];
		if (skinID) {
			anImage = [[APSkinDict single] imageForSkinID:skinID];
		}
	}
	
	
	if (self = [super initWithImage:anImage]) {
		self.frame = CGRectMake(0, 0, 30, 30);
		position = CGPointMake(120, 80);
		speed = CGPointMake(-1.1, 0.01);
		size = CGSizeMake(30, 30);
		maxXSpeed = 8;
		direction = 1;
		dead = YES;
		userInputSpeed = CGPointMake(0, 0);
		self.chrID = [initDict objectForKey:@"chr_ID"];
		
		self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(-40, -20, 80+size.width, 20)];
		self.nameLabel.textAlignment = UITextAlignmentCenter;
		self.nameLabel.text = [initDict objectForKey:@"player_name"];
		self.nameLabel.backgroundColor = [UIColor clearColor];
		
		
		self.nameLabel.font = [UIFont fontWithName:@"Marker Felt" size:4*((int)(5*[[[NSUserDefaults standardUserDefaults] objectForKey:@"name_label_size"]floatValue])) ];
		[self addSubview:self.nameLabel];
		
		self.userInput = [initDict objectForKey:@"inputs"];
		
		self.gameView = [initDict objectForKey:@"game_view"];
		NSString* gContext;
		if (gContext = [initDict objectForKey:@"game_context"]) {
			self.gameContext = gContext;
		}else {
			[self setGameContents:@"0" ForKey:@"PKILLS{}:"];
			[self setGameContents:@"0" ForKey:@"PDEATHS{}:"];
			[self setGameContents:[[NSUserDefaults standardUserDefaults] objectForKey:@"skin_ID"] ForKey:@"SKIN_ID{}:"];
		}
		self.timeToLive = 200;
		NSLog(@"Char initiated %@",[initDict objectForKey:@"char_name"]);
		
	}else {
		NSLog(@"Cant initilize BJCharacter");
	}
	
	return self;
}

- (void)updateUserInputSpeed
{
	userInputSpeed = CGPointMake(0, 0);
	
	if (!self.userInput) {
		return;
	}
	if (onLadder) {
		if ([self.userInput objectForKey:@"jump"]) {
			userInputSpeed.y = -4;
		}
	}else if (onFloor && ![self.userInput objectForKey:@"jump"]) {
		jumpPower = 1;
	}else if (inWater && ![self.userInput objectForKey:@"jump"]) {
		jumpPower = 1;
	}else if (!onFloor && ![self.userInput objectForKey:@"jump"]) {
		jumpPower = 0;
	} else if( onFloor && [self.userInput objectForKey:@"jump"] )
	{
		userInputSpeed.y = jumpPower*-4;
	}else if (!onFloor && [self.userInput objectForKey:@"jump"]) {
		jumpPower *= 0.78;
		userInputSpeed.y = jumpPower*-4;
	}
	
	if( [self.userInput objectForKey:@"left"] )
	{
		userInputSpeed.x = -1;
		if (onLadder) {
			userInputSpeed.x = -3;
		}
	}
	
	if( [self.userInput objectForKey:@"right"] )
	{
		userInputSpeed.x = 1;
		if (onLadder) {
			userInputSpeed.x = 3;
		}
	}
	
	if (![self.userInput objectForKey:@"right"] && ![self.userInput objectForKey:@"left"]) {
		userInputSpeed.x += speed.x/-3;
	}
}

- (void)updateAppearance
{
	CGFloat newDirection = self.position.x - self.center.x;
	
	
	CGFloat distance = (self.position.x - self.center.x)*(self.position.x - self.center.x);
	if (distance < 1) {
		newDirection = direction;
	}
	
	if (newDirection/direction<0) {
		direction *= -1;
		self.transform = CGAffineTransformMakeScale(-direction, 1);
		nameLabel.transform = CGAffineTransformMakeScale(-direction, 1);
	}
	
	self.center = self.position;	
}

- (void)dealloc {
	NSLog(@"dealloced");
	self.userInput = nil;
    [super dealloc];
}

- (void)willBeSpawned
{
	self.dead = FALSE;
}

- (void)setSpeed:(CGPoint)spd
{
	speed = spd;
}

- (void)setDead:(BOOL)newValue
{
	
	
	speed = CGPointMake(0, 0);
	dead = newValue;
	
	if (dead) {
		int deaths = [[self getGameContentsForKey:@"PDEATHS{}:"] intValue];
		[self setGameContents:[NSString stringWithFormat:@"%d",++deaths] ForKey:@"PDEATHS{}:"];
		[APPhysics single].mapVelocity=CGPointMake([APPhysics single].mapVelocity.x-2, [APPhysics single].mapVelocity.y);
		[[APGameViewController single].statsView updateStats];
	}
}

- (void)setPosition:(CGPoint)pos
{
	position = pos;
}



- (void)interactWith:(APChar *)sndchr
{
	CGRect thisRect = CGRectMake(self.position.x-self.size.width/2, self.position.y-self.size.height/2, self.size.width, self.size.height);
	
	if (CGRectIntersectsRect(thisRect, sndchr.frame)) {
		APRay* connector = [[APRay alloc] initFrom:self.center to:sndchr.center];
		if ([[APPhysics single].gameMode isEqualToString:@"run"]) {
			
			CGRect inter = CGRectIntersection(self.frame, sndchr.frame);
			CGPoint dir = connector.direction;
			CGFloat length = sqrt(inter.size.width*inter.size.width+inter.size.height*inter.size.height);
			self.speed = CGPointMake(dir.x*length*-1, dir.y*length*-1*0.2+self.speed.y*0.8);
			
		}else if ([[APPhysics single].gameMode isEqualToString:@"std"]) {
			
			if ([connector intersectionSideToRect:sndchr.frame]==3) {
				self.dead = TRUE;
				[[APPhysics single] playerKilledByChar:sndchr];
			}else {
				CGRect inter = CGRectIntersection(self.frame, sndchr.frame);
				CGPoint dir = connector.direction;
				CGFloat length = sqrt(inter.size.width*inter.size.width+inter.size.height*inter.size.height);
				self.speed = CGPointMake(dir.x*length*-1, dir.y*length*-1*0.2+self.speed.y*0.8);
			}
		}
		[connector release];
	}
}

- (NSComparisonResult)compareByKills:(APChar *)chr
{
	int firstKills = [[self getGameContentsForKey:@"PKILLS{}:"] intValue];
	int secondKills = [[chr getGameContentsForKey:@"PKILLS{}:"] intValue];
	
	if (firstKills < secondKills) {
		return NSOrderedDescending;
	}
	
	if (firstKills > secondKills) {
		return NSOrderedAscending;
	} else {
		return NSOrderedSame;
	}

}

- (NSComparisonResult)compareByDeaths:(APChar *)chr
{
	int firstKills = [[self getGameContentsForKey:@"PDEATHS{}:"] intValue];
	int secondKills = [[chr getGameContentsForKey:@"PDEATHS{}:"] intValue];
	
	if (firstKills < secondKills) {
		return NSOrderedAscending;
	}
	
	if (firstKills > secondKills) {
		return NSOrderedDescending;
	} else {
		return NSOrderedSame;
	}
}


- (NSString *)getGameContentsForKey:(NSString *)key
{
	NSRange first = [self.gameContext rangeOfString:key];
	if (first.location==NSNotFound) {
		return nil;
	}else {
		NSString* substring = [self.gameContext substringFromIndex:first.location+first.length];
		NSRange end = [substring rangeOfString:[NSString stringWithFormat:@"%@\\",key]];
		if (end.location == NSNotFound) {
			return nil;
		}else {
			return [substring substringToIndex:end.location];
		}
	}

}

- (void)setGameContents:(NSString *)content ForKey:(NSString *)key
{
	NSRange first = [self.gameContext rangeOfString:key];
	if (first.location == NSNotFound) {
		self.gameContext = [NSString stringWithFormat:@"%@%@%@%@\\",self.gameContext,key,content,key];
	}else {
		NSRange end = [self.gameContext rangeOfString:[NSString stringWithFormat:@"%@\\",key]];
		if (end.location == NSNotFound) {
			NSLog(@"KEY BROKEN");
		}else {
			NSString* firstS = [self.gameContext substringToIndex:first.location+first.length];
			NSString* endS = [self.gameContext substringFromIndex:end.location];
			
			self.gameContext = [NSString stringWithFormat:@"%@%@%@",firstS,content,endS];
		}
	}
}

@end

