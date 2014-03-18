//
//  SDBaseGridView.m
//  Somday
//
//  Created by Tao, Steven on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDBaseGridView.h"
#import "CAKeyframeAnimation+Addition.h"
#import "GHContextMenuView.h"

KeyframeParametricBlock openFunction = ^double(double time) {
    return sin(time*M_PI_2);
};
KeyframeParametricBlock closeFunction = ^double(double time) {
    return -cos(time*M_PI_2)+1;
};

enum {
	SDMenuDirectionFromRight     = 0,
	SDMenuDirectionFromLeft      = 1,
    SDMenuDirectionFromTop       = 2,
    SDMenuDirectionFromBottom    = 3,
};
typedef NSUInteger SDMenuDirection;

enum {
	SDGridMenuStateIdle    = 0,
	SDGridMenuStateUpdate  = 1,
	SDGridMenuStateShow    = 2
};
typedef NSUInteger SDGridMenuState;


@interface SDBaseGridView () <GHContextOverlayViewDataSource, GHContextOverlayViewDelegate>
@property (nonatomic) SDGridMenuState menuState;
@property (nonatomic) CALayer *origamiLayer;
@property (nonatomic) CGFloat start;
@property (nonatomic) CGFloat end;
@property (nonatomic) UIImage *viewSnapShot;
@property (nonatomic) GHContextMenuView* menuOverlay;

-(void)initBackgroundImageView;
-(void)initShareButton;
-(void)initMoreButton;
-(void)initLikeButton;

-(IBAction)actionForItem:(id)sender;

@end

@implementation SDBaseGridView

@synthesize origamiLayer, viewSnapShot, shareButton, moreButton, commentButton, likeButton, menuOverlay;

+ (CGFloat)heightForCell
{
    return 304.0f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initBaseGridView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initBaseGridView];
    }
    return self;
}

- (void)initBaseGridView
{
    // BackgroundColor
    self.backgroundColor = [UIColor clearColor];
    
    [self initBackgroundImageView];
    
    // Shadow and round corner Effect
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowPath =  [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    
    // Add common button
    [self initShareButton];
    [self initMoreButton];
    [self initLikeButton];
    
    // Add like menu
    self.menuOverlay = [[GHContextMenuView alloc] init];
    menuOverlay.dataSource = self;
    menuOverlay.delegate = self;
    
    // Add Gesture recognizer
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    recognizer.direction =  UISwipeGestureRecognizerDirectionLeft;
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
}

-(void)initBackgroundImageView{
    if( !self.backgroundImageView ){
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_backgroundImageView];
    }
    self.backgroundImageView.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.userInteractionEnabled = YES;
    self.backgroundImageView.clipsToBounds = YES;
    
    self.backgroundImageView.layer.masksToBounds = YES;
    self.backgroundImageView.layer.cornerRadius = 8.0f;
}

-(void)initShareButton{
    if( !self.shareButton ){
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self insertSubview:shareButton belowSubview:_backgroundImageView];
    }
    UIImage *image = [UIImage imageNamed:@"icons-24px_share"];
    [shareButton setBackgroundImage:image forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(10, 136, image.size.width, image.size.height);
    [shareButton setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
    [shareButton setTitleEdgeInsets:UIEdgeInsetsMake(36, 0, 0, 0)];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:9];
}

-(void)initMoreButton{
    if( !self.moreButton ){
        self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self insertSubview:moreButton belowSubview:_backgroundImageView];
    }
    
    UIImage* image = [UIImage imageNamed:@"icons-24px_more"];
    [moreButton setImage:image forState:UIControlStateNormal];
    moreButton.frame = CGRectMake(10, 260, image.size.width, image.size.height);
}

