//
//  MapViewController.m
//  MapCreator
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//


#import "MapViewController.h"

#import "MapLayer.h"
#import "TouchForwardView.h"

@implementation MapViewController
@synthesize editStyleControll;
@synthesize contentsTable;
@synthesize ocBarButton;
@synthesize menuContainer;
@synthesize slideOutView;
@synthesize forwarder;
@synthesize magnifier,brushArray, entityArray,mapLayer;
@synthesize sidebarClosed;

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
    //self.slideOutView.receiver = self.forwarder.receiver;
    
    
    self.entityArray = [NSMutableArray array];
    self.brushArray = [NSMutableArray array];
    mapLayer.magnifier = self.magnifier;
    
    NSMutableDictionary* entity1 = [NSMutableDictionary dictionary];
    [entity1 setObject:[UIImage imageNamed:@"Icon-Small.png"] forKey:@"image"];
    [entity1 setObject:@"entity1" forKey:@"name"];
    [entity1 setObject:@"this is the first entity" forKey:@"further"];
    
    NSMutableDictionary* entity2 = [NSMutableDictionary dictionary];
    [entity2 setObject:[UIImage imageNamed:@"Icon-Small.png"] forKey:@"image"];
    [entity2 setObject:@"entity2" forKey:@"name"];
    [entity2 setObject:@"this is another entity" forKey:@"further"];
    
    NSMutableDictionary* entity3 = [NSMutableDictionary dictionary];
    [entity3 setObject:[UIImage imageNamed:@"Icon-Small.png"] forKey:@"image"];
    [entity3 setObject:@"spawnpoint" forKey:@"name"];
    [entity3 setObject:@"heros spawn here" forKey:@"further"];
    
    [self.entityArray addObject:entity1];
    [self.entityArray addObject:entity2];
    [self.entityArray addObject:entity3];
    
    NSMutableDictionary* brush1 = [NSMutableDictionary dictionary];
    [brush1 setObject:[UIImage imageNamed:@"redbrush.png"] forKey:@"image"];
    [brush1 setObject:@"solid" forKey:@"name"];
    [brush1 setObject:@"this is the first brush" forKey:@"further"];
    
    NSMutableDictionary* brush2 = [NSMutableDictionary dictionary];
    [brush2 setObject:[UIImage imageNamed:@"redbrush.png"] forKey:@"image"];
    [brush2 setObject:@"semi solid" forKey:@"name"];
    [brush2 setObject:@"this is also a brush!" forKey:@"further"];
    
    NSMutableDictionary* brush3 = [NSMutableDictionary dictionary];
    [brush3 setObject:[UIImage imageNamed:@"redbrush.png"] forKey:@"image"];
    [brush3 setObject:@"bounce" forKey:@"name"];
    [brush3 setObject:@"JUMP!" forKey:@"further"];
    
    [self.brushArray addObject:brush1];
    [self.brushArray addObject:brush2];
    [self.brushArray addObject:brush3];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    [contentsTable reloadData];
}

- (IBAction)closeSidebar:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    if (sidebarClosed) {
        slideOutView.frame = CGRectMake(300, 0, 180, 300);
        sidebarClosed = FALSE;
        [ocBarButton setTitle:@">" forState:UIControlStateNormal];
        
    }else{
        slideOutView.frame = CGRectMake(447, 0, 180, 300);
        sidebarClosed = TRUE;
        [ocBarButton setTitle:@"<" forState:UIControlStateNormal];
    }
    [UIView commitAnimations];
}

- (IBAction)backButtonPressed:(id)sender {
    
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (editStyleControll.selectedSegmentIndex) {
        return entityArray.count;
    }else{
        return brushArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    // entity section has segment index 1, brush segment has segment index 0
    if (editStyleControll.selectedSegmentIndex) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"entityCell"];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:@"entityCell"] autorelease];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.numberOfLines = 3;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        }
        NSDictionary* entityDict = [entityArray objectAtIndex:indexPath.row];
        cell.imageView.image = [entityDict objectForKey:@"image"];
        cell.textLabel.text = [entityDict objectForKey:@"name"];
        cell.detailTextLabel.text = [entityDict objectForKey:@"further"];
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"brushCell"];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:@"brushCell"] autorelease];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.numberOfLines = 3;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        }
        NSDictionary* brushDict = [brushArray objectAtIndex:indexPath.row];
        cell.imageView.image = [brushDict objectForKey:@"image"];
        cell.textLabel.text = [brushDict objectForKey:@"name"];
        cell.detailTextLabel.text = [brushDict objectForKey:@"further"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select row!");
}

@end
