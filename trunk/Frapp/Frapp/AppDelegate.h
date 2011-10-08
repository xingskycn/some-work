//
//  AppDelegate.h
//  Frapp
//
//  Created by Nils Ziehn on 10/7/11.
//  Copyright ziehn.org 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UISlider* slider;

@end
