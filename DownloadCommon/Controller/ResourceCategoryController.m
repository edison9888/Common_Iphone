//
//  ResourceCategoryController.m
//  Download
//
//  Created by  on 11-11-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ResourceCategoryController.h"
#import "TopSite.h"
#import "TopSiteManager.h"
#import "ResourceCell.h"
#import "DownloadWebViewController.h"
#import "DownloadResource.h"

@implementation ResourceCategoryController

@synthesize requestType;
@synthesize latestList;
@synthesize topList;
@synthesize hotList;
@synthesize starredList;
@synthesize topButton;
@synthesize hotButton;
@synthesize newButton;
@synthesize starredButton;
@synthesize resourceBackgroundView;
@synthesize lastSelectedButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.requestType = SITE_REQUEST_TYPE_TOP;
        self.topList = [[[NSMutableArray alloc] init] autorelease];
        self.latestList = [[[NSMutableArray alloc] init] autorelease];
        self.hotList = [[[NSMutableArray alloc] init] autorelease];
        self.starredList = [[[NSMutableArray alloc] init] autorelease];


    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [starredList release];
    [hotList release];
    [topList release];
    [latestList release];
    [topButton release];
    [hotButton release];
    [newButton release];
    [starredButton release];
    [resourceBackgroundView release];
    [lastSelectedButton release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)updateDataListByType:(NSArray*)newDataList requestType:(int)requestTypeValue
{
    switch (requestTypeValue) {
        case SITE_REQUEST_TYPE_TOP:
        {
            [self.topList removeAllObjects];
            [self.topList addObjectsFromArray:newDataList];
        }
            break;

        case SITE_REQUEST_TYPE_HOT:
        {
            [self.hotList removeAllObjects];
            [self.hotList addObjectsFromArray:newDataList];
        }
            break;
            
        case SITE_REQUEST_TYPE_NEW:
        {
            [self.latestList removeAllObjects];
            [self.latestList addObjectsFromArray:newDataList];
        }
            break;
            
        default:
            break;
    }
}

- (void)reloadData
{
    switch (self.requestType) {
        case SITE_REQUEST_TYPE_TOP:
        {
            self.dataList = self.topList;
        }
            break;
            
        case SITE_REQUEST_TYPE_HOT:
        {
            self.dataList = self.hotList;
        }
            break;
            
        case SITE_REQUEST_TYPE_NEW:
        {
            self.dataList = self.latestList;
        }
            break;
        
        case SITE_REQUEST_TYPE_NONE:
        {
            self.dataList = self.starredList;
        }
            break;            
        
        default:
            break;
    }

    [self.dataTableView reloadData];
}

- (void)findAllSitesFinish:(int)resultCode requestType:(int)requestTypeValue newDataList:(NSArray*)newDataList
{
    [self hideActivity];
    if (resultCode == 0){
        [self updateDataListByType:newDataList requestType:requestTypeValue];
        if (requestType == requestTypeValue){
            [self reloadData];
        }
    }
    else{
        [self popupUnhappyMessage:NSLS(@"kFailLoadSite") title:@""];
    }
    
    [self dataSourceDidFinishLoadingNewData];

}

- (void)loadSiteFromServer
{    
    if (self.requestType == SITE_REQUEST_TYPE_NONE)
        return;
    
    [self showActivityWithText:NSLS(@"kLoadingData")];
    [[ResourceService defaultService] findAllSites:self requestType:self.requestType];
}

