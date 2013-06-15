//
//  DownloadManageController.h
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "DownloadItemCell.h"

enum {
    SELECT_ALL_ITEM,
    SELECT_COMPLETE_ITEM,
    SELECT_DOWNLOADING_ITEM,
    SELECT_STARRED_ITEM
};

@class ItemActionController;
@class ViewDecompressItemController;
@class GADBannerView;

@interface DownloadManageController : PPTableViewController <DownloadItemCellDelegate>

@property (nonatomic, retain) ItemActionController *actionController;
@property (nonatomic, retain) ViewDecompressItemController *viewDecompressItemController;
@property (nonatomic, assign) int currentSelection;
//@property (nonatomic, retain) DownloadItem* lastPlayingItem;
@property (retain, nonatomic) IBOutlet UIButton *filterAllButton;
@property (retain, nonatomic) IBOutlet UIButton *filterCompleteButton;
@property (retain, nonatomic) IBOutlet UIButton *filterDownloadingButton;
@property (retain, nonatomic) IBOutlet UIButton *filterStarredButton;
@property (retain, nonatomic) IBOutlet UIImageView *filterBackgroundView;
@property (retain, nonatomic) UIImageView *underlineView;
@property (retain, nonatomic) UIButton *lastSelectedButton;
@property (nonatomic, retain) GADBannerView* bannerView;

- (IBAction)clickFilterComplete:(id)sender;
- (IBAction)clickFilterDownloading:(id)sender;
- (IBAction)clickFilterStarred:(id)sender;

@end
