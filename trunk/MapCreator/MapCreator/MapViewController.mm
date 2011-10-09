//
//  MapViewController.m
//  MapCreator
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "MapViewController.h"

#import "MapLayer.h"
#import "TouchForwardView.h"
#import "LineSprite.h"
@implementation MapViewController
@synthesize editStyleControll;
@synthesize contentsTable;
@synthesize ocBarButton;
@synthesize menuContainer;
@synthesize slideOutView;
@synthesize forwarder;
@synthesize magnifier,brushArray, entityArray,mapLayer;
@synthesize sidebarClosed;

CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    
    
    self.entityArray = [NSMutableArray array];
    self.brushArray = [NSMutableArray array];
    mapLayer.magnifier = self.magnifier;
    
    NSString* path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"image"];
    
    [UIImagePNGRepresentation([UIImage imageNamed:@"Icon-Small.png"]) writeToFile:path atomically:YES];
    
    NSMutableDictionary* entity1 = [NSMutableDictionary dictionary];
    [entity1 setObject:@"entity" forKey:@"kind"];
    [entity1 setObject:[UIImage imageNamed:@"Icon-Small.png"] forKey:@"image"];
    [entity1 setObject:@"entity1" forKey:@"name"];
    [entity1 setObject:@"this is the first entity" forKey:@"further"];
    [entity1 setObject:path forKey:@"imageLocation"];
    
    NSMutableDictionary* entity2 = [NSMutableDictionary dictionary];
    [entity2 setObject:@"entity" forKey:@"kind"];
    [entity2 setObject:[UIImage imageNamed:@"Icon-Small.png"] forKey:@"image"];
    [entity2 setObject:@"entity2" forKey:@"name"];
    [entity2 setObject:@"this is another entity" forKey:@"further"];
    [entity2 setObject:path forKey:@"imageLocation"];
    
    NSMutableDictionary* entity3 = [NSMutableDictionary dictionary];
    [entity3 setObject:@"entity" forKey:@"kind"];
    [entity3 setObject:[UIImage imageNamed:@"Icon-Small.png"] forKey:@"image"];
    [entity3 setObject:@"spawnpoint" forKey:@"name"];
    [entity3 setObject:@"heros spawn here" forKey:@"further"];
    [entity3 setObject:path forKey:@"imageLocation"];
    
    [self.entityArray addObject:entity1];
    [self.entityArray addObject:entity2];
    [self.entityArray addObject:entity3];
    
    NSMutableDictionary* brush1 = [NSMutableDictionary dictionary];
    [brush1 setObject:@"brush" forKey:@"kind"];
    [brush1 setObject:[UIImage imageNamed:@"redbrush.png"] forKey:@"image"];
    [brush1 setObject:@"solid" forKey:@"name"];
    [brush1 setObject:@"this is the first brush" forKey:@"further"];
    [brush1 setObject:[NSNumber numberWithFloat:1.0] forKey:@"red"];
    [brush1 setObject:[NSNumber numberWithFloat:0.0] forKey:@"green"];
    [brush1 setObject:[NSNumber numberWithFloat:0.0] forKey:@"blue"];
    [brush1 setObject:[NSNumber numberWithFloat:1.0] forKey:@"alpha"];
    
    NSMutableDictionary* brush2 = [NSMutableDictionary dictionary];
    [brush2 setObject:@"brush" forKey:@"kind"];
    [brush2 setObject:[UIImage imageNamed:@"redbrush.png"] forKey:@"image"];
    [brush2 setObject:@"semi solid" forKey:@"name"];
    [brush2 setObject:@"this is also a brush!" forKey:@"further"];
    [brush2 setObject:[NSNumber numberWithFloat:0.0] forKey:@"red"];
    [brush2 setObject:[NSNumber numberWithFloat:1.0] forKey:@"green"];
    [brush2 setObject:[NSNumber numberWithFloat:0.0] forKey:@"blue"];
    [brush2 setObject:[NSNumber numberWithFloat:1.0] forKey:@"alpha"];
    
    NSMutableDictionary* brush3 = [NSMutableDictionary dictionary];
    [brush3 setObject:@"brush" forKey:@"kind"];
    [brush3 setObject:[UIImage imageNamed:@"redbrush.png"] forKey:@"image"];
    [brush3 setObject:@"bounce" forKey:@"name"];
    [brush3 setObject:@"JUMP!" forKey:@"further"];
    [brush3 setObject:[NSNumber numberWithFloat:0.0] forKey:@"red"];
    [brush3 setObject:[NSNumber numberWithFloat:0.0] forKey:@"green"];
    [brush3 setObject:[NSNumber numberWithFloat:1.0] forKey:@"blue"];
    [brush3 setObject:[NSNumber numberWithFloat:1.0] forKey:@"alpha"];
    
    [self.brushArray addObject:brush1];
    [self.brushArray addObject:brush2];
    [self.brushArray addObject:brush3];
    
    [contentsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    mapLayer.userSelection = [brushArray objectAtIndex:0];
}

