//
//  JBSkin.m
//  JBUMPB0
//
//  Created by Nils Ziehn on 10/6/11.
//  Copyright (c) 2011 TU Munich. All rights reserved.
//

#import "JBSkin.h"

@implementation JBSkin

@synthesize skinID;
@synthesize name;
@synthesize further;
@synthesize image,imageURL,imageLocation;


- (id)initWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    if (self) {
        self.skinID = [dict objectForKey:@"skinID"];
        self.name = [dict objectForKey:@"name"];
        self.further = [dict objectForKey:@"further"];
        self.image = [dict objectForKey:@"image"];
        self.imageURL = [dict objectForKey:@"imageURL"];
        self.imageLocation = [dict objectForKey:@"imageLocation"];
    }
    return self;
}



@end
