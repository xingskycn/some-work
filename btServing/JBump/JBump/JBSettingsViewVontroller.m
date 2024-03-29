//
//  JBSettingsViewVontroller.m
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBSettingsViewVontroller.h"
#import "JBSkinManager.h"
#import "JBSettingsViewTableViewCell.h"
#import "JBSkin.h"

@implementation JBSettingsViewVontroller
@synthesize skinTableView;
@synthesize cSkinDownloadSwitch;
@synthesize scoreBoardSwitch;
@synthesize playerNameSlider;
@synthesize playerNameText;

@synthesize selectedCell;
@synthesize allSkins;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.allSkins = [JBSkinManager getAllSkins];
    self.playerNameText.delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:jbUSERDEFAULTS_PLAYER_NAME]!=nil) {
        self.playerNameText.text=[[NSUserDefaults standardUserDefaults] valueForKey:jbUSERDEFAULTS_PLAYER_NAME];
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:jbUSERDEFAULTS_PLAYER_NAME_SIZE]!=nil) {
        self.playerNameSlider.value=[[[NSUserDefaults standardUserDefaults] valueForKey:jbUSERDEFAULTS_PLAYER_NAME_SIZE] floatValue];
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:jbUSERDEFAULTS_CUSTOM_SKIN_DOWNLOAD]!=nil) {
        [self.cSkinDownloadSwitch setOn:[[[NSUserDefaults standardUserDefaults] valueForKey:jbUSERDEFAULTS_CUSTOM_SKIN_DOWNLOAD] boolValue] animated:NO]; ;
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:jbUSERDEFAULTS_SHOW_SCOREBOARD]!=nil) {
        [self.scoreBoardSwitch setOn:[[[NSUserDefaults standardUserDefaults] valueForKey:jbUSERDEFAULTS_SHOW_SCOREBOARD] boolValue] animated:NO];
    }
    self.skinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    int i = 0;
    for (JBSkin *aSkin in self.allSkins) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:jbUSERDEFAULTS_SKIN]!=nil&&[[[NSUserDefaults standardUserDefaults] valueForKey:jbUSERDEFAULTS_SKIN] isEqualToString:aSkin.skinID]) {
            self.selectedCell = [NSIndexPath indexPathForRow:i inSection:0];
        }
        i++;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelectorOnMainThread:@selector(setScrollPosition) withObject:nil waitUntilDone:YES];
}

- (void)setScrollPosition {
    [self.skinTableView selectRowAtIndexPath:self.selectedCell animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

- (void)viewDidUnload
{
    [self.allSkins removeAllObjects];
    [self setSkinTableView:nil];
    [self setCSkinDownloadSwitch:nil];
    [self setScoreBoardSwitch:nil];
    [self setPlayerNameSlider:nil];
    [self setPlayerNameText:nil];
    [self setAllSkins:nil];
    [self setSelectedCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [skinTableView release];
    [cSkinDownloadSwitch release];
    [scoreBoardSwitch release];
    [playerNameSlider release];
    [playerNameText release];
    [allSkins release];
    [selectedCell release];
    
    [super dealloc];
}
- (IBAction)playerNameTextChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:self.playerNameText.text forKey:jbUSERDEFAULTS_PLAYER_NAME];
}

- (IBAction)playerNameSizeValueChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:self.playerNameSlider.value] forKey:jbUSERDEFAULTS_PLAYER_NAME_SIZE];
}

- (IBAction)customSkinDownloadValueChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:self.cSkinDownloadSwitch.isOn] forKey:jbUSERDEFAULTS_CUSTOM_SKIN_DOWNLOAD];
}

- (IBAction)showScoreBoardValueChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:self.scoreBoardSwitch.isOn] forKey:jbUSERDEFAULTS_SHOW_SCOREBOARD];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.playerNameText resignFirstResponder];
    return YES;
}

#pragma mark TableView Stuff

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allSkins count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 160;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"JBSettingsViewTableViewCell";

    JBSettingsViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[JBSettingsViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.mainView.image = ((JBSkin*)[self.allSkins objectAtIndex:indexPath.row]).thumbnail;
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSUserDefaults standardUserDefaults] setValue:[[self.allSkins objectAtIndex:indexPath.row] skinID] forKey:jbUSERDEFAULTS_SKIN];
}

@end
