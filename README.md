ALHUDManager
============

Hud manager based on MBProgressHUD

## Usage

```objective-c
// create hud item
HUDItem *item = [HUDItem itemWithTitle:@"Title" andDetail:@"Test"];
item.hideDelay = 2.0;
item.imageType = HUDImage_SadFace;
item.dimBackground = YES;
item.mode = ProgressHUDModeText;

// just show
[ALHUDManager showHUD:item];

// for manually hide
[ALHUDManager hideHud];
```