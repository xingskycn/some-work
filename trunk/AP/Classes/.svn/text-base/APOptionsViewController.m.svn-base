//
//  APOptionsViewTableViewCell.m
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import "APOptionsViewController.h"
#import "APViewController.h"
#import "APOptionsViewTableViewCell.h"

#import "APSkinDict.h"

@implementation APOptionsViewController
@synthesize skins;


- (void)viewDidLoad
{
	[super viewDidLoad];
	int selectedChar = [[[NSUserDefaults standardUserDefaults] objectForKey:@"skin_ID"] intValue];
	playerNameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"player_name"];
	
	self.skins = [[APSkinDict single] listSkins];
	[skinSelectionTable reloadData];
	
	
	[skinSelectionTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedChar inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
	
	fontSizeSlider.value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"name_label_size"] floatValue];
	
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"show_scoreboard"] isEqualToString:@"on"]) {
		showScoreBoardSwitch.on = TRUE;
	}else {
		showScoreBoardSwitch.on = FALSE;
	}

	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"custom_skin_download"] isEqualToString:@"on"]) {
		customSkinDownloadSwitch.on = TRUE;
	}else {
		customSkinDownloadSwitch.on = FALSE;
	}
	
	
}

- (IBAction)saveButtonPressed:(UIButton *)button
{
	if ([playerNameField.text length]>0) {
		[[NSUserDefaults standardUserDefaults] setObject:playerNameField.text forKey:@"player_name"];
	}
	
	if (showScoreBoardSwitch.on) {
		[[NSUserDefaults standardUserDefaults] setObject:@"on" forKey:@"show_scoreboard"];
	}else {
		[[NSUserDefaults standardUserDefaults] setObject:@"off" forKey:@"show_scoreboard"];
	}
	
	if (customSkinDownloadSwitch.on) {
		[[NSUserDefaults standardUserDefaults] setObject:@"on" forKey:@"custom_skin_download"];
	}else {
		[[NSUserDefaults standardUserDefaults] setObject:@"off" forKey:@"custom_skin_download"];
	}
	
	[[APViewController single] showMain];
	[playerNameField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([string isEqualToString:@"\n"]) {
		[playerNameField resignFirstResponder];
		return NO;
	}
	return YES;
}

- (IBAction)playerNameDisplaySizeChanged:(UISlider *)slider
{
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat: slider.value] forKey:@"name_label_size"];
}

- (void)dealloc {
	NSLog(@"APOptionsViewController.dealloc()");
    [super dealloc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	APOptionsViewTableViewCell* cell = (APOptionsViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"char_cell"];
	if (!cell) {
		cell = [[[APOptionsViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"char_cell"] autorelease];		
	}
	
	cell.mainView.image = [[skins objectAtIndex:[indexPath row]] objectForKey:@"image"];
	
	return cell;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [skins count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",[indexPath row]] forKey:@"skin_ID"];
}


@end
