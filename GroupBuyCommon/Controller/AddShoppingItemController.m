//
//  AddShoppingItemController.m
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import "AddShoppingItemController.h"
#import "ShoppingKeywordCell.h"
#import "ShoppingCategoryCell.h"
#import "ShoppingSubCategoryCell.h"
#import "ShoppingValidPeriodCell.h"
#import "SliderCell.h"
#import "UserShopItemService.h"
#import "CategoryManager.h"

#pragma mark Private
@interface AddShoppingItemController()

// static data
@property (nonatomic, retain) NSArray* categories;
@property (nonatomic, retain) NSArray* subCategories;
@property (nonatomic,retain) NSDictionary* subCateogriesDict;

// data
@property (nonatomic, retain) NSString* selectedCategory;
@property (nonatomic, retain) NSString* selectedSubCategory;

// UI elements
@property (nonatomic,assign) BOOL shouldShowSubCategoryCell;
@property (nonatomic,retain) UITextField* keywordTextField;

@end

@implementation AddShoppingItemController


@synthesize categories;
@synthesize subCategories;
@synthesize shouldShowSubCategoryCell;
@synthesize itemName;
@synthesize selectedCategory;
@synthesize selectedSubCategory;
@synthesize subCateogriesDict;
@synthesize keywordTextField;

@synthesize itemId;
@synthesize keywords;
@synthesize expireDate;
@synthesize maxPrice;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


#define NOT_LIMIT   @"不限"

- (void)updateRowIndex
{
    if ([selectedCategory isEqualToString:NOT_LIMIT] == NO){
        isShowSubCategory = YES;
    }
    else{
        isShowSubCategory = NO;
    }
    
    if (isShowSubCategory){
        rowOfCategory = 0;
        rowOfSubCategory = 1;
        rowOfKeyword = 2;
        rowOfValidPeriod = 3;
        rowOfPrice = 4;
        rowOfRebate = -1;       // not used
        rowNumber = 5;
    }
    else{
        rowOfCategory = 0;
        rowOfSubCategory = -1;  // don't show
        rowOfKeyword = 1;
        rowOfValidPeriod = 2;
        rowOfPrice = 3;
        rowOfRebate = -1;       // not used
        rowNumber = 4;
    }
    
    [dataTableView reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationRightButton:@"保存" action:@selector(clickSave:)];
	
	self.shouldShowSubCategoryCell = NO;
	self.selectedCategory = NOT_LIMIT;
	self.selectedSubCategory = NOT_LIMIT;	    
        
    self.categories = [CategoryManager getAllCategories];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateRowIndex];
    [super viewDidAppear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    [maxPrice release];
    [expireDate release];    
    [itemId release];
    [keywords release];
    [keywordTextField release];
	[categories release];
	[subCategories release];
	[itemName release];
	[selectedCategory release];
	[selectedSubCategory release];
	[subCateogriesDict release];
    [super dealloc];
}

#pragma mark Table View Delegate

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	//NSString *sectionHeader = [groupData titleForSection:section];	
	return sectionHeader;
}
 */


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == rowOfCategory){
        return [ShoppingCategoryCell getCellHeight];            
    }
    else if (indexPath.row == rowOfSubCategory){
        return [ShoppingSubCategoryCell getCellHeight];
    }
    else if (indexPath.row == rowOfKeyword){
        return [ShoppingKeywordCell getCellHeight];
    }
    else if (indexPath.row == rowOfValidPeriod){
        return [ShoppingValidPeriodCell getCellHeight];
    }
    else if (indexPath.row == rowOfPrice){
		return [SliderCell getCellHeight];
    }
    else if (indexPath.row == rowOfRebate){
		return [SliderCell getCellHeight];
    }
    else{
        return 0.0f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowNumber;
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.row == rowOfCategory){
        
        ShoppingCategoryCell* cell = nil;		
		NSString *CellIdentifier = [ShoppingCategoryCell getCellIdentifier];
		cell = (ShoppingCategoryCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingCategoryCell createCell:self];
            [cell updateAllButtonLabelsWithArray:self.categories];
            [cell addButtonsAction:@selector(selectCategory:)];
		}
        
		[cell highlightTheSelectedLabel:self.selectedCategory];		
        
        return cell;
    }	
	else if (indexPath.row == rowOfSubCategory){		
        
        ShoppingSubCategoryCell* cell = nil;
        
        NSString *CellIdentifier = [ShoppingSubCategoryCell getCellIdentifier];
        cell = (ShoppingSubCategoryCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
			
        if (cell == nil) {
            cell = [ShoppingSubCategoryCell createCell:self];
            [cell addButtonsAction:@selector(selectSubCategory:)];
        }
		   
        NSArray* subCategory = [CategoryManager getSubCategoriesByCategory:self.selectedCategory];
        [cell updateAllButtonLabelsWithArray:subCategory];		   
        [cell highlightTheSelectedLabel:self.selectedSubCategory];		        

        return cell;
    }	
    else if (indexPath.row == rowOfKeyword){
        
        ShoppingKeywordCell* cell = nil;

		NSString *CellIdentifier = [ShoppingKeywordCell getCellIdentifier];
		cell = (ShoppingKeywordCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingKeywordCell createCell:self];
            self.keywordTextField = cell.keywordTextField;
		}
        
        return cell;
		
	}else if (indexPath.row == rowOfValidPeriod) {
        
        ShoppingValidPeriodCell* cell = nil;

		NSString *CellIdentifier = [ShoppingValidPeriodCell getCellIdentifier];
		cell = (ShoppingValidPeriodCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [ShoppingValidPeriodCell createCell:self];
		}
        
        
        
        return cell;
		
	}else if (indexPath.row == rowOfPrice)  {

        SliderCell* cell = nil;
        
		NSString *CellIdentifier = [SliderCell getCellIdentifier];
		cell = (SliderCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [SliderCell createCell:self];
		}
        return cell;
		
	} else if (indexPath.row == rowOfRebate)  {
        
        SliderCell* cell = nil;

		NSString *CellIdentifier = [SliderCell getCellIdentifier];
		cell = (SliderCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [SliderCell createCell:self];
		}
        return cell;
		
	}
    else{
        NSLog(@"ERROR: <cellForRowAtIndexPath> cannot found cell for row at %d", indexPath.row);
        return nil;
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}



/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
		
}*/

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
	
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}


-(IBAction) selectCategory:(id) sender {
	UIButton *button = (UIButton *)sender;    
	if([button.currentTitle isEqualToString:NOT_LIMIT]){
		shouldShowSubCategoryCell = NO;
	}else{
		shouldShowSubCategoryCell = YES;
		self.selectedSubCategory = NOT_LIMIT;
	}
    NSLog(@"<selectCategory> category=%@", button.currentTitle);
	self.selectedCategory = button.currentTitle;
    [self updateRowIndex];
}


-(IBAction) selectSubCategory:(id) sender {    

	UIButton *button = (UIButton *)sender;        
    NSLog(@"<selectSubCategory> sub category=%@", button.currentTitle);
	self.selectedSubCategory = button.currentTitle;
    [self updateRowIndex];
}

- (void)clickSave:(id)sender
{
    if (keywordTextField != nil){
        if ([keywordTextField isFirstResponder])
            [keywordTextField resignFirstResponder];
        
        self.keywords = keywordTextField.text;
        NSLog(@"<save> keywords=%@", keywords);
    }
    
    UserShopItemService* shopService = GlobalGetUserShopItemService();
    [shopService addUserShoppingItem:itemId city:nil categoryName:nil subCategoryName:nil keywords:keywords maxPrice:nil minRebate:nil];
}

@end
