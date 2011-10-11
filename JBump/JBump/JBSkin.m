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
@synthesize thumbnail;
@synthesize thumbnailURL;
@synthesize thumbnailLocation;


- (id)initWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    if (self) {
        self.skinID = [dict objectForKey:jbID];
        self.name = [dict objectForKey:jbNAME];
        self.further = [dict objectForKey:jbFURTHER];
        self.image = [dict objectForKey:jbIMAGE];
        self.imageURL = [dict objectForKey:jbIMAGEURL];
        self.imageLocation = [dict objectForKey:jbIMAGELOCATION];
        self.thumbnail = [dict objectForKey:jbTHUMBNAIL];
        self.thumbnailURL = [dict objectForKey:jbTHUMBNAILURL];
        self.thumbnailLocation = [dict objectForKey:jbTHUMBNAILLOCATION];
    }
    return self;
}



@end
