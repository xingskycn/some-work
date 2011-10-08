//
//  JBMap.m
//  JBUMPB0
//
//  Created by Nils Ziehn on 10/6/11.
//  Copyright (c) 2011 TU Munich. All rights reserved.
//

#import "JBMap.h"

@implementation JBMap

@synthesize categoryNR,categoryID;
@synthesize mapID;
@synthesize further;
@synthesize width,height;
@synthesize fields,fieldsURL,fieldsLocation;
@synthesize background,backgroundURL,backgroundLocation;
@synthesize image,imageURL,imageLocation;
@synthesize overlay,overlayURL,overlayLocation;
@synthesize thumbnail,thumbnailURL,thumbnailLocation;

+ (JBMap *)mapForID
{
    return nil;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self){
        self.categoryNR = [[dict objectForKey:@"categoryNR"] intValue];
        self.categoryID = [dict objectForKey:@"categoryID"];
        self.mapID = [dict objectForKey:@"mapID"];
        self.further = [dict objectForKey:@"further"];
        self.width = [[dict objectForKey:@"width"] intValue];
        self.height = [[dict objectForKey:@"height"] intValue];
        
        self.fieldsURL = [dict objectForKey:@"fieldsURL"];
        self.fieldsLocation = [dict objectForKey:@"fieldsLocation"];
        self.background = [dict objectForKey:@"background"];
        self.backgroundURL = [dict objectForKey:@"backgroundURL"];
        self.backgroundLocation = [dict objectForKey:@"backgroundLocation"];
        self.image = [dict objectForKey:@"image"];
        self.imageURL = [dict objectForKey:@"imageURL"];
        self.imageLocation = [dict objectForKey:@"imageLocation"];
        self.overlay = [dict objectForKey:@"overlay"];
        self.overlayURL = [dict objectForKey:@"overlayURL"];
        self.overlayLocation = [dict objectForKey:@"overlayLocation"];
        self.thumbnail = [dict objectForKey:@"thumbnail"];
        self.thumbnailURL = [dict objectForKey:@"thumbnailURL"];
        self.thumbnailLocation = [dict objectForKey:@"thumbnailLocation"];
        
    }
    return self;
}















@end
