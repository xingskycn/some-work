//
//  APSkin.m
//  AP
//
//  Created by Nils Ziehn on 18.06.11.
//  Copyright 2011 ziehn. All rights reserved.
//

#import "APSkin.h"


@implementation APSkin

@synthesize skinImageURL;
@synthesize skinID;
@synthesize skinName;


- (id)initWithDict:(NSMutableDictionary *)dict;
{
	self.skinImageURL = [dict objectForKey:@"skin_image_dict"];
	self.skinID = [dict objectForKey:@"skin_ID"];
	self.skinName = [dict objectForKey:@"skin_name"];
}

- (BOOL)imageLoaded
{
	return NO;
}

- (void)loadImageWithCaller:(id)caller andCallback:(SEL)callback
{
	
}

@end
