//
//  AddShoppingItemController.h
//  groupbuy
//
//  Created by LouisLee on 11-8-20.
//  Copyright 2011 ET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"

@interface AddShoppingItemController : PPTableViewController {
	
    NSString*   keywords;
    NSString*   itemId;
    NSDate*     expireDate;
    NSNumber*   maxPrice;
    UIDatePicker *datePicker;
    
    BOOL        isShowSubCategory;
    
    int         rowOfCategory;
    int         rowOfSubCategory;
    int         rowOfKeyword;
    int         rowOfValidPeriod;
    int         rowOfPrice;
    int         rowOfRebate;
    int         rowOfCity;
    int         rowNumber;
}

@property (nonatomic, retain) NSString* itemName;
@property (nonatomic, retain) NSString* keywords;
@property (nonatomic, retain) NSString* itemId;
@property (nonatomic, retain) NSDate*   expireDate;
@property (nonatomic, retain) NSNumber* maxPrice;

-(IBAction) selectCategory:(id) sender;
-(IBAction) selectSubCategory:(id) sender;

@end
