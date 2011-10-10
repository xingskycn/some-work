//
//  JBBrushManager.h
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBBrush;

@interface JBBrushManager : NSObject

+ (NSMutableArray*)getAllBrushes;
+ (bool)saveNewBrush:(NSDictionary*)brushDict thumbnail:(UIImage*)thumbnail;
+ (JBBrush*)getBrushForID:(NSString*)brushID;

@end
