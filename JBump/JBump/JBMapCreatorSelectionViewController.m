//
//  JBMapCreatorSelectionViewController.m
//  JBump
//
//  Created by Nils Ziehn on 10/11/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBMapCreatorSelectionViewController.h"

#import "JBMapManager.h"
#import "JBMap.h"


@implementation JBMapCreatorSelectionViewController
@synthesize editExistingMapButton;
@synthesize settingsTableView;
@synthesize existingMapsTableView;
@synthesize settingsArray;
@synthesize existingMaps;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.settingsArray = [JBMapManager getAllPredefinedSettings];
    self.existingMaps = [JBMapManager getAllMapDescriptions];
}

- (void)dealloc {
    [editExistingMapButton release];
    [settingsTableView release];
    [existingMapsTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setEditExistingMapButton:nil];
    [self setSettingsTableView:nil];
    [self setExistingMapsTableView:nil];
    [super viewDidUnload];
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==settingsTableView) {
        return settingsArray.count;
    }else if(tableView == existingMapsTableView)
    {
        return existingMaps.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    if (tableView==settingsTableView) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingsCell"];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            [cell autorelease];
        }
        NSDictionary* setting = [self.settingsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [setting objectForKey:@"name"];
        return cell;
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"mapCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mapCell"];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.backgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.backgroundView.autoresizingMask  = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [cell.backgroundView release];
            [cell autorelease];
        }
        NSMutableDictionary* mapDict = [self.existingMaps objectAtIndex:indexPath.row];
        cell.imageView.image = [mapDict objectForKey:@"thumbnail"];
        cell.textLabel.text = [mapDict objectForKey:@"mapName"];
        if (![[mapDict objectForKey:@"mapID"] hasPrefix:@"C_"]) {
            cell.selectionStyle=UITableViewCellSelectionStyleGray;
            cell.backgroundView.backgroundColor = [UIColor colorWithRed:.8f green:.1f blue:.1f alpha:.4f];
        }else{
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            cell.backgroundView.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.0f];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==existingMapsTableView) {
        NSMutableDictionary* mapDict = [self.existingMaps objectAtIndex:indexPath.row];
        if (![[mapDict objectForKey:@"mapID"] hasPrefix:@"C_"]) {
            editExistingMapButton.alpha = .4f;
            editExistingMapButton.enabled = FALSE;
        }else{
            editExistingMapButton.alpha = 1.f;
            editExistingMapButton.enabled = TRUE;
        }
    }
}
@end
