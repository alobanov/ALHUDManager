//
//  HUDManager.m
//  evening
//
//  Created by Алексей Лобанов on 04.11.12.
//  Copyright (c) 2012 avvakumov@east-media.ru. All rights reserved.
//

#import "ALHUDManager.h"

@interface ALHUDManager ()

@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) UIView *hudView;
@property (strong, nonatomic) NSArray *imageList;

@end

@implementation ALHUDManager

- (id) init {
    self = [super init];
    if (self) {
        self.hudView = nil;
        [_hudView setHidden:YES];
		self.imageList = [NSArray arrayWithObjects:@"37x-Checkmark.png", @"hud_sadFace.png", @"star.png", @"heart.png", nil];
		[self addNotificationObserver];
    }
    return self;
}

+ (ALHUDManager *) defaultManager {
    static ALHUDManager *instance = nil;
    if (instance == nil) {
        instance = [[ALHUDManager alloc] init];
    }
    return instance;
}

#pragma mark - Public static methods
+ (void) showHUD:(HUDItem*) item {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	NSDictionary *hudItemWrapper = [NSDictionary dictionaryWithObject:item forKey:@"HUDItem"];
	[nc postNotificationName:HUDManager_showHUDItem
						  object:nil
						userInfo:hudItemWrapper];
}

+ (void) hideHUD {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:HUDManager_hideHud
					  object:nil];
}

- (void) updateHudView:(UIView *)hudView {
    self.hudView = hudView;
    [self.hudView setHidden:YES];
}

#pragma mark - Notifications register
- (void) addNotificationObserver {
	// add notification observer
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showHUDItem:) name:HUDManager_showHUDItem object: nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(hideHud:) name:HUDManager_hideHud object: nil];

}

#pragma mark - Create hud
- (void) createHud {
	if (_HUD != nil) return;
	
	self.HUD = [[MBProgressHUD alloc] initWithView: _hudView];
	[_hudView addSubview:_HUD];
	_HUD.dimBackground = YES;
	_HUD.delegate = self;
    [_hudView setHidden:NO];
    [_HUD show:YES];
}

#pragma mark - Notification callback
-(void) hideHud:(NSNotification*) notify {
    [_hudView setHidden:YES];
	[_HUD setHidden:YES];
}

- (void) showHUDItem:(NSNotification *) notify {
	NSDictionary *info = [notify userInfo];
	HUDItem *item = [info objectForKey:@"HUDItem"];
	if (!item) return;
	
	if (_HUD == nil) {
		[self createHud];
	}
    
    [_hudView setHidden:NO];
	[_HUD setHidden:NO];
	
	[_HUD setLabelText:item.title];
	[_HUD setDetailsLabelText:item.detail];
    [_HUD setDimBackground:item.dimBackground];
	
	if (item.imageType == HUDImage_None) {
		[_HUD setMode:(int)item.mode];
	} else {
		[_HUD setMode:MBProgressHUDModeCustomView];
        
        NSString *bundleImageName = [NSString stringWithFormat: @"%@.bundle/%@", HUDManager_bundleName, [_imageList objectAtIndex:item.imageType]];
        NSString *path = [[NSBundle mainBundle] pathForResource:bundleImageName ofType:nil];
		_HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:path]];
	}
	
	if (item.mode != MBProgressHUDModeDeterminate &&
		item.mode != MBProgressHUDModeAnnularDeterminate &&
		item.mode != MBProgressHUDModeDeterminateHorizontalBar &&
		item.mode != MBProgressHUDModeIndeterminate) {
		[_HUD hide:YES afterDelay:item.hideDelay];
	}
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void) hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[_HUD removeFromSuperview];
	self.HUD = nil;
    [_hudView setHidden:YES];
}


@end
