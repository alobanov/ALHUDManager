//
//  HUDManager.m
//  evening
//
//  Created by Aleksey Lobanov on 04.11.12.
//  Copyright (c) 2012 avvakumov@east-media.ru. All rights reserved.
//

#import "ALHUDManager.h"

@interface ALHUDManager ()

@property (nonatomic, strong, readonly) UIControl *overlayView;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) UIView *hudView;
@property (strong, nonatomic) NSArray *imageList;

@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;
@property (nonatomic, assign) UIOffset offsetFromCenter;
@property (assign, nonatomic) BOOL isCustomView;

@end

@implementation ALHUDManager

@synthesize overlayView;

- (id) init {
    self = [super init];
    if (self) {
        self.hudView = nil;
        self.isCustomView = NO;
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

#pragma mark - Public instance methods
- (void) updateHudView:(UIView *)hudView {
    self.isCustomView = (hudView == nil)?NO:YES;
    self.hudView = hudView;
}

- (void) showAlwaysOnTop {
    self.isCustomView = NO;
    self.hudView = nil;
}

- (void) setProgress:(float) value {
    if (!self.HUD) return;
    
    [self.HUD setProgress:value];
}

- (void) setDetailText:(NSString *) text {
    if (!self.HUD) return;
    [self.HUD setDetailsLabelText:text];
}

#pragma mark - Public static methods
+ (void) showHUD:(HUDItem*) item {
    [ALHUDManager defaultManager];
    
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

#pragma mark - Notifications register
- (void) addNotificationObserver {
	// base alhudmanager notification
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showHUDItem:) name:HUDManager_showHUDItem object: nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(hideHud:) name:HUDManager_hideHud object: nil];
    
    // position of hud notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionHUD:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

#pragma mark - Create hud
- (void) createHud {
	if (_HUD != nil) return;
    
    if (!_isCustomView)
        [self createModalView];
	
	self.HUD = [[MBProgressHUD alloc] initWithView: _hudView];
	[self.hudView addSubview:_HUD];
	_HUD.dimBackground = YES;
	_HUD.delegate = self;
    [_hudView setHidden:NO];
    [_HUD show:YES];
}

- (void) createModalView {
    if (!self.hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectZero];
        _hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        [_hudView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    }
    
    if(!self.overlayView.superview){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
        }
    }
    
    if (_hudView)
        [self.overlayView addSubview:_hudView];
    [self positionHUD:nil];
}

- (UIControl *)overlayView {
    if(!overlayView) {
        overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.backgroundColor = [UIColor clearColor];
    }
    return overlayView;
}

#pragma mark - Notification callback
- (void) hideHud:(NSNotification*) notify {
    [_hudView setHidden:YES];
	[_HUD setHidden:YES];
    
    [self hudWasHidden:_HUD];
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
	
    if (item.hudCustomImagePath) {
        [_HUD setMode:MBProgressHUDModeCustomView];
	 	_HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:item.hudCustomImagePath]];
    } else{
        if (item.imageType == HUDImage_None) {
            [_HUD setMode:(int)item.mode];
        } else {
            [_HUD setMode:MBProgressHUDModeCustomView];
            
            NSString *bundleImageName = [NSString stringWithFormat: @"%@.bundle/%@", HUDManager_bundleName, [_imageList objectAtIndex:item.imageType]];
            NSString *path = [[NSBundle mainBundle] pathForResource:bundleImageName ofType:nil];
            _HUD.customView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:path]];
        }
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
    if (!hud) return;
    
	// Remove HUD from screen when the HUD was hidded
	[_HUD removeFromSuperview];
	self.HUD = nil;
    
    [_hudView removeFromSuperview];
    _hudView = nil;
    
    [overlayView removeFromSuperview];
    overlayView = nil;
}

#pragma mark - Notify position of hud
- (void)positionHUD:(NSNotification*)notification {
    if (_isCustomView) return;
    CGFloat keyboardHeight;
    double animationDuration;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            if(UIInterfaceOrientationIsPortrait(orientation))
                keyboardHeight = keyboardFrame.size.height;
            else
                keyboardHeight = keyboardFrame.size.width;
        } else
            keyboardHeight = 0;
    } else {
        keyboardHeight = self.visibleKeyboardHeight;
    }
    
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
        
        temp = statusBarFrame.size.width;
        statusBarFrame.size.width = statusBarFrame.size.height;
        statusBarFrame.size.height = temp;
    }
    
    CGFloat activeHeight = orientationFrame.size.height;
    
    if(keyboardHeight > 0)
        activeHeight += statusBarFrame.size.height*2;
    
    activeHeight -= keyboardHeight;
    CGFloat posY = floor(activeHeight*0.5);
    CGFloat posX = orientationFrame.size.width/2;
    
    CGPoint newCenter;
    CGFloat rotateAngle;
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI;
            newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = -M_PI/2.0f;
            newCenter = CGPointMake(posY, posX);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI/2.0f;
            newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
            break;
        default: // as UIInterfaceOrientationPortrait
            rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
            break;
    }
    
    if(notification) {
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [self moveToPoint:newCenter rotateAngle:rotateAngle];
                         } completion:NULL];
    }
    
    else {
        [self moveToPoint:newCenter rotateAngle:rotateAngle];
    }
    
}

- (void)moveToPoint:(CGPoint)newCenter rotateAngle:(CGFloat)angle {
    self.hudView.transform = CGAffineTransformMakeRotation(angle);
    float largeSide = MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    [self.hudView setFrame:CGRectMake(_hudView.frame.origin.x, _hudView.frame.origin.y, largeSide, largeSide)];
    self.hudView.center = CGPointMake(newCenter.x + self.offsetFromCenter.horizontal, newCenter.y + self.offsetFromCenter.vertical);
}

@end
