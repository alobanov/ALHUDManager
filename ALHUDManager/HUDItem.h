//
//  HUDItem.h
//  MBProgressHUDManager
//
//  Created by Алексей Лобанов on 11.08.13.
//  Copyright (c) 2013 Алексей Лобанов. All rights reserved.
//

typedef enum {
	/** Progress is shown using an UIActivityIndicatorView. This is the default. */
	ProgressHUDModeIndeterminate,
	/** Progress is shown using a round, pie-chart like, progress view. */
	ProgressHUDModeDeterminate,
	/** Progress is shown using a horizontal progress bar */
	ProgressHUDModeDeterminateHorizontalBar,
	/** Progress is shown using a ring-shaped progress view. */
	ProgressHUDModeAnnularDeterminate,
	/** Shows a custom view */
	ProgressHUDModeCustomView,
	/** Shows only labels */
	ProgressHUDModeText
} ProgressHUDMode;

typedef enum {
	HUDImage_None = 999,
	HUDImage_Success = 0,
	HUDImage_SadFace = 1,
    HUDImage_Star = 2,
    HUDImage_Heart = 3
} HUDImageType;

typedef enum {
    HUDCustomImage_None = 999
} HUDCustomImage;

#import <Foundation/Foundation.h>

@interface HUDItem : NSObject

- (id)initWithTitle:(NSString *) title andDetail:(NSString *) detail;
+ (HUDItem *) itemWithTitle:(NSString *) title andDetail:(NSString *) detail;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *detail;

// optional
@property (assign, nonatomic) HUDImageType imageType;
@property (assign, nonatomic) float hideDelay;
@property (assign, nonatomic) BOOL dimBackground;
@property (assign, nonatomic) ProgressHUDMode mode;
@property (strong, nonatomic) NSString *hudCustomImagePath;

@end
