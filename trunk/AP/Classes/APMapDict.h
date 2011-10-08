//
//  APMapDict.h
//  AP
//
//  Created by Ziehn Nils on 6/22/11.
//  Copyright 2011 ziehn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface APMapDict : NSObject {
	
}
+ (APMapDict *)single;

- (BOOL)isMapLoadedForID:(NSString *)skinID;
- (void)loadMapForID:(NSString *)skinID;
- (void)newMapLoaded:(NSMutableDictionary *)dict;
- (NSArray *)listMaps;
- (UIImage *)imageForMapID:(NSString *)skinID;
- (NSString *)nameForMapID:(NSString *)skinID;

- (void)getMapCharacteristicsForMapID:(NSString *)mapID toField:(char**)mapCharacteristics;
- (void)saveMapCharacteristics:(char*)mc legth:(int)length LoadedForID:(NSString *)mapID;
- (NSDictionary *)getMapInformationForMapID:(NSString *)mapID;
@end
