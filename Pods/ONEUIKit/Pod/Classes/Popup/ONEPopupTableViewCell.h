//
//  ONEPopupTableViewCell.h
//  Pods
//
//  Created by 张华威 on 16/9/13.
//
//

#import <UIKit/UIKit.h>

@interface ONEPopupTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIImage *highLightIcon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL alignLeft;
@property (nonatomic, assign) BOOL isDefault;
@end
