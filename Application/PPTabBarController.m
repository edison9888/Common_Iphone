//
//  Ivan_UITabBar.m
//  JustForTest
//
//  Created by Ivan on 11-5-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PPTabBarController.h"
#import "UIBadgeView.h"
#import "UIButtonExt.h"

#define TAB_BADGEVIEW_OFFSET 120111101
#define TAB_BUTTON_FIX_WIDTH    27
#define TAB_BUTTON_FIX_HEIGHT   27

#define TITLE_TAG       820111031

@implementation PPTabBarController

@synthesize currentSelectedIndex;
@synthesize buttons;
@synthesize slideBg;
@synthesize backgroundView;
@synthesize customTabBarView;
@synthesize selectedImageArray;
@synthesize buttonStyle;
@synthesize normalTextColor;
@synthesize selectTextColor;

- (void)viewDidAppear:(BOOL)animated{
    
    if (self.normalTextColor == nil)
        self.normalTextColor = [UIColor whiteColor];
    
    if (self.selectTextColor == nil)
        self.selectTextColor = [UIColor whiteColor];
    
	[self hideRealTabBar];
	[self customTabBar];
}

- (void)hideRealTabBar{
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.hidden = YES;
			break;
		}
	}
}

- (void)setBarBackground:(NSString*)backgroundImageName
{
    UIImage* image = [UIImage imageNamed:backgroundImageName];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];    
    self.backgroundView = imageView;
    self.backgroundView.frame = self.tabBar.bounds;
    [imageView release];
}

- (void)setButtonImage:(UIButton*)button image:(UIImage*)image
{
    if (image != nil){
        if (buttonStyle == TAB_BUTTON_STYLE_FILL)
            [button setBackgroundImage:image forState:UIControlStateNormal]; 
        else
            [button setImage:image forState:UIControlStateNormal];
    }
}

- (void)setButtonTitle:(UIButton*)button title:(NSString*)title
{
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];    
    
    // adjust title position
    if (buttonStyle == TAB_BUTTON_STYLE_FILL){
        [button setTitleEdgeInsets:UIEdgeInsetsMake(30, 0, 0, 0)];
    }
    else{
        [button centerImageAndTitle:1.0f];
    }
}

- (void)customTabBar{
    
    if (customTabBarView != nil){
        [self selectedTab:[self.buttons objectAtIndex:self.selectedIndex]];
        return;
    }
    
    // init
    customTabBarView = [[UIView alloc] initWithFrame:self.tabBar.frame];
    
    // set background
    customTabBarView.backgroundColor = [UIColor clearColor];
    [customTabBarView addSubview:backgroundView];
    
	// create buttons
	int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
	self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    
    // set button width & height
	double _width = 320.0f / viewCount;
	double _height = self.tabBar.frame.size.height;
    
	for (int i = 0; i < viewCount; i++) {
		UIViewController *v = [self.viewControllers objectAtIndex:i];
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
		[btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
		btn.tag = i;
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(i*_width, 0, _width, _height);
        
        [self setButtonImage:btn image:v.tabBarItem.image];
        [self setButtonTitle:btn title:v.tabBarItem.title];
        
        // add badge view
        if ([v.tabBarItem.badgeValue length] > 0){
            UIBadgeView *badgeView = [[UIBadgeView alloc] initWithFrame:CGRectMake(40, 0, 30, 20)];
            badgeView.badgeString = v.tabBarItem.badgeValue;
            badgeView.badgeColor = [UIColor redColor];
            badgeView.tag = btn.tag + TAB_BADGEVIEW_OFFSET;
            [btn addSubview:badgeView];
            [badgeView release];
        }
        
		[self.buttons addObject:btn];
		[customTabBarView addSubview:btn];
	}
    
//	[customTabBarView addSubview:slideBg];
	[self.view insertSubview:customTabBarView atIndex:0];

	[self selectedTab:[self.buttons objectAtIndex:self.selectedIndex]];

}

- (void)selectedTab:(UIButton *)button{

    // set new selected index
	self.currentSelectedIndex = button.tag;
    
    // update tab bar image for all buttons
    int i=0;
    for (UIButton* b in buttons){
        UIImage* image = nil;
        if (self.currentSelectedIndex == b.tag) {		
            NSString* imageName = [selectedImageArray objectAtIndex:i];
            image = [UIImage imageNamed:imageName];
            
            // set text color
            [b setTitleColor:self.selectTextColor forState:UIControlStateNormal];
        }
        else{
            UIViewController* v = [self.viewControllers objectAtIndex:i];
            image = v.tabBarItem.image;

            // set text color
            [b setTitleColor:self.normalTextColor forState:UIControlStateNormal];
        }

        [self setButtonImage:b image:image];
        
        i++;
    }
            
    // activate normal tab bar controller
	self.selectedIndex = self.currentSelectedIndex;
    
    // animation for slide tab bar background
	[self performSelector:@selector(slideTabBg:) withObject:button];
}

- (void)setTextColor:(UIColor*)normalTextColorValue selectTextColor:(UIColor*)selectTextColorValue
{
    self.selectTextColor = selectTextColorValue;
    self.normalTextColor = normalTextColorValue;
}

- (void)slideTabBg:(UIButton *)btn{
	[UIView beginAnimations:nil context:nil];  
	[UIView setAnimationDuration:0.20];  
	[UIView setAnimationDelegate:self];
	slideBg.frame = btn.frame;
	[UIView commitAnimations];
}

- (void) dealloc{
    [selectTextColor release];
    [normalTextColor release];
    [selectedImageArray release];
    [backgroundView release];
	[slideBg release];
	[buttons release];
    [customTabBarView release];
	[super dealloc];
}

- (void)setBadgeValue:(NSString *)value buttonTag:(NSInteger)tag
{
    for (UIButton* b in buttons) {
        if (b.tag == tag) {
            UIBadgeView *view = (UIBadgeView*)[b viewWithTag:(tag + TAB_BADGEVIEW_OFFSET)];
            if (view == nil) {
                view = [[UIBadgeView alloc] initWithFrame:CGRectMake(40, 0, 30, 20)];
                view.tag = tag + TAB_BADGEVIEW_OFFSET;
                [view setBadgeString:value];
                view.badgeColor = [UIColor redColor];
                [b addSubview:view];
                [view release];
            } else {
                [view setBadgeString:value];
            }
            if ([value intValue] == 0) {
                [view setHidden:YES];
            } else {
                [view setHidden:NO];
            }
            
        } 
    }
}
@end
