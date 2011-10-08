//
//  APStatsViewController.m
//  AP
//
//  Created by Ziehn Nils on 6/19/11.
//  Copyright 2011 TU Munich. All rights reserved.
//



#import "APStatsViewController.h"
#import "APPhysics.h"
#import "APChar.h"
#import "APGameViewController.h"

@implementation APStatsViewController
@synthesize statsInformation;

- (void)viewDidLoad
{
	container.frame = CGRectMake(container.frame.size.width-44, 0, container.frame.size.width, container.frame.size.height);
	slideRightButton.alpha = 0;
}

- (void)updateStats
{
	self.statsInformation = [NSMutableArray array];
	for (APChar* chr in [[[APPhysics single] characters] allValues]) {
		[statsInformation addObject:chr];
	}
	[statsInformation addObject:[APPhysics single].player];
	
	if ([[APPhysics single].gameMode isEqualToString:@"std"]) {
		[self updateStatsForGameModeStd];
	}else if ([[APPhysics single].gameMode isEqualToString:@"run"]) {
		[self updateStatsForGameModeRun];
	}
	
	[statsTable reloadData];
}

- (void)updateStatsForGameModeRun
{
	self.statsInformation = [statsInformation sortedArrayUsingSelector:@selector(compareByDeaths:)];
	if ([statsInformation count]>1) {
		int playerKills = [[[APPhysics single].player getGameContentsForKey:@"PDEATHS{}:"] intValue];
		
		if ([statsInformation objectAtIndex:0]==[APPhysics single].player) {
			
			int chrKills = [[[statsInformation objectAtIndex:1] getGameContentsForKey:@"PDEATHS{}:"] intValue];
			
			int diff = playerKills - chrKills;
			
			[APGameViewController single].debugLabel.text = [NSString stringWithFormat:@"%@  leading by -%d",
															 [APPhysics single].player.nameLabel.text,diff];
		}else {
			APChar* chr = [statsInformation objectAtIndex:0];
			
			int chrKills = [[chr getGameContentsForKey:@"PDEATHS{}:"] intValue];
			
			int diff = chrKills - playerKills;
			
			[APGameViewController single].debugLabel.text = [NSString stringWithFormat:@"%@  pursued by -%d",
															 chr.nameLabel.text,diff];
		}
	}
}

- (void)updateStatsForGameModeStd
{
	self.statsInformation = [statsInformation sortedArrayUsingSelector:@selector(compareByKills:)];
	if ([statsInformation count]>1) {
		int playerKills = [[[APPhysics single].player getGameContentsForKey:@"PKILLS{}:"] intValue];
		
		if ([statsInformation objectAtIndex:0]==[APPhysics single].player) {
			
			int chrKills = [[[statsInformation objectAtIndex:1] getGameContentsForKey:@"PKILLS{}:"] intValue];
			
			int diff = playerKills - chrKills;
			
			[APGameViewController single].debugLabel.text = [NSString stringWithFormat:@"%@  leading by %d",
															 [APPhysics single].player.nameLabel.text,diff];
		}else {
			APChar* chr = [statsInformation objectAtIndex:0];
			
			int chrKills = [[chr getGameContentsForKey:@"PKILLS{}:"] intValue];
			
			int diff = chrKills - playerKills;
			
			[APGameViewController single].debugLabel.text = [NSString stringWithFormat:@"%@  pursued by %d",
															 chr.nameLabel.text,diff];
		}
	}
}

- (IBAction)slideLeftButtonPressed:(UIButton *)button
{
	if(container.frame.origin.x == 335)
	{
		slideLeftButton.enabled = FALSE;
		slideRightButton.enabled = TRUE;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationBeginsFromCurrentState:YES];
		slideLeftButton.alpha = 0.2;
		slideRightButton.alpha = 0.5;
		container.frame = CGRectMake(0, 0, container.frame.size.width, container.frame.size.height);
		[UIView commitAnimations];
		
	}else {
		slideLeftButton.enabled = TRUE;
		slideRightButton.enabled = TRUE;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationBeginsFromCurrentState:YES];
		slideLeftButton.alpha = 0.5;
		slideRightButton.alpha = 0.5;
		container.frame = CGRectMake(335, 0, container.frame.size.width, container.frame.size.height);
		[UIView commitAnimations];
	}
}

- (IBAction)slideRightButtonPressed:(UIButton *)button
{
	if(container.frame.origin.x == 335)
	{
		slideLeftButton.enabled = TRUE;
		slideRightButton.enabled = FALSE;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationBeginsFromCurrentState:YES];
		slideLeftButton.alpha = 0.5;
		slideRightButton.alpha = 0.2;
		container.frame = CGRectMake(container.frame.size.width-44, 0, container.frame.size.width, container.frame.size.height);
		[UIView commitAnimations];
		
	}else {
		slideLeftButton.enabled = TRUE;
		slideRightButton.enabled = TRUE;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationBeginsFromCurrentState:YES];
		slideLeftButton.alpha = 0.5;
		slideRightButton.alpha = 0.5;
		container.frame = CGRectMake(335, 0, container.frame.size.width, container.frame.size.height);
		[UIView commitAnimations];
	}
}


- (void)dealloc {
	NSLog(@"statsview dealloc");
	[self.view removeFromSuperview];
	
	//[self.statsInformation removeAllObjects];
	self.statsInformation = nil;
	
	
    [super dealloc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 72;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [statsInformation count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"stats_cell"];
	if(!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"stats_cell"];
	}
	APChar* chr = [statsInformation objectAtIndex:[indexPath row]];
	
	if ([[APPhysics single].gameMode isEqualToString:@"std"]) {
		int chrKills = [[chr getGameContentsForKey:@"PKILLS{}:"] intValue];
		cell.textLabel.text = [NSString stringWithFormat:@"%d",chrKills];
	}else if ([[APPhysics single].gameMode isEqualToString:@"run"]) {
		int chrDeaths = [[chr getGameContentsForKey:@"PDEATHS{}:"] intValue];
		cell.textLabel.text = [NSString stringWithFormat:@" :%d",chrDeaths];
	}
	
	cell.detailTextLabel.text = chr.nameLabel.text;
	
	return cell;
}


@end