- (void)viewDidLoad
{
    [self setDownloadNavigationTitle:NSLS(@"kSecondViewTitle")];
    
    [self.resourceBackgroundView setImage:DOWNLOAD_FILTER_BG_IMAGE];

    
    [self.topButton setTitle:NSLS(@"kTopButtonTitle") forState:UIControlStateNormal];
    [self.topButton setImage:RESOURCE_TOP_BUTTON_IMAGE forState:UIControlStateNormal];
    [self.topButton setImage:RESOURCE_TOP_BUTTON_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.hotButton setTitle:NSLS(@"kHotButtonTitle") forState:UIControlStateNormal];
    [self.hotButton setImage:RESOURCE_HOT_BUTTON_IMAGE forState:UIControlStateNormal];
    [self.hotButton setImage:RESOURCE_HOT_BUTTON_PRESS_IMAGE forState:UIControlStateSelected];
    
    [self.newButton setTitle:NSLS(@"kNewButtonTitle") forState:UIControlStateNormal];
    [self.newButton setImage:RESOURCE_NEW_BUTTON_IMAGE forState:UIControlStateNormal];
    [self.newButton setImage:RESOURCE_NEW_BUTTON_PRESS_IMAGE forState:UIControlStateSelected];
    
    
    [self.starredButton setTitle:NSLS(@"kStarredButtonTitle") forState:UIControlStateNormal];
    [self.starredButton setImage:RESOURCE_STARRED_BUTTON_IMAGE forState:UIControlStateNormal];
    [self.starredButton setImage:RESOURCE_STARRED_BUTTON_PRESS_IMAGE forState:UIControlStateSelected];
    
    supportRefreshHeader = YES;
    [self setRefreshHeaderViewFrame:CGRectMake(0, 0 - self.dataTableView.bounds.size.height, 320, self.dataTableView.bounds.size.height)];
    [self.refreshHeaderView setBackgroundColor:[UIColor clearColor]];
    [topButton setSelected:YES];
    lastSelectedButton = topButton;
    
    [super viewDidLoad];
        
    [self setNavigationRightButtonWithSystemStyle:UIBarButtonSystemItemRefresh action:@selector(loadSiteFromServer)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataTableView.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view from its nib.
    [self loadSiteFromServer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reloadData];
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [self setTopButton:nil];
    [self setHotButton:nil];
    [self setNewButton:nil];
    [self setStarredButton:nil];
    [self setResourceBackgroundView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [ResourceCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [ResourceCell getCellIdentifier];
	ResourceCell *cell = (ResourceCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [ResourceCell createCell:self];
	}
    
    cell.indexPath = indexPath;
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
    if (requestType == SITE_REQUEST_TYPE_NONE){
        Site* site = [self.dataList objectAtIndex:row];
        [cell setCellInfoWithSite:site atIndexPath:indexPath];    
    }
    else{
        TopSite* site = [self.dataList objectAtIndex:row];
        [cell setCellInfoWithTopSite:site atIndexPath:indexPath];    
    }
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.row > [dataList count] - 1)
		return;
    
    TopSite* site = [self.dataList objectAtIndex:indexPath.row];
    [DownloadWebViewController show:self url:site.siteURL];
}

- (IBAction)clickHot:(id)sender
{
    self.requestType = SITE_REQUEST_TYPE_HOT;
    if ([self.hotList count] == 0){
        [self loadSiteFromServer];
    }
    else{
        [self reloadData];
    }
    
    [lastSelectedButton setSelected:NO];
    [hotButton setSelected:YES];
    lastSelectedButton = hotButton;
}

- (IBAction)clickTop:(id)sender
{
    self.requestType = SITE_REQUEST_TYPE_TOP;
    if ([self.topList count] == 0){
        [self loadSiteFromServer];
    }
    else{
        [self reloadData];
    }
    
    [lastSelectedButton setSelected:NO];
    [topButton setSelected:YES];
    lastSelectedButton = topButton;
    
}

- (IBAction)clickNew:(id)sender
{
    self.requestType = SITE_REQUEST_TYPE_NEW;
    if ([self.latestList count] == 0){
        [self loadSiteFromServer];
    }
    else{
        [self reloadData];
    }
    
    [lastSelectedButton setSelected:NO];
    [newButton setSelected:YES];
    lastSelectedButton = newButton;
    
}

- (IBAction)clickStarred:(id)sender
{
    self.requestType = SITE_REQUEST_TYPE_NONE;
    self.starredList = [[TopSiteManager defaultManager] findAllFavoriteSites];
    [self reloadData]; 
    
    [lastSelectedButton setSelected:NO];
    [starredButton setSelected:YES];
    lastSelectedButton = starredButton;
}

#pragma Pull Refresh Delegate
- (void) reloadTableViewDataSource
{
    [self loadSiteFromServer];
}

- (UIColor*)getDefaultTextColor
{
    return [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
}


@end
