//
//  JBSkinManager.h
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBSkin;

@interface JBSkinManager : NSObject

+ (NSMutableArray*)getAllSkins;
+ (bool)saveNewSkin:(NSMutableDictionary*)skinDict withThumbnail:(UIImage*)thumbnail andSkin:(UIImage*)skin;
+ (JBSkin*)getSkinWithID:(NSString*)skinID;
+ (NSArray*)getAllSkinIDs;
+ (void)saveRessourceSkins;
@end
