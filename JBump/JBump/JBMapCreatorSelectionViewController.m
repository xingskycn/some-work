//
//  JBMapCreatorSelectionViewController.m
//  JBump
//
//  Created by Nils Ziehn on 10/11/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#define jbMAPCREATORSELECTIONVIEWCONTROLLER_SETTINGSCELL @"settingsCell"
#define jbMAPCREATORSELECTIONVIEWCONTROLLER_MAPCELL @"mapCell"



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
        cell = [tableView dequeueReusableCellWithIdentifier:jbMAPCREATORSELECTIONVIEWCONTROLLER_SETTINGSCELL];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:jbMAPCREATORSELECTIONVIEWCONTROLLER_SETTINGSCELL];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            [cell autorelease];
        }
        NSDictionary* setting = [self.settingsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [setting objectForKey:jbNAME];
        return cell;
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:jbMAPCREATORSELECTIONVIEWCONTROLLER_MAPCELL];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:jbMAPCREATORSELECTIONVIEWCONTROLLER_MAPCELL];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.backgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.backgroundView.autoresizingMask  = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [cell.backgroundView release];
            [cell autorelease];
        }
        NSMutableDictionary* mapDict = [self.existingMaps objectAtIndex:indexPath.row];
        cell.imageView.image = [mapDict objectForKey:jbTHUMBNAIL];
        cell.textLabel.text = [mapDict objectForKey:jbNAME];
        if (![[mapDict objectForKey:jbID] hasPrefix:jbMAPPREFIX_CUSTOM]) {
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
        if (![[mapDict objectForKey:jbID] hasPrefix:jbMAPPREFIX_CUSTOM]) {
            editExistingMapButton.alpha = .4f;
            editExistingMapButton.enabled = FALSE;
        }else{
            editExistingMapButton.alpha = 1.f;
            editExistingMapButton.enabled = TRUE;
        }
    }
}
@end
