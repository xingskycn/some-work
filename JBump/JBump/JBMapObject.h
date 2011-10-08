//
//  JBMapObject.h
//  Playground
//
//  Created by Sebastian Pretscher on 08.10.11.
//

#import <Foundation/Foundation.h>

@interface JBMapObject : NSObject {
    //Images from Server
    NSString *thumbnailUrl;
    NSString *backgroundUrl;
    NSString *arenaUrl;
    NSString *overlayUrl;
    
    //Local Images
    NSString *filePath;
    NSString *thumbnailFile;
    NSString *backgroundFile;
    NSString *arenaFile;
    NSString *overlayFile;
    
    /*Array which holds all Curves in Dictionarrys 
     (Each Dictionary has a key for a Identifier and 
     a key for an array containing the curve Points 
     represented in NSStrings)*/
    NSArray *allCurves;
    
    /*Array which holds all Curves in Dictionarrys 
     (Each Dictionary has a key for a Identifier, 
     a key for an Image and keys for their behavior*/
    NSArray *entities;

}
@end
