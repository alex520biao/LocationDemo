//
//  ONEPopupTableView.h
//  Pods
//
//  Created by 张华威 on 16/9/13.
//
//

#import <UIKit/UIKit.h>
#import <ONEUIKit/ONESingleChoicePopupModel.h>
#import <ONEUIKit/ONEPopupView.h>

typedef NS_ENUM(NSUInteger, ONEPopupTableViewStyle) {
    ONEPopupTableViewStyleCenter,
    ONEPopupTableViewStyleLeft,
    ONEPopupTableViewStyleLeftWithIcon
};


@interface ONEPopupTableView : ONEPopupView

@property (nonatomic, copy) NSArray <ONESingleChoicePopupModel *>* dataArray;
@property (nonatomic, assign) ONEPopupTableViewStyle style;
@property (nonatomic, assign) NSInteger defaultIndex;

- (void)showOnView:(UIView *)superView complation:(ONESingleChoicePopupComplation)complation;
@end
