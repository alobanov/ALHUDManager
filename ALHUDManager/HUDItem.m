//
//  HUDItem.m
//  MBProgressHUDManager
//
//  Created by Алексей Лобанов on 11.08.13.
//  Copyright (c) 2013 Алексей Лобанов. All rights reserved.
//

#import "HUDItem.h"

@implementation HUDItem

- (id)initWithTitle:(NSString *) title andDetail:(NSString *) detail {
	self = [super init];
    if (self) {
		self.title = title;
		self.detail = detail;
		
		// optional
		self.imageType = HUDImage_None;
		self.hideDelay = 2.0;
		self.dimBackground = YES;
		self.mode = ProgressHUDModeText;
    }
    
    return self;
}

+ (HUDItem *) itemWithTitle:(NSString *) title andDetail:(NSString *) detail {
    HUDItem *item = [[HUDItem alloc] initWithTitle:title andDetail:detail];
    return item;
}

@end