- (void)viewDidUnload
{
    [self setMagnifier:nil];
    [self setMenuContainer:nil];
    [self setSlideOutView:nil];
    [self setEditStyleControll:nil];
    [self setContentsTable:nil];
    [self setOcBarButton:nil];
    [self setForwarder:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {
    [magnifier release];
    [menuContainer release];
    [slideOutView release];
    [editStyleControll release];
    [contentsTable release];
    [ocBarButton release];
    [forwarder release];
    [super dealloc];
}
- (IBAction)switchEditStyle:(id)sender {
    if (oldEditStyle==2) {
        if ([contentsTable numberOfRowsInSection:0]) {
            CCSprite* sprite = [[mapLayer.history objectAtIndex:[contentsTable indexPathForSelectedRow].row] objectForKey:@"sprite"];
            if ([sprite isKindOfClass:[LineSprite class]]) {
                ((LineSprite *)sprite).highLighted = FALSE;
            }else{
                while (CCSprite* cross = (CCSprite *)[mapLayer getChildByTag:[@"cross" hash]]) {
                    [mapLayer removeChild:cross cleanup:YES];
                } 
            }
        }
    }
    mapLayer.userSelection = nil;
    [contentsTable reloadData];
    
    if (editStyleControll.selectedSegmentIndex == 0) {
        mapLayer.userSelection = [brushArray objectAtIndex:0];
        [contentsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }else if (editStyleControll.selectedSegmentIndex == 1) {
        mapLayer.userSelection = [entityArray objectAtIndex:0];
        [contentsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    
    oldEditStyle = editStyleControll.selectedSegmentIndex;
}

- (IBAction)closeSidebar:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if (sidebarClosed) {
        slideOutView.frame = CGRectMake(300, 0, 180, 320);
        sidebarClosed = FALSE;
        [ocBarButton setTitle:@">" forState:UIControlStateNormal];
        
    }else{
        slideOutView.frame = CGRectMake(447, 0, 180, 320);
        sidebarClosed = TRUE;
        [ocBarButton setTitle:@"<" forState:UIControlStateNormal];
    }
    [UIView commitAnimations];
}

- (IBAction)backButtonPressed:(id)sender {
    NSMutableArray* entityArray = [NSMutableArray new];
    NSMutableArray* curvesArray = [NSMutableArray new];
    
    for(NSMutableDictionary* dict in mapLayer.history)
    {
        if ([[dict objectForKey:@"kind"] isEqualToString:@"entity"]) {
            NSMutableDictionary* entityDict = [NSMutableDictionary new];
            [entityDict setObject:[dict objectForKey:@"entityID"] forKey:@"entityID"];
            CCSprite* sprite = [dict objectForKey:@"sprite"];
            [entityDict setObject:NSStringFromCGPoint([sprite position]) forKey:@"position"];
            [mapLayer removeChild:sprite cleanup:YES];
            [entityDict release];
        }else if([[dict objectForKey:@"kind"] isEqualToString:@"brush"]){
            NSMutableArray* pointsArray = ((LineSprite *)[dict objectForKey:@"sprite"]).pointArray;
            if (pointsArray.count>1) {
                NSMutableArray* savePointsArray = [NSMutableArray new];
                CGPoint start = CGPointFromString([pointsArray objectAtIndex:0]);
                for(int i = 1; i < [pointsArray count]; i+=2)
                {
                    CGPoint end = CGPointFromString([pointsArray objectAtIndex:i]);
                    if (DistanceBetweenTwoPoints(start, end)>15) {
                        [pointsArray addObject:NSStringFromCGPoint(start)];
                        start = end;
                    }
                }
                [pointsArray addObject:NSStringFromCGPoint(start)];
                NSMutableDictionary* saveDict = [NSMutableDictionary new];
                NSString* type = [dict objectForKey:@"type"];
                if (type) {
                    [saveDict setObject:type forKey:@"type"];
                    [saveDict setObject:savePointsArray forKey:@"curce"];
                    [curvesArray addObject:saveDict];
                }
                [saveDict release];
                [savePointsArray release];
            }
        }
    }
    
    
    
    
    [entityArray release];
    [curvesArray release];
    
    
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (editStyleControll.selectedSegmentIndex==0) {
        return brushArray.count;
    }else if(editStyleControll.selectedSegmentIndex==1){
        return entityArray.count;
    }else{
        return mapLayer.history.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    // entity section has segment index 1, brush segment has segment index 0
    if (editStyleControll.selectedSegmentIndex==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"brushCell"];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:@"brushCell"] autorelease];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        }
        NSDictionary* brushDict = [brushArray objectAtIndex:indexPath.row];
        cell.imageView.image = [brushDict objectForKey:@"image"];
        cell.textLabel.text = [brushDict objectForKey:@"name"];
        cell.detailTextLabel.text = [brushDict objectForKey:@"further"];
    }else if (editStyleControll.selectedSegmentIndex==1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"entityCell"];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:@"entityCell"] autorelease];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        }
        NSDictionary* entityDict = [entityArray objectAtIndex:indexPath.row];
        cell.imageView.image = [entityDict objectForKey:@"image"];
        cell.textLabel.text = [entityDict objectForKey:@"name"];
        cell.detailTextLabel.text = [entityDict objectForKey:@"further"];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:@"historyCell"] autorelease];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        }
        NSDictionary* historyDict = [mapLayer.history objectAtIndex:indexPath.row];
        cell.imageView.image = [historyDict objectForKey:@"image"];
        cell.textLabel.text = [historyDict objectForKey:@"name"];
        cell.detailTextLabel.text = [historyDict objectForKey:@"further"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // entity section has segment index 1, brush segment has segment index 0
    if (editStyleControll.selectedSegmentIndex==0) {
        mapLayer.userSelection = [brushArray objectAtIndex:indexPath.row];
    }else if (editStyleControll.selectedSegmentIndex==1) {
        mapLayer.userSelection = [entityArray objectAtIndex:indexPath.row];
    }else{
        CCSprite* sprite = [[mapLayer.history objectAtIndex:indexPath.row] objectForKey:@"sprite"];
        if ([sprite isKindOfClass:[LineSprite class]]) {
            ((LineSprite *)sprite).highLighted = TRUE;
        }else{
            CCSprite* cross = [CCSprite spriteWithFile:@"cross.png"];
            [cross setPosition:[sprite position]];
            [mapLayer addChild:cross z:0 tag:[@"cross" hash]];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editStyleControll.selectedSegmentIndex==2) {
        CCSprite* sprite = [[mapLayer.history objectAtIndex:indexPath.row] objectForKey:@"sprite"];
        if ([sprite isKindOfClass:[LineSprite class]]) {
            ((LineSprite *)sprite).highLighted = FALSE;
        }else{
            while (CCSprite* cross = (CCSprite *)[mapLayer getChildByTag:[@"cross" hash]]) {
                [mapLayer removeChild:cross cleanup:YES];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editStyleControll.selectedSegmentIndex==2) {
        NSLog(@"swipe");
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editStyleControll.selectedSegmentIndex==2) {
        NSMutableDictionary* dict = [mapLayer.history objectAtIndex:indexPath.row];
        CCSprite* sprite = [dict objectForKey:@"sprite"];
        [mapLayer removeChild:sprite cleanup:YES];
        [mapLayer.history removeObject:dict];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        CCSprite* cross = (CCSprite *)[mapLayer getChildByTag:[@"cross" hash]];
        if (cross) {
            [mapLayer removeChild:cross cleanup:YES];
        }
    }
}


@end