-(void)initLikeButton{
    if( !self.likeButton ){
        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backgroundImageView addSubview:likeButton];
    }
    UIImage* image = [UIImage imageNamed:@"icons-24px_like"];
    [likeButton setImage:image forState:UIControlStateNormal];
    likeButton.frame = CGRectMake(200, 260, image.size.width, image.size.height);
    if( ![likeButton targetForAction:@selector(actionForItem:) withSender:self] ){
        [likeButton addTarget:self action:@selector(actionForItem:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)prepareForReuse
{
    _menuState = SDGridMenuStateIdle;
    [origamiLayer removeFromSuperlayer];
    self.origamiLayer = nil;
}

#pragma mark -

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.backgroundImageView.image = image;
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer*)gestureRecognizer
{
    UISwipeGestureRecognizer *recognizer = gestureRecognizer;
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionRight: {
            [self showTransitionWithImageView: self.backgroundImageView NumberOfFolds:3 Duration:0.4f Direction:SDMenuDirectionFromRight completion:^(BOOL finished) {
                    self.backgroundImageView.userInteractionEnabled = NO;
            }];
        }
            break;
        case UISwipeGestureRecognizerDirectionLeft:
        {
            [self hideTransitionWithImageView:self.backgroundImageView NumberOfFolds:3 Duration:0.4f Direction:SDMenuDirectionFromRight completion:^(BOOL finished) {
                self.backgroundImageView.image = _image;
                self.layer.shadowOpacity = 0.7f;
                self.backgroundImageView.userInteractionEnabled = YES;
            }];
        }
            break;
        default:
            break;
    }
}

- (void)toggleMenu
{
    if (_menuState == SDGridMenuStateShow)
        [self hideTransitionWithImageView:self.backgroundImageView NumberOfFolds:3 Duration:0.4f Direction:SDMenuDirectionFromRight completion:^(BOOL finished) {
            self.backgroundImageView.image = _image;
            self.layer.shadowOpacity = 0.7f;
        }];
    else if (_menuState == SDGridMenuStateIdle) {
        [self showTransitionWithImageView: self.backgroundImageView NumberOfFolds:3 Duration:0.4f Direction:SDMenuDirectionFromRight completion:^(BOOL finished) {

        }];
    }
}

- (CATransformLayer *)transformLayerFromImage:(UIImage *)image Frame:(CGRect)frame fold:(NSInteger)fold Duration:(CGFloat)duration AnchorPiont:(CGPoint)anchorPoint StartAngle:(double)start EndAngle:(double)end;
{
    CATransformLayer *jointLayer = [CATransformLayer layer];
    jointLayer.anchorPoint = anchorPoint;
    CALayer *imageLayer = [CALayer layer];
    CAGradientLayer *shadowLayer = [CAGradientLayer layer];
    double shadowAniOpacity;
    
    if (anchorPoint.y == 0.5) {
        CGFloat layerWidth;
        if (anchorPoint.x == 0 ) //from left to right
        {
            layerWidth = image.size.width - frame.origin.x;
            jointLayer.frame = CGRectMake(0, 0, layerWidth, frame.size.height);
            if (frame.origin.x) {
                jointLayer.position = CGPointMake(frame.size.width, frame.size.height/2);
            }
            else {
                jointLayer.position = CGPointMake(0, frame.size.height/2);
            }
        }
        else { //from right to left
            layerWidth = frame.origin.x + frame.size.width;
            jointLayer.frame = CGRectMake(0, 0, layerWidth, frame.size.height);
            jointLayer.position = CGPointMake(layerWidth, frame.size.height/2);
        }
        
        //map image onto transform layer
        imageLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        imageLayer.anchorPoint = anchorPoint;
        imageLayer.position = CGPointMake(layerWidth*anchorPoint.x, frame.size.height/2);
        [jointLayer addSublayer:imageLayer];
        CGImageRef imageCrop = CGImageCreateWithImageInRect(image.CGImage, frame);
        imageLayer.contents = (__bridge id)imageCrop;
        imageLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        //add shadow
        shadowLayer.frame = imageLayer.bounds;
        shadowLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
        shadowLayer.opacity = 0.0;
        shadowLayer.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
        if (fold%2) {
            shadowLayer.startPoint = CGPointMake(0, 0.5);
            shadowLayer.endPoint = CGPointMake(1, 0.5);
            shadowAniOpacity = (anchorPoint.x)?0.24:0.32;
            shadowAniOpacity = 0.4f;
        }
        else {
            shadowLayer.startPoint = CGPointMake(1, 0.5);
            shadowLayer.endPoint = CGPointMake(0, 0.5);
            shadowAniOpacity = (anchorPoint.x)?0.32:0.24;
            shadowAniOpacity = 0.0f;
        }
    }
    else{
        CGFloat layerHeight;
        if (anchorPoint.y == 0 ) //from top
        {
            layerHeight = image.size.height - frame.origin.y;
            jointLayer.frame = CGRectMake(0, 0, frame.size.width, layerHeight);
            if (frame.origin.y) {
                jointLayer.position = CGPointMake(frame.size.width/2, frame.size.height);
            }
            else {
                jointLayer.position = CGPointMake(frame.size.width/2, 0);
            }
        }
        else { //from bottom
            layerHeight = frame.origin.y + frame.size.height;
            jointLayer.frame = CGRectMake(0, 0, frame.size.width, layerHeight);
            jointLayer.position = CGPointMake(frame.size.width/2, layerHeight);
        }
        
        //map image onto transform layer
        imageLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        imageLayer.anchorPoint = anchorPoint;
        imageLayer.position = CGPointMake(frame.size.width/2, layerHeight*anchorPoint.y);
        [jointLayer addSublayer:imageLayer];
        CGImageRef imageCrop = CGImageCreateWithImageInRect(image.CGImage, frame);
        imageLayer.contents = (__bridge id)imageCrop;
        imageLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        //add shadow
        shadowLayer.frame = imageLayer.bounds;
        shadowLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
        shadowLayer.opacity = 0.0;
        shadowLayer.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
        
        if (fold%2) {
            shadowLayer.startPoint = CGPointMake(0.5, 0);
            shadowLayer.endPoint = CGPointMake(0.5, 1);
            shadowAniOpacity = (anchorPoint.x)?0.24:0.32;
        }
        else {
            shadowLayer.startPoint = CGPointMake(0.5, 1);
            shadowLayer.endPoint = CGPointMake(0.5, 0);
            shadowAniOpacity = (anchorPoint.x)?0.32:0.24;
        }
    }
    
    [imageLayer addSublayer:shadowLayer];
    
    //animate open/close animation
    CABasicAnimation* animation = (anchorPoint.y == 0.5)?[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"]:[CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    [animation setDuration:duration];
    [animation setFromValue:[NSNumber numberWithDouble:start/3]];
    [animation setToValue:[NSNumber numberWithDouble:end/3]];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    [jointLayer addAnimation:animation forKey:@"jointAnimation"];
    
    //animate shadow opacity
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setDuration:duration];
    [animation setFromValue:[NSNumber numberWithDouble:(start)?shadowAniOpacity:0]];
    [animation setToValue:[NSNumber numberWithDouble:(start)?0:shadowAniOpacity]];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    [shadowLayer addAnimation:animation forKey:nil];
    
    return jointLayer;
}

