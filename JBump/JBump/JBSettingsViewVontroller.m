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
        self.allSkins = [JBSkinManager getAllSkins];
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
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"jdPlayerName"]!=nil) {
        self.playerNameText.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"jdPlayerName"];
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"jdPlayerNameSizeValue"]!=nil) {
        self.playerNameSlider.value=[[[NSUserDefaults standardUserDefaults] valueForKey:@"jdPlayerNameSizeValue"] floatValue];
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"jdCustomSkinDownload"]!=nil) {
        [self.cSkinDownloadSwitch setOn:[[[NSUserDefaults standardUserDefaults] valueForKey:@"jdCustomSkinDownload"] boolValue] animated:NO]; ;
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"jdShowScoreBoard"]!=nil) {
        [self.scoreBoardSwitch setOn:[[[NSUserDefaults standardUserDefaults] valueForKey:@"jdShowScoreBoard"] boolValue] animated:NO];
    }
    self.skinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    int i = 0;
    for (NSDictionary *dict in self.allSkins) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"skinID"]!=nil&&[[[NSUserDefaults standardUserDefaults] valueForKey:@"skinID"] isEqualToString:[dict objectForKey:@"skinID"]]) {
            self.selectedCell = [NSIndexPath indexPathForRow:i inSection:0];
        }
        i++;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.skinTableView selectRowAtIndexPath:self.selectedCell animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)viewDidUnload
{
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
    [[NSUserDefaults standardUserDefaults] setValue:self.playerNameText.text forKey:@"jdPlayerName"];
}

- (IBAction)playerNameSizeValueChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:self.playerNameSlider.value] forKey:@"jdPlayerNameSizeValue"];
}

- (IBAction)customSkinDownloadValueChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:self.cSkinDownloadSwitch.isOn] forKey:@"jdCustomSkinDownload"];
}

- (IBAction)showScoreBoardValueChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:self.scoreBoardSwitch.isOn] forKey:@"jdShowScoreBoard"];
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
    
    cell.mainView.image = [[self.allSkins objectAtIndex:indexPath.row] objectForKey:@"thumbnail"];
    
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSUserDefaults standardUserDefaults] setValue:[[self.allSkins objectAtIndex:indexPath.row] objectForKey:@"skinID"] forKey:@"skinID"];
}

@end
