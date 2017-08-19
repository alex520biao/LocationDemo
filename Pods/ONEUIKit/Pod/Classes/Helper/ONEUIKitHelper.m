//
//  ONEUIKitHelper.m
//  Pods
//
//  Created by 张华威 on 16/9/8.
//
//

#import "ONEUIKitHelper.h"

@implementation ONEUIKitHelper

+ (CGSize)labelSizeFromLabel:(UILabel *)label withLineSpace:(NSInteger)lineSpace withString:(NSString *)string maxWidth:(CGFloat)maxWidth {
    if (!label || !string) {
        return CGSizeZero;
    }
    if (maxWidth <= 0) {
        maxWidth = [[UIScreen mainScreen] bounds].size.width;
    }
    
    [label setNumberOfLines:0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    [attributedString addAttribute:NSFontAttributeName
                             value:label.font
                             range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    label.attributedText = attributedString;

    label.frame = [label.attributedText boundingRectWithSize:CGSizeMake(maxWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    [label sizeToFit];
    
    if (label.frame.size.height < 2 *label.font.lineHeight + lineSpace) {
        return CGSizeMake(label.frame.size.width, label.frame.size.height - lineSpace);
    }
//    label.frame =
    
    return label.frame.size;
}

@end