- (void)hideTransitionWithImageView:(UIImageView*)imageView
                      NumberOfFolds:(NSInteger)folds
                           Duration:(CGFloat)duration
                          Direction:(SDMenuDirection)direction
                         completion:(void (^)(BOOL finished))completion
{

    if (_menuState != SDGridMenuStateShow) {
        return;
    }
    _menuState = SDGridMenuStateUpdate;
    
    [origamiLayer removeFromSuperlayer];
    self.origamiLayer = nil;
    
    //set frame
    CGRect selfFrame = self.frame;
    CGPoint anchorPoint;
    if (direction == SDMenuDirectionFromRight) {
        
        anchorPoint = CGPointMake(1, 0.5);
    }
    else if(direction == SDMenuDirectionFromLeft){
        
        anchorPoint = CGPointMake(0, 0.5);
    }
    else if(direction == SDMenuDirectionFromTop){
        
        anchorPoint = CGPointMake(0.5, 0);
    }
    else if(direction == SDMenuDirectionFromBottom){
        
        anchorPoint = CGPointMake(0.5, 1);
    }
    
    UIView *view = self;    
    
    //set 3D depth
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/800.0;
    self.origamiLayer = [CALayer layer];
    origamiLayer.frame = view.bounds;
    origamiLayer.backgroundColor = [UIColor clearColor].CGColor;
    origamiLayer.sublayerTransform = transform;
    origamiLayer.shadowColor = [UIColor blackColor].CGColor;
    origamiLayer.shadowOffset = CGSizeMake(3.0, 3.0);
    origamiLayer.shadowOpacity = 0.7f;
    
    [view.layer addSublayer:origamiLayer];
    
    //setup rotation angle
    double startAngle;
    CGFloat frameWidth = view.bounds.size.width;
    CGFloat frameHeight = view.bounds.size.height;
    CGFloat foldWidth = (direction < 2)?frameWidth/folds:frameHeight/folds;
    CALayer *prevLayer = origamiLayer;
    for (int b=0; b < folds; b++) {
        CGRect imageFrame;
        if (direction == SDMenuDirectionFromRight) {
            if(b == 0)
                startAngle = -M_PI_2;
            else {
                if (b%2)
                    startAngle = M_PI;
                else
                    startAngle = -M_PI;
            }
            imageFrame = CGRectMake(frameWidth-(b+1)*foldWidth, 0, foldWidth, frameHeight);
        }
        else if(direction == SDMenuDirectionFromLeft){
            if(b == 0)
                startAngle = M_PI_2;
            else {
                if (b%2)
                    startAngle = -M_PI;
                else
                    startAngle = M_PI;
            }
            imageFrame = CGRectMake(b*foldWidth, 0, foldWidth, frameHeight);
        }
        else if(direction == SDMenuDirectionFromTop){
            if(b == 0)
                startAngle = -M_PI_2;
            else {
                if (b%2)
                    startAngle = M_PI;
                else
                    startAngle = -M_PI;
            }
            imageFrame = CGRectMake(0, b*foldWidth, frameWidth, foldWidth);
        }
        else if(direction == SDMenuDirectionFromBottom){
            if(b == 0)
                startAngle = M_PI_2;
            else {
                if (b%2)
                    startAngle = -M_PI;
                else
                    startAngle = M_PI;
            }
            imageFrame = CGRectMake(0, frameHeight-(b+1)*foldWidth, frameWidth, foldWidth);
        }
        CATransformLayer *transLayer = [self transformLayerFromImage:viewSnapShot Frame:imageFrame fold:b Duration:duration AnchorPiont:anchorPoint StartAngle:startAngle EndAngle:0];
        [prevLayer addSublayer:transLayer];
        prevLayer = transLayer;
    }
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        self.frame = selfFrame;
        [origamiLayer removeFromSuperlayer];
        self.origamiLayer = nil;
        _menuState = SDGridMenuStateIdle;
        
		if (completion)
			completion(YES);
    }];
    
    [CATransaction setValue:[NSNumber numberWithFloat:duration] forKey:kCATransactionAnimationDuration];
    CAAnimation *openAnimation = (direction < 2)?[CAKeyframeAnimation animationWithKeyPath:@"position.x" function:openFunction fromValue:self.frame.origin.x+self.frame.size.width/2 toValue:selfFrame.origin.x+self.frame.size.width/2]:[CAKeyframeAnimation animationWithKeyPath:@"position.y" function:openFunction fromValue:self.frame.origin.y+self.frame.size.height/2 toValue:selfFrame.origin.y+self.frame.size.height/2];
    
    openAnimation.fillMode = kCAFillModeForwards;
    [openAnimation setRemovedOnCompletion:NO];
    [self.layer addAnimation:openAnimation forKey:@"position"];
    [CATransaction commit];
}

