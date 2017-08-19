//
//  ONESingleChoicePopupModel.h
//  Pods
//
//  Created by 张华威 on 16/9/13.
//
//

#import <UIKit/UIKit.h>

@interface ONESingleChoicePopupModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) UIImage *icon;
@property (nonatomic, copy) UIImage *highLightIcon;

@end

typedef void (^ONESingleChoicePopupComplation) (BOOL isClosed, NSInteger index, ONESingleChoicePopupModel *model);
