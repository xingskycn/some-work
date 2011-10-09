//
//  JBEntityManager.h
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBEntityManager : NSObject

+ (NSMutableArray*)getAllEnteties;
+ (bool)saveNewEntity:(NSMutableDictionary*)entityDict entityImage:(UIImage*)image;


@end
