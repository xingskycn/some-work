//
//  AppDelegate.m
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "JBAppDelegate.h"
#import "GameConfig.h"
#import "JBMenuLayer.h"
#import "JBRootViewController.h"
#import "JBMenuViewController.h"
#import "JBSkinManager.h"

@implementation JBAppDelegate

@synthesize window = _window;
@synthesize menuStoryboard;
@synthesize viewController;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
	//	CC_ENABLE_DEFAULT_GL_STATES();
	//	CCDirector *director = [CCDirector sharedDirector];
	//	CGSize size = [director winSize];
	//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	//	sprite.position = ccp(size.width/2, size.height/2);
	//	sprite.rotation = -90;
	//	[sprite visit];
	//	[[director openGLView] swapBuffers];
	//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[JBRootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController.view addSubview:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [JBMenuLayer scene]];
    
    self.menuStoryboard = [UIStoryboard storyboardWithName:@"JBMenuStoryboard" bundle:nil];
    
    JBMenuViewController *menuController = [self.menuStoryboard instantiateInitialViewController];
    
    self.window.frame = CGRectMake(0, 0, 480, 320);
    //self.viewController.view.frame = CGRectMake(0, 0, 480, 320);
    [viewController addChildViewController:menuController];
    UIView *animationsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
    
    menuController.view.frame = CGRectMake(0, 0, 480, 320);
    [animationsView addSubview:menuController.view];
    
    [viewController.view addSubview:animationsView];
    
    [self saveRessourceImages];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)saveRessourceImages {
    NSMutableDictionary *skin1 = [NSMutableDictionary dictionary];
    UIImage *skin = [UIImage imageNamed:@"bird_1.png"];
    UIImage *thumb = [UIImage imageNamed:@"bird_1.png"];
    
    [skin1 setValue:@"bird1" forKey:@"skinID"];
    [skin1 setValue:@"bird1" forKey:@"name"];
    [skin1 setValue:thumb forKey:@"thumbnail"];
    [skin1 setValue:skin forKey:@"image"];
    [skin1 setValue:@"LocalImage_Bird1" forKey:@"further"];
    
    [JBSkinManager saveNewSkin:skin1 withThumbnail:thumb andSkin:skin];
    
    skin = [UIImage imageNamed:@"bull_1.png"];
    thumb = [UIImage imageNamed:@"bull_1.png"];
    
    [skin1 setValue:@"bull1" forKey:@"skinID"];
    [skin1 setValue:@"bull1" forKey:@"name"];
    [skin1 setValue:thumb forKey:@"thumbnail"];
    [skin1 setValue:skin forKey:@"image"];
    [skin1 setValue:@"LocalImage_Bull1" forKey:@"further"];
    
    [JBSkinManager saveNewSkin:skin1 withThumbnail:thumb andSkin:skin];

    skin = [UIImage imageNamed:@"bunny_1.png"];
    thumb = [UIImage imageNamed:@"bunny_1.png"];
    
    [skin1 setValue:@"bunny1" forKey:@"skinID"];
    [skin1 setValue:@"bunny1" forKey:@"name"];
    [skin1 setValue:thumb forKey:@"thumbnail"];
    [skin1 setValue:skin forKey:@"image"];
    [skin1 setValue:@"LocalImage:bunny1" forKey:@"further"];
    
    [JBSkinManager saveNewSkin:skin1 withThumbnail:thumb andSkin:skin];
    
    skin = [UIImage imageNamed:@"bunny_2.png"];
    thumb = [UIImage imageNamed:@"bunny_2.png"];
    
    [skin1 setValue:@"bunny2" forKey:@"skinID"];
    [skin1 setValue:@"bunny2" forKey:@"name"];
    [skin1 setValue:thumb forKey:@"thumbnail"];
    [skin1 setValue:skin forKey:@"image"];
    [skin1 setValue:@"LocalImage_bunny2" forKey:@"further"];
    
    [JBSkinManager saveNewSkin:skin1 withThumbnail:thumb andSkin:skin];
    
    skin = [UIImage imageNamed:@"scel_2.png"];
    thumb = [UIImage imageNamed:@"scel_2.png"];
    
    [skin1 setValue:@"scel2" forKey:@"skinID"];
    [skin1 setValue:@"scel2" forKey:@"name"];
    [skin1 setValue:thumb forKey:@"thumbnail"];
    [skin1 setValue:skin forKey:@"image"];
    [skin1 setValue:@"LocalImage_scel2" forKey:@"further"];
    
    [JBSkinManager saveNewSkin:skin1 withThumbnail:thumb andSkin:skin];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
