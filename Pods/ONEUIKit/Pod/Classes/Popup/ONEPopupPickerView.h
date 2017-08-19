//
//  ONEPopupPickerView.h
//  Pods
//
//  Created by 张华威 on 16/9/13.
//
//

#import <ONEUIKit/ONEUIKit.h>
#import <ONEUIKit/ONESingleChoicePopupModel.h>

@interface ONEPopupPickerView : ONEPopupView

@property (nonatomic, copy) NSArray <ONESingleChoicePopupModel *>* dataArray;
@property (nonatomic, assign) NSInteger defaultIndex;

- (void)showOnView:(UIView *)superView complation:(ONESingleChoicePopupComplation)complation;

@end
