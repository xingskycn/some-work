//
//  JBBrush.h
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JBMapItem.h"

@interface JBBrush : JBMapItem

@property (assign) float red;
@property (assign) float green;
@property (assign) float blue;
@property (assign) float alpha;

- (id)initWithBrushDict:(NSDictionary*)brushDict;

@end
