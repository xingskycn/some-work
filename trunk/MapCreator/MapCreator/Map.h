//
//  Map.h
//  MapCreator
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Map : NSObject


//Images from Server
@property (nonatomic, retain) NSString *thumbnailUrl;
@property (nonatomic, retain) NSString *backgroundUrl;
@property (nonatomic, retain) NSString *arenaUrl;
@property (nonatomic, retain) NSString *overlayUrl;

//Local Images
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSString *thumbnailFile;
@property (nonatomic, retain) NSString *backgroundFile;
@property (nonatomic, retain) NSString *arenaFile;
@property (nonatomic, retain) NSString *overlayFile;

/*Array which holds all Curves in Dictionarrys 
 (Each Dictionary has a key for a Identifier and 
 a key for an array containing the curve Points 
 represented in NSStrings)*/
@property (nonatomic, retain) NSArray *allCurves;

/*Array which holds all Curves in Dictionarrys 
 (Each Dictionary has a key for a Identifier, 
 a key for an Image and keys for their behavior*/
@property (nonatomic, retain) NSArray *entities;
@end
