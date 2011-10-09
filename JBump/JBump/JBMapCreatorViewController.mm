//
//  JBMapCreatorViewController.m
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBMapCreatorViewController.h"

#import "JBMap.h"
#import "JBMapManager.h"

#import "JBMapItem.h"

#import "JBEntity.h"
#import "JBEntityManager.h"

#import "JBBrush.h"
#import "JBBrushManager.h"

#import "JBMapCreatorLayer.h"
#import "JBLineSprite.h"
#import "JBTouchForwardView.h"

@implementation JBMapCreatorViewController
@synthesize availableBrushesArray,availableEntitiesArray;
@synthesize mapCreatorLayer;
@synthesize sideView,kindChooser,contentsTable,openButton,menuContainer,magnifier,sidebarClosed;
@synthesize forwarder;

CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};

- (void)viewDidLoad
{
    self.availableEntitiesArray = [JBEntityManager getAllEnteties];
    self.availableBrushesArray = [JBBrushManager getAllBrushes];
    
    self.sideView.receiver = [[CCDirector sharedDirector] openGLView];
    self.forwarder.receiver = [[CCDirector sharedDirector] openGLView];
    
    CCScene* scene = [JBMapCreatorLayer scene];
    self.mapCreatorLayer = (JBMapCreatorLayer *)[scene getChildByTag:0];
    self.mapCreatorLayer.magnifier = self.magnifier;
    
    [[CCDirector sharedDirector] replaceScene:scene];
    
    if (self.availableBrushesArray.count) {
        [contentsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        self.mapCreatorLayer.userSelection = [availableBrushesArray objectAtIndex:0];
    }
    
}

- (void)viedDidUnload{
    self.sideView = nil;
    self.kindChooser = nil;
    self.contentsTable = nil;
    self.openButton = nil;
    self.menuContainer = nil;
    self.magnifier = nil;
}

- (void)dealloc
{
    [self.availableBrushesArray removeAllObjects];
    self.availableBrushesArray = nil;
    [self.availableEntitiesArray removeAllObjects];
    self.availableEntitiesArray = nil;
    
    self.mapCreatorLayer = nil;
    self.sideView = nil;
    self.kindChooser = nil;
    self.contentsTable = nil;
    self.openButton = nil;
    self.menuContainer = nil;
    self.magnifier = nil;
    self.forwarder = nil;
    [super dealloc];
}

- (IBAction)switchKind:(id)sender
{
    if (oldEditStyle==2) {
        if ([contentsTable numberOfRowsInSection:0]) {
            CCSprite* sprite = [[self.mapCreatorLayer.history objectAtIndex:[contentsTable indexPathForSelectedRow].row] objectForKey:@"sprite"];
            if ([sprite isKindOfClass:[JBLineSprite class]]) {
                ((JBLineSprite *)sprite).highLighted = FALSE;
            }else{
                while (CCSprite* cross = (CCSprite *)[mapCreatorLayer getChildByTag:[@"cross" hash]]) {
                    [mapCreatorLayer removeChild:cross cleanup:YES];
                } 
            }
        }
    }
    mapCreatorLayer.userSelection = nil;
    [contentsTable reloadData];
    
    if (kindChooser.selectedSegmentIndex == 0) {
        if (self.availableBrushesArray.count) {
            [contentsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            self.mapCreatorLayer.userSelection = [availableBrushesArray objectAtIndex:0];
        }
    }else if (kindChooser.selectedSegmentIndex == 1) {
        if (self.availableEntitiesArray.count) {
            mapCreatorLayer.userSelection = [availableEntitiesArray objectAtIndex:0];
            [contentsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }
    
    oldEditStyle = kindChooser.selectedSegmentIndex;
}

- (IBAction)closeSidebar:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if (sidebarClosed) {
        sideView.frame = CGRectMake(300, 0, 180, 320);
        sidebarClosed = FALSE;
        [openButton setTitle:@">" forState:UIControlStateNormal];
        
    }else{
        sideView.frame = CGRectMake(447, 0, 180, 320);
        sidebarClosed = TRUE;
        [openButton setTitle:@"<" forState:UIControlStateNormal];
    }
    [UIView commitAnimations];
}

- (IBAction)backButtonPressed:(id)sender {
    /*NSMutableArray* entityArray = [NSMutableArray new];
    NSMutableArray* curvesArray = [NSMutableArray new];
    
    for(NSMutableDictionary* dict in mapCreatorLayer.history)
    {
        if ([[dict objectForKey:@"kind"] isEqualToString:@"entity"]) {
            NSMutableDictionary* entityDict = [NSMutableDictionary new];
            [entityDict setObject:[dict objectForKey:@"entityID"] forKey:@"entityID"];
            CCSprite* sprite = [dict objectForKey:@"sprite"];
            [entityDict setObject:NSStringFromCGPoint([sprite position]) forKey:@"position"];
            [mapCreatorLayer removeChild:sprite cleanup:YES];
            [entityDict release];
        }else if([[dict objectForKey:@"kind"] isEqualToString:@"brush"]){
            NSMutableArray* pointsArray = ((JBLineSprite *)[dict objectForKey:@"sprite"]).pointArray;
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
    [curvesArray release];*/ 
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (kindChooser.selectedSegmentIndex==0) {
        return availableBrushesArray.count;
    }else if(kindChooser.selectedSegmentIndex==1){
        return availableEntitiesArray.count;
    }else{
        return mapCreatorLayer.history.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    // entity section has segment index 1, brush segment has segment index 0
    if (kindChooser.selectedSegmentIndex==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"brushCell"];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:@"brushCell"] autorelease];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        }
        JBBrush* brush = [availableBrushesArray objectAtIndex:indexPath.row];
        cell.imageView.image = brush.image;
        cell.textLabel.text = brush.name;
        cell.detailTextLabel.text = brush.further;
    }else if (kindChooser.selectedSegmentIndex==1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"entityCell"];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:@"entityCell"] autorelease];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        }
        JBEntity* entity = [availableEntitiesArray objectAtIndex:indexPath.row];
        cell.imageView.image = entity.image;
        cell.textLabel.text = entity.name;
        cell.detailTextLabel.text = entity.further;
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
        NSDictionary* historyDict = [mapCreatorLayer.history objectAtIndex:indexPath.row];
        JBMapItem* historyItem = [historyDict objectForKey:@"mapItem"];
        cell.imageView.image = historyItem.image;
        cell.textLabel.text = historyItem.name;
        cell.detailTextLabel.text = historyItem.further;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // entity section has segment index 1, brush segment has segment index 0
    if (kindChooser.selectedSegmentIndex==0) {
        mapCreatorLayer.userSelection = [availableBrushesArray objectAtIndex:indexPath.row];
    }else if (kindChooser.selectedSegmentIndex==1) {
        mapCreatorLayer.userSelection = [availableEntitiesArray objectAtIndex:indexPath.row];
    }else{
        CCSprite* sprite = [[mapCreatorLayer.history objectAtIndex:indexPath.row] objectForKey:@"sprite"];
        if ([sprite isKindOfClass:[JBLineSprite class]]) {
            ((JBLineSprite *)sprite).highLighted = TRUE;
        }else{
            CCSprite* cross = [CCSprite spriteWithFile:@"cross.png"];
            [cross setPosition:[sprite position]];
            [mapCreatorLayer addChild:cross z:0 tag:[@"cross" hash]];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (kindChooser.selectedSegmentIndex==2) {
        CCSprite* sprite = [[mapCreatorLayer.history objectAtIndex:indexPath.row] objectForKey:@"sprite"];
        if ([sprite isKindOfClass:[JBLineSprite class]]) {
            ((JBLineSprite *)sprite).highLighted = FALSE;
        }else{
            while (CCSprite* cross = (CCSprite *)[mapCreatorLayer getChildByTag:[@"cross" hash]]) {
                [mapCreatorLayer removeChild:cross cleanup:YES];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (kindChooser.selectedSegmentIndex==2) {
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
    if (kindChooser.selectedSegmentIndex==2) {
        NSMutableDictionary* dict = [mapCreatorLayer.history objectAtIndex:indexPath.row];
        CCSprite* sprite = [dict objectForKey:@"sprite"];
        [mapCreatorLayer removeChild:sprite cleanup:YES];
        [mapCreatorLayer.history removeObject:dict];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        CCSprite* cross = (CCSprite *)[mapCreatorLayer getChildByTag:[@"cross" hash]];
        if (cross) {
            [mapCreatorLayer removeChild:cross cleanup:YES];
        }
    }
}


@end
