//
//  JBMapCreatorViewController.m
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBMapCreatorViewController.h"

#import "JBEntity.h"
#import "JBEntityManager.h"

#import "JBMap.h"
#import "JBMapManager.h"


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
    
}



@end
