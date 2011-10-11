//
//  JBMapCreatorSettingsViewController.m
//  JBump
//
//  Created by Nils Ziehn on 10/11/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBMapCreatorSettingsViewController.h"

#import "JBMapManager.h"

@implementation JBMapCreatorSettingsViewController
@synthesize imageUrlField;
@synthesize mapNameField;
@synthesize imageView;
@synthesize advancedSettings;
@synthesize advancedSettingsTableView;
@synthesize activityIndicator;
@synthesize downloadImageButton;
@synthesize createButton;
@synthesize imageDownloadInProgress;
@synthesize settingsName;

- (id)init
{
    self = [super init];
    if (self) {
        self.advancedSettings = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (advancedSettings.count == 0) {
        self.advancedSettings = [[[JBMapManager getAllPredefinedSettings] objectAtIndex:0] objectForKey:@"settings"];
        [self.advancedSettingsTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)updateCreateButton
{
    if (!mapNameField.text || !imageView.image || imageDownloadInProgress) {
        self.createButton.alpha = .4f;
        self.createButton.enabled = FALSE;
    }else{
        self.createButton.alpha = 1.f;
        self.createButton.enabled = TRUE;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==imageUrlField) {
        textField.textColor = [UIColor blackColor];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.view.frame = CGRectMake(0, -160, 480, 320);
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.view.frame = CGRectMake(0, 0, 480, 320);
    [UIView commitAnimations];
    [textField resignFirstResponder];
    [self updateCreateButton];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.view.frame = CGRectMake(0, 0, 480, 320);
    [UIView commitAnimations];
    [textField resignFirstResponder];
    [self updateCreateButton];
}

- (void)dealloc {
    [imageUrlField release];
    [mapNameField release];
    [imageView release];
    [advancedSettingsTableView release];
    [settingsName release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImageUrlField:nil];
    [self setMapNameField:nil];
    [self setImageView:nil];
    [self setAdvancedSettingsTableView:nil];
    [self setSettingsName:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"startMapCreatorWithSettings"]) {
        [JBMapManager storeNewMapWithID:[NSString stringWithFormat:@"C_%@",mapNameField.text]
                                mapName:mapNameField.text
                             arenaImage:imageView.image
                               settings:self.advancedSettings];
        
    }
}
- (IBAction)downloadImageButtonPressed:(id)sender {
    [self performSelectorInBackground:@selector(downloadImageFromURL:) 
                           withObject:[NSURL URLWithString:imageUrlField.text]];
    [self.activityIndicator startAnimating];
    [self.imageUrlField resignFirstResponder];
    self.imageDownloadInProgress = TRUE;
    [self updateCreateButton];
}

- (void)downloadImageFromURL:(NSURL *)url{
    NSError* error;
    UIImage* image = nil;
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSURLResponse* response;
    NSData* imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    image = [UIImage imageWithData:imageData];
    self.downloadImageButton.alpha = 0.3;
    self.downloadImageButton.enabled = FALSE;
    [self performSelectorOnMainThread:@selector(downloadImageFinished:) withObject:image waitUntilDone:NO];
}

- (void)downloadImageFinished:(UIImage *)image
{
    [self.activityIndicator stopAnimating];
    self.downloadImageButton.alpha = 1.f;
    self.downloadImageButton.enabled = TRUE;
    self.imageDownloadInProgress = FALSE;
    if (image) {
        self.imageView.image = image;
    }else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"connection fail"
                                                            message:@"sry we were not able to downlaod the image"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        self.imageUrlField.textColor = [UIColor redColor];
    }
    [self updateCreateButton];
}



- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   
    return advancedSettings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingsCell"];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        [cell autorelease];
    }
    NSDictionary* setting = [advancedSettings objectAtIndex:indexPath.row];
    cell.textLabel.text = [setting objectForKey:@"name"];
    cell.detailTextLabel.text = [setting objectForKey:@"data"];
    return cell;
}

@end