- (void)showTransitionWithImageView:(UIImageView*)imageView
                      NumberOfFolds:(NSInteger)folds
                           Duration:(CGFloat)duration
                          Direction:(SDMenuDirection)direction
                         completion:(void (^)(BOOL finished))completion
{
    if (_menuState != SDGridMenuStateIdle) {
        return;
    }
    
    _menuState = SDGridMenuStateUpdate;
    
    //set frame
    CGRect selfFrame = self.frame;
    CGPoint anchorPoint;
    if (direction == SDMenuDirectionFromRight) {
        anchorPoint = CGPointMake(1, 0.5);
    }
    else if (direction == SDMenuDirectionFromLeft){
        anchorPoint = CGPointMake(0, 0.5);
    }
    else if (direction == SDMenuDirectionFromTop){
        anchorPoint = CGPointMake(0.5, 0);
    }
    else if (direction == SDMenuDirectionFromBottom){
        anchorPoint = CGPointMake(0.5, 1);
    }
    
    UIView *view = self;
    
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.viewSnapShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (imageView) {
        // remove the image first
        imageView.image = nil;
    }
    // remove the shadow
    view.layer.shadowOpacity = 0.0f;
    
    //set 3D depth
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/800.0;
    if (!origamiLayer)
        self.origamiLayer = [CALayer layer];
    origamiLayer.frame = view.bounds;
    origamiLayer.backgroundColor = [UIColor clearColor].CGColor;
    origamiLayer.sublayerTransform = transform;
    
    origamiLayer.shadowColor = [UIColor blackColor].CGColor;
    origamiLayer.shadowOffset = CGSizeMake(3.0, 3.0);
    origamiLayer.shadowOpacity = 0.7f;
    
    [view.layer addSublayer:origamiLayer];
    
    //setup rotation angle
    double endAngle;
    CGFloat frameWidth = view.bounds.size.width;
    CGFloat frameHeight = view.bounds.size.height;
    CGFloat foldWidth = (direction < 2)?frameWidth/folds:frameHeight/folds;
    CALayer *prevLayer = origamiLayer;
    for (int b=0; b < folds; b++) {
        CGRect imageFrame;
        if (direction == SDMenuDirectionFromRight) {
            if(b == 0)
                endAngle = -M_PI_2;
            else {
                if (b%2)
                    endAngle = M_PI;
                else
                    endAngle = -M_PI;
            }
            imageFrame = CGRectMake(frameWidth-(b+1)*foldWidth, 0, foldWidth, frameHeight);
        }
        else if(direction == SDMenuDirectionFromLeft){
            if(b == 0)
                endAngle = M_PI_2;
            else {
                if (b%2)
                    endAngle = -M_PI;
                else
                    endAngle = M_PI;
            }
            imageFrame = CGRectMake(b*foldWidth, 0, foldWidth, frameHeight);
        }
        else if(direction == SDMenuDirectionFromTop){
            if(b == 0)
                endAngle = -M_PI_2;
            else {
                if (b%2)
                    endAngle = M_PI;
                else
                    endAngle = -M_PI;
            }
            imageFrame = CGRectMake(0, b*foldWidth, frameWidth, foldWidth);
        }
        else if(direction == SDMenuDirectionFromBottom){
            if(b == 0)
                endAngle = M_PI_2;
            else {
                if (b%2)
                    endAngle = -M_PI;
                else
                    endAngle = M_PI;
            }
            imageFrame = CGRectMake(0, frameHeight-(b+1)*foldWidth, frameWidth, foldWidth);
        }
        CATransformLayer *transLayer = [self transformLayerFromImage:viewSnapShot Frame:imageFrame fold:b Duration:duration AnchorPiont:anchorPoint StartAngle:0 EndAngle:endAngle];
        [prevLayer addSublayer:transLayer];
        prevLayer = transLayer;
    }
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        _menuState = SDGridMenuStateShow;
        
		if (completion)
			completion(YES);
    }];
    
    [CATransaction setValue:[NSNumber numberWithFloat:duration] forKey:kCATransactionAnimationDuration];
    
    if (_start==0) {
        _start = self.frame.origin.x+self.frame.size.width/2;
        _end = selfFrame.origin.x+self.frame.size.width/2;
    }
    
    CAAnimation *openAnimation = (direction < 2)?[CAKeyframeAnimation animationWithKeyPath:@"position.x" function:closeFunction fromValue: _start toValue:_end]:[CAKeyframeAnimation animationWithKeyPath:@"position.y" function:closeFunction fromValue:self.frame.origin.y+self.frame.size.height/2 toValue:selfFrame.origin.y+self.frame.size.height/2];
    [openAnimation setRemovedOnCompletion:NO];
    openAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:openAnimation forKey:@"position"];
    [CATransaction commit];
}

#pragma mark - Action

- (void)actionForItem:(id)sender
{
    [menuOverlay showMenu];
}

#pragma mark - GHMenu methods

- (NSInteger) numberOfMenuItems
{
    return 3;
}

-(UIImage*) imageForItemAtIndex:(NSInteger)index
{
    NSString* imageName = nil;
    switch (index) {
        case 0:
            imageName = @"icons-24px_home";
            break;
        case 1:
            imageName = @"icons-24px_home";
            break;
        case 2:
            imageName = @"icons-24px_home";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}

- (void) didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point
{
//    NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:point];
//    
//    NSString* msg = nil;
//    switch (selectedIndex) {
//        case 0:
//            msg = @"Facebook Selected";
//            break;
//        case 1:
//            msg = @"Twitter Selected";
//            break;
//        case 2:
//            msg = @"Google Plus Selected";
//            break;
//        case 3:
//            msg = @"Linkedin Selected";
//            break;
//        case 4:
//            msg = @"Pinterest Selected";
//            break;
//            
//        default:
//            break;
//    }
//    
//    msg = [msg stringByAppendingFormat:@" for cell %ld", (long)indexPath.row +1];
//    
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
    
}



@end
