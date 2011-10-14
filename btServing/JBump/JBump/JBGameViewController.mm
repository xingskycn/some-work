//
//  JBGameViewController.m
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBGameViewController.h"
#import "JBGameLayer.h"
#import "JBMultiplayerAdapter.h"
#import "JBTavern.h"
#import "JBHero.h"

@interface JBGameViewController()

- (void)moveSideViewToState:(int)state;

@end


@implementation JBGameViewController

@synthesize gameLayer;
@synthesize multiplayerAdapter;
@synthesize selectedMap;
@synthesize scoreTableView;

@synthesize sideView;
@synthesize popout;
@synthesize popin;
@synthesize jumpButton;
@synthesize moveLeftButton;
@synthesize moveRightButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CCScene* scene = [JBGameLayer scene];
    self.gameLayer = (JBGameLayer *)[scene getChildByTag:0];
    [[CCDirector sharedDirector] replaceScene:scene];
    
    [self moveSideViewToState:sideViewState];
    
    self.gameLayer.gameViewController=self;
    if (self.multiplayerAdapter!=nil) {
        self.gameLayer.tavern = self.multiplayerAdapter.tavern;
        self.multiplayerAdapter.tavern.gameLayer = self.gameLayer;
    }
    if (self.selectedMap!=nil) {
        [self.gameLayer loadMap:self.selectedMap];
    }
}

- (void)viewDidUnload
{
    [self setSideView:nil];
    [self setPopout:nil];
    [self setPopin:nil];
    [self setJumpButton:nil];
    [self setMoveLeftButton:nil];
    [self setMoveRightButton:nil];
    [self setScoreTableView:nil];
    [super viewDidUnload];
}
- (void)dealloc {
    
    self.gameLayer.gameViewController = nil;
    self.gameLayer=nil;
    [sideView release];
    [popout release];
    [popin release];
    [jumpButton release];
    [moveLeftButton release];
    [moveRightButton release];
    [scoreTableView release];
    [super dealloc];
}

- (IBAction)jumpButtonPressed:(id)sender {
    [self.gameLayer resetJumpForce];
}
- (IBAction)rightButtonPressed:(id)sender {
}

- (void)moveSideViewToState:(int)state
{
    if (state==0) {
        sideView.frame = CGRectMake(452, 0, 170, 248);
        popout.enabled = YES;
        popin.enabled = NO;
        popout.alpha = 1.f;
        popin.alpha = .2f;
    }else if(state==1){
        sideView.frame = CGRectMake(310, 0, 170, 248);
        popout.enabled = YES;
        popin.enabled = YES;
        popout.alpha = 1.f;
        popin.alpha = 1.f;
    }else{
        sideView.frame = CGRectMake(100, 0, 380, 248);
        popout.enabled = NO;
        popin.enabled = YES;
        popout.alpha = .2f;
        popin.alpha = 1.f;
    }
}

- (IBAction)popinButtonPressed:(id)sender {
    if (sideViewState>0) {
        sideViewState--;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self moveSideViewToState:sideViewState];
        [UIView commitAnimations];
        
    }
    if (sideViewState==0) {
        popin.enabled = NO;
        popin.alpha = 0.2;
    }
}

- (IBAction)popoutButtonPressed:(id)sender {
    if (sideViewState<2) {
        sideViewState++;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [self moveSideViewToState:sideViewState];
        [UIView commitAnimations];
        popin.enabled = YES;
        popin.alpha = 1.f;
    }
    if (sideViewState==2) {
        popout.enabled = NO;
        popout.alpha = 0.2;
    }
}

- (IBAction)leftButtonPressed:(id)sender {
}

#pragma mark tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.gameLayer.tavern.heroesInTavern allValues].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ScoreTableViewCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    NSArray *allPlayers = [self.gameLayer.tavern.heroesInTavern allValues];
    JBHero *aHero = [allPlayers objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:aHero.skinLocation];
    
    if ([self.gameLayer.gameType isEqualToString:jbMAPSETTINGS_SOCCER]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", aHero.name, [aHero.gameContext objectForKey:jbGAMECONTEXT_GOALS]];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", aHero.name, [aHero.gameContext objectForKey:jbGAMECONTEXT_KILL_COUNT]];
    }
    
    
    return cell;
}

@end
