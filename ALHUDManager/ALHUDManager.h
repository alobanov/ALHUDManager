//
//  HUDManager.h
//  evening
//
//  Created by Aleksey Lobanov on 04.11.12.
//  Copyright (c) 2012 avvakumov@east-media.ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#import "HUDItem.h"

#define HUDManager_bundleName @"ALHUDIconsResourse"

#define HUDManager_hideHud @"notification: hideHud"
#define HUDManager_showHUDItem @"notification: showHud"

@interface ALHUDManager : NSObject <MBProgressHUDDelegate>

#pragma mark - public static methods
+ (void) showHUD:(HUDItem*) item;
+ (void) hideHUD;

#pragma mark - public instance methods
- (void) setProgress:(float) value;
- (void) setDetailText:(NSString *) text;
- (void) updateHudView:(UIView *)hudView;
- (void) showAlwaysOnTop;

#pragma mark - instance
+ (ALHUDManager *) defaultManager;

@end
