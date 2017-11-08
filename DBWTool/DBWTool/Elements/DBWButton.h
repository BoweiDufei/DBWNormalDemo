//
//  DBWButton.h
//  DBWTool
//
//  Created by dbw on 2017/11/8.
//  Copyright © 2017年 dbwaaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Badge)


@property (strong, nonatomic) UILabel *badge;
@property (strong, nonatomic) NSIndexPath *indexPath;

// Badge value to be display
@property (nonatomic) NSString *badgeValue;
// Badge background color
@property (nonatomic) UIColor *badgeBGColor;
// Badge text color
@property (nonatomic) UIColor *badgeTextColor;
// Badge font
@property (nonatomic) UIFont *badgeFont;
// Padding value for the badge
@property (nonatomic) CGFloat badgePadding;
// Minimum size badge to small
@property (nonatomic) CGFloat badgeMinSize;
// Values for offseting the badge over the BarButtonItem you picked
@property (nonatomic) CGFloat badgeOriginX;
@property (nonatomic) CGFloat badgeOriginY;
// In case of numbers, remove the badge when reaching zero
@property BOOL shouldHideBadgeAtZero;
// Badge has a bounce animation when value changes
@property BOOL shouldAnimateBadge;
@end
