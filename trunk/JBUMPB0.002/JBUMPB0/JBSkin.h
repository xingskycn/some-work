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
@property (nonatomic, strong) NSString* skinID;

//
//  the name to display in the store
//
@property (nonatomic, strong) NSString* name;

//
// further information about the skin, displayed in the store
//
@property (nonatomic, strong) NSString* further;

//
//  displayed image for the skin
//

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* imageURL;
@property (strong, nonatomic) NSString* imageLocation;


- (id)initWithDictionary:(NSDictionary *)dict;

@end
