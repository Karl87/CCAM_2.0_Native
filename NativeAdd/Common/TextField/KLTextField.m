//
//  KLTextField.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/10.
//
//

#import "KLTextField.h"

@implementation KLTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init{
    if (self = [super init]) {
        [self setBorderStyle:UITextBorderStyleNone];
        [self setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self setReturnKeyType:UIReturnKeyDone];
        [self setTintColor:[UIColor whiteColor]];
        [self setClearButtonMode:UITextFieldViewModeAlways];
    }
    return  self;
}
- (UIView*)separator{
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 2)];
    [separator setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:separator];
    return separator;
}
- (UILabel*)rule{
    UILabel *rule  = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height -5, self.frame.size.width, 10)];
    [rule setBackgroundColor:[UIColor clearColor]];
    [rule setFont:[UIFont systemFontOfSize:11.]];
    [rule setTextColor:[UIColor whiteColor]];
    [self addSubview:rule];
    return rule;
}
- (AFViewShaker *)viewShaker{
    AFViewShaker *viewShaker = [[AFViewShaker alloc] initWithView:self];
    return viewShaker;
}
@end
