//
//  KLPageControl.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/9.
//
//

#import "KLPageControl.h"

@implementation KLPageControl

-(id) initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _activeColor = [UIColor redColor];
        
        _inactiveColor = [UIColor lightGrayColor];
        
    }
    
    return self;
    
}
-(void) updateDots

{
    
    for (int i = 0; i < [self.subviews count]; i++)
        
    {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) {
            
            dot.backgroundColor = _activeColor;
            
        } else {
            
            dot.backgroundColor = _inactiveColor;
            
        }
        
    }
    
}

-(void) setCurrentPage:(NSInteger)page

{
    
    [super setCurrentPage:page];
    
    [self updateDots];
    
}
@end
