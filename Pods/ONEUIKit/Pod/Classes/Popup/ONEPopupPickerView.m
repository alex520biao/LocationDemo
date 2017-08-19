//
//  ONEPopupPickerView.m
//  Pods
//
//  Created by 张华威 on 16/9/13.
//
//

#import "ONEPopupPickerView.h"
#import <UIView+Positioning/UIView+Positioning.h>
#import <ONEFoundation/ONEFoundation.h>

#define SafeBlockRun(block, ...) block ? block(__VA_ARGS__) : nil

static const CGFloat kPickerViewHeight = 153.f;
static const CGFloat kPickerViewRowHeight = 34.f;
static const CGFloat kPickerViewMargin = 20.f;

@interface ONEPopupPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation ONEPopupPickerView

- (void)showOnView:(UIView *)superView complation:(ONESingleChoicePopupComplation)complation {
    if (!superView) {
        superView  = [[UIApplication sharedApplication].delegate window];
    }
    
    self.showTopView = YES;
    
    self.contentView = [[UIView alloc] init];
    
    [self.pickerView setFrame:CGRectMake(0, kPickerViewMargin, superView.width, kPickerViewHeight)];
    [self.backView setFrame:CGRectMake(0, 0, superView.width, kPickerViewHeight + kPickerViewMargin * 2)];
    [self.backView addSubview:self.pickerView];
    
    [self.contentView addSubview:self.backView];
    [self.contentView setFrame:self.backView.frame];
    [self.contentView setIsAccessibilityElement:NO];
    
    NSUInteger defaultIndex = MIN(MAX(self.defaultIndex,0), self.dataArray.count - 1);
    
    [self.pickerView selectRow:defaultIndex inComponent:0 animated:NO];
    
    __weak typeof(self) weakSelf = self;
    [super showOnView:superView close:^(ONEPopupViewCloseType type) {
        SafeBlockRun(complation, YES, type, nil);
    } confirm:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            NSInteger index = [strongSelf.pickerView selectedRowInComponent:0];
            ONESingleChoicePopupModel *model = nil;
            if (self.dataArray.count > index && index >= 0) {
                model = [self.dataArray objectAtIndex:index];
            }
            
            SafeBlockRun(complation, NO, index, model);
        }
    }];
    
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.titleLabel);
    
    [self.pickerView reloadAllComponents];
    
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [_pickerView setBackgroundColor:kColorWhite];
        [_pickerView setShowsSelectionIndicator:YES];
        
        [_pickerView setIsAccessibilityElement:YES];
        [_pickerView setAccessibilityHint:@""];
        [_pickerView setAccessibilityTraits:UIAccessibilityTraitNone];
    }
    return _pickerView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [_backView setBackgroundColor:kColorWhite];
    }
    return _backView;
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kPickerViewRowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    ONESingleChoicePopupModel *model;
    if (self.dataArray.count > row && row >= 0) {
        model = self.dataArray[row];
    } else {
        model = [[ONESingleChoicePopupModel alloc] init];
    }
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, kPickerViewRowHeight)];
    myView.backgroundColor = [UIColor clearColor];
    
    UILabel * complateLabel = [[UILabel alloc] init];
    complateLabel.center = myView.center;
    complateLabel.bounds = CGRectMake(0, 0, width, kPickerViewRowHeight);
    complateLabel.textColor = [ONEUIKitTheme colorWithHexString:@"0a0a0a"];
    //    kColorDeepGray;
    complateLabel.textAlignment = NSTextAlignmentCenter;
    complateLabel.font = kFontSizeLarge1_;
    complateLabel.text = [NSString stringWithFormat:@"%@",model];
    complateLabel.numberOfLines = 1;
    [myView addSubview:complateLabel];
    
    ((UIView *)[self.pickerView.subviews objectAtIndex:1]).backgroundColor = [kColorBlack colorWithAlphaComponent:.1f];
    ((UIView *)[self.pickerView.subviews objectAtIndex:1]).height = .5f;
    ((UIView *)[self.pickerView.subviews objectAtIndex:2]).backgroundColor = [kColorBlack colorWithAlphaComponent:.1f];
    ((UIView *)[self.pickerView.subviews objectAtIndex:2]).height = .5f;
    
    return myView;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [NSString stringWithFormat:@"%@", [self.dataArray objectAtIndex:row]];
}


@end
