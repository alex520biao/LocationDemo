//
//  ONEPopupTableView.m
//  Pods
//
//  Created by 张华威 on 16/9/13.
//
//

#import "ONEPopupTableView.h"
#import "ONEPopupTableViewCell.h"
#import <UIView+Positioning/UIView+Positioning.h>
#import <ONEUIKit/ONEUIKitTheme.h>

#define SafeBlockRun(block, ...) block ? block(__VA_ARGS__) : nil

static const CGFloat kTableViewCellHeight = 50.f;

@interface ONEPopupTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) ONESingleChoicePopupComplation complation;

@end

@implementation ONEPopupTableView

- (void)showOnView:(UIView *)superView complation:(ONESingleChoicePopupComplation)complation {
    if (!superView) {
        superView  = [[UIApplication sharedApplication].delegate window];
    }
    
    self.complation = complation;
    
    self.showTopView = YES;
    
    self.contentView = [[UIView alloc] init];
    [self.tableView setFrame:CGRectMake(0, 0, superView.width, self.dataArray.count * kTableViewCellHeight)];
    [self.contentView addSubview:self.tableView];
    [self.contentView setFrame:self.tableView.frame];
    
    [self setConfirmTitle:@""];
    
    [super showOnView:superView close:^(ONEPopupViewCloseType type) {
        SafeBlockRun(self.complation, YES, -1, nil);
    } confirm:^{
        
    }];
    
    [self.tableView reloadData];
    
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.titleLabel);
}

- (UIButton *)confirmButton {
    return nil;
}

- (instancetype)init {
    if (self = [super init]) {
        _defaultIndex = -1;
    }
    return self;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SafeBlockRun(self.complation, NO, indexPath.row, self.dataArray[indexPath.row]);
    [self dismiss];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (!self.dataArray || !(self.dataArray.count > row)) {
        return nil;
    }
    
    ONESingleChoicePopupModel *model = [self.dataArray objectAtIndex:row];
    ONEPopupTableViewCell *cell = [[ONEPopupTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, kTableViewCellHeight)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTitle:model.title];
    if (self.style == ONEPopupTableViewStyleLeftWithIcon) {
        [cell setAlignLeft:YES];
        [cell setIcon:model.icon];
        [cell setHighLightIcon:model.icon];
    } else if (self.style == ONEPopupTableViewStyleLeft) {
        [cell setAlignLeft:YES];
    }
    
    if (self.defaultIndex == indexPath.row) {
        [cell setIsDefault:YES];
    }
    
    return cell;
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:kColorWhite];
        [_tableView setScrollEnabled:NO];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//            [_tableView setSeparatorInset:UIEdgeInsetsZero];
//        }
//        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//            [_tableView setLayoutMargins:UIEdgeInsetsZero];
//        }
//        [_tableView setSeparatorColor:[kColorBlack colorWithAlphaComponent:.1f]];
    }
    return _tableView;
}

@end
