//
//  JBMap.h
//  JBUMPB0
//
//  Created by Nils Ziehn on 10/6/11.
//  Copyright (c) 2011 TU Munich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JBMap : NSObject


+ (JBMap*)mapForID;

// Category for accessing the map
@property int categoryNR;
@property (nonatomic, strong) NSString* categoryID;

// MapID, for directly accessing the map
@property (nonatomic, strong) NSString* mapID;

// Provide further information about the map
@property (nonatomic, strong) NSString* further;

// width and height of the map in fields count
@property int width;
@property int height;

// the field definitions
@property char* fields;
@property (nonatomic, strong) NSString* fieldsURL;
@property (nonatomic, strong) NSString* fieldsLocation;

//
// the background image information
//  if the background is not loaded onto device yet, you can download it from the \! backroundURL
//  usually the background moves slower then the active scene image
//
@property (nonatomic, strong) UIImage* background;
@property (nonatomic, strong) NSString* backgroundURL;
@property (nonatomic, strong) NSString* backgroundLocation;

//
// the active image of the scene
//  this image represents the layer the player 'moves' on
//

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) NSString* imageURL;
@property (nonatomic, strong) NSString* imageLocation;

//
// the overlay represents a layer ABOVE the player, so you can hide behind it.
//

@property (nonatomic, strong) UIImage* overlay;
@property (nonatomic, strong) NSString* overlayURL;
@property (nonatomic, strong) NSString* overlayLocation;

//
// the map thumbnail gets displayed in mapstores
//

@property (nonatomic, strong) UIImage* thumbnail;
@property (nonatomic, strong) NSString* thumbnailURL;
@property (nonatomic, strong) NSString* thumbnailLocation;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
