//
//  JBSkin.h
//  JBUMPB0
//
//  Created by Nils Ziehn on 10/6/11.
//  Copyright (c) 2011 TU Munich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBSkin : NSObject

//
//  identifier
//
@property (nonatomic, retain) NSString* skinID;

//
//  the name to display in the store
//
@property (nonatomic, retain) NSString* name;

//
// further information about the skin, displayed in the store
//
@property (nonatomic, retain) NSString* further;

//
//  displayed image for the skin
//

@property (retain, nonatomic) UIImage* image;
@property (retain, nonatomic) NSString* imageURL;
@property (retain, nonatomic) NSString* imageLocation;
@property (retain, nonatomic) UIImage* thumbnail;
@property (retain, nonatomic) NSString* thumbnailURL;
@property (retain, nonatomic) NSString* thumbnailLocation;


- (id)initWithDictionary:(NSDictionary *)dict;

@end
