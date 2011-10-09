//
//  JBSkinManager.h
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBSkinManager : NSObject

+ (NSArray*)getAllSkins;
+ (bool)saveNewSkin:(NSMutableDictionary*)skinDict withThumbnail:(UIImage*)thumbnail andSkin:(UIImage*)skin;

@end
