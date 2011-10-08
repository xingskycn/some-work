//
//  APQuickStartGenerator.m
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import "APQuickStartGenerator.h"

#import "APMap.h"
#import "APPhysics.h"
#import "APChar.h"
#import "APGameViewController.h"
#import "APSkinDict.h"
#import "APGameSelectionController.h"
#import "APPreGameViewController.h"
#import "APMapDict.h"

@implementation APQuickStartGenerator

+ (APMap *)getMapTileForContentView:(UIScrollView *)contentView position:(CGPoint )position;
{
	char mapCharacteristics[] = {	
		0,0,0,0,	0,0,0,0,	0,0,0,0,	0,0,0,
		0,0,0,0,	0,0,0,0,	0,0,0,0,	0,0,0,
		0,0,0,0,	0,0,0,0,	0,0,0,0,	0,0,0,
		0,0,0,0,	0,0,0,0,	0,0,0,1,	0,0,0,
		0,0,0,0,	0,0,0,0,	0,0,0,0,	0,0,0,
		0,0,0,1,	0,0,0,1,	1,1,0,0,	0,0,0,
		0,0,0,0,	0,0,0,0,	0,0,0,0,	0,0,0,
		0,0,0,0,	0,1,1,1,	0,0,0,0,	0,1,1,
		0,0,0,0,	0,0,0,0,	0,0,0,0,	0,0,0,
		0,0,1,1,	0,0,0,0,	0,0,1,0,	0,0,0
	};
	
	int width = 15;
	int height = 10;
	APMap* map = [[APMap alloc] initWithImage:[UIImage imageNamed:@"run1_tile5.jpg"] width:width height:height matrix:mapCharacteristics];
	map.frame = CGRectMake(position.x, position.y, map.frame.size.width, map.frame.size.height);
	[contentView insertSubview:map atIndex:0];
	[[APPhysics single].maps addObject:map];
	[map release];
	
	return map;
}



+ (APChar *)getPlayerCharForContentView:(UIView *)contentView 
							  userInput:(NSMutableDictionary *)userInput 
							   gameView:(APGameViewController *)gameView
{
	NSMutableDictionary* playerInitDict = [NSMutableDictionary new];
	
	int selectedChar = [[[NSUserDefaults standardUserDefaults] objectForKey:@"skin_ID"] intValue];
	
	UIImage* image = [[[[APSkinDict single] listSkins] objectAtIndex:selectedChar]objectForKey:@"image"];
	
	[playerInitDict setObject:image forKey:@"image"];
	[playerInitDict setObject:@"bunny_1" forKey:@"char_name"];
	[playerInitDict setObject:userInput forKey:@"inputs"];
	[playerInitDict setObject:gameView forKey:@"game_view"];
	NSString* playerName;
	if(playerName = [[NSUserDefaults standardUserDefaults] objectForKey:@"player_name"])
		[playerInitDict setObject:playerName forKey:@"player_name"];
	
	APChar* playerChar = [[APChar alloc] initWithDict:playerInitDict];
	[APPhysics single].player = playerChar;
	[contentView addSubview:playerChar];
	[playerInitDict release];
	[playerChar release];
	
	return playerChar;
}





@end
