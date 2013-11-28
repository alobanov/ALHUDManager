//
//  ViewController.m
//  HUDManager
//
//  Created by Lobanov Aleksey on 12.08.13.
//  Copyright (c) 2013 Lobanov Aleksey. All rights reserved.
//

#import "ViewController.h"
#import "ALHUDManager.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView *hudview;
@property (nonatomic, strong, readonly) UIControl *overlayView;

@end

@implementation ViewController

@synthesize overlayView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib
}

- (UIControl *)overlayView {
    if(!overlayView) {
        overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.backgroundColor = [UIColor blackColor];
    }
    return overlayView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) show:(id)sender {
	HUDItem *item = [HUDItem itemWithTitle:@"Title" andDetail:@"Test"];
	item.hideDelay = 2.0;
	item.imageType = HUDImage_SadFace;
    item.dimBackground = YES;
    item.mode = ProgressHUDModeText;
	[ALHUDManager showHUD:item];
    
//    UIView *t = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 400.0)];
//    [t setBackgroundColor:[UIColor yellowColor]];
//
//
//    if(!self.overlayView.superview){
//        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
//        
//        for (UIWindow *window in frontToBackWindows)
//            if (window.windowLevel == UIWindowLevelNormal) {
//                [window addSubview:self.overlayView];
//                break;
//            }
//    }
//    
//    [self.overlayView addSubview:t];

}

@end
