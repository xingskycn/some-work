//
//  JBBrush.h
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBBrush : NSObject

@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* brushID;
@property (nonatomic, retain) NSString* brushName;
@property (nonatomic, retain) NSString* further;

@property (nonatomic, retain) UIImage* thumbnail;
@property (nonatomic, retain) NSString* thumbnailLocation;
@property (nonatomic, retain) NSString* thumbnailURL;

@property (assign) float friction;
@property (assign) float restitution;

@property (assign) float red;
@property (assign) float green;
@property (assign) float blue;
@property (assign) float alpha;

- (id)initWithBrushDict:(NSDictionary*)brushDict;

@end
