//
//  KLTextField.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/10.
//
//

#import <UIKit/UIKit.h>
#import "AFViewShaker.h"

@interface KLTextField : UITextField
@property (nonatomic,strong) UIView *separator;
@property (nonatomic,strong) AFViewShaker *viewShaker;
@property (nonatomic,strong) UILabel *rule;
@end
