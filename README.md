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

## Set custom image

```objective-c
HUDItem *item = [HUDItem itemWithTitle:@"Nice heart" andDetail:@"Smile bitch!"];
item.hudCustomImagePath = @"hudTest.png";
item.hideDelay = 7.0;
[ALHUDManager showHUD:item];
```