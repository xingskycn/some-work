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
}

- (IBAction)editExistingMapButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"mapCreatorSettingsViewController" sender:self];
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
            [cell autorelease];
        }
        JBMap* map = [self.existingMaps objectAtIndex:indexPath.row];
        cell.imageView.image = map.thumbnail;
        cell.textLabel.text = map.mapName;
        return cell;
    }
}
@end
