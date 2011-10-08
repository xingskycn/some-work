//
//  Map.h
//  Frapp
//
//  Created by Nils Ziehn on 10/7/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Map : NSObject

@property int categoryID;
@property (nonatomic, retain) NSString* mapID;
@property int width;
@property int height;
@property char* mapFieldDef;

@end
