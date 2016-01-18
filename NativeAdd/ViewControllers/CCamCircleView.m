//
//  CCamCircleView.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/14.
//
//

#import "CCamCircleView.h"

#define kRadius ([self bounds].size.width * 0.5f)
#define kTrackRadius kRadius * 0.9f
#define kPointSize 44.0

@implementation CCamCircleView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit{
    if (!_circleBG) {
        _circleBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [_circleBG setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_circleBG];
    }
    if (!_circlePoint) {
        _circlePoint = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/5, self.bounds.size.height/5)];
        [_circlePoint setBackgroundColor:[UIColor clearColor]];
        [_circlePoint setImage:[UIImage imageNamed:@"circlePoint"]];
        [self addSubview:_circlePoint];
    }
    [self resetPoint];
}
- (void)resetPoint{
    [_circlePoint setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
    _x = 0.0;
    _y = 0.0;
}
- (void)setHandlePositionWithLocation:(CGPoint)location
{
    _x = location.x - kRadius;
    _y = -(location.y - kRadius);
    
    float r = sqrt(_x * _x + _y * _y);
    
    if (r >= kTrackRadius) {
        
        _x = kTrackRadius * (_x / r);
        _y = kTrackRadius * (_y / r);
        
        location.x = _x + kRadius;
        location.y = -_y + kRadius;
        
        
    }
    [self pointValueChanged];
    
    CGRect pointFrame = [_circlePoint frame];
    pointFrame.origin = CGPointMake(location.x - ([_circlePoint bounds].size.width * 0.5f),
                                          location.y - ([_circlePoint bounds].size.width * 0.5f));
    [_circlePoint setFrame:pointFrame];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self setHandlePositionWithLocation:location];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self setHandlePositionWithLocation:location];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self pointValueChanged];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self pointValueChanged];
}
- (void)pointValueChanged{
    if ([self.delegate respondsToSelector:@selector(pointValueChanged:)]) {
        [self.delegate pointValueChanged:self];
    }
}
@end
