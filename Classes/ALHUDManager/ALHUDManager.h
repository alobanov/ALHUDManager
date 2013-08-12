//
//  HUDManager.h
//  evening
//
//  Created by Алексей Лобанов on 04.11.12.
//  Copyright (c) 2012 avvakumov@east-media.ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#import "HUDItem.h"

#define HUDManager_hideHud @"notification: hideHud"
#define HUDManager_showHUDItem @"HUDManager_showHUDItem"

#define HUDManager_bundleName @"ALHUDIconsResourse"

@interface ALHUDManager : NSObject <MBProgressHUDDelegate>

+ (ALHUDManager *) defaultManager;

- (void) updateHudView:(UIView *)hudView;

+ (void) showHUD:(HUDItem*) item;
+ (void) hideHUD;


@end
