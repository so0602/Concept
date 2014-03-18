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

#import "SDTextGridView.h"
#import "SDPhotoGridView.h"
#import "SDVoiceGridView.h"
#import "SDStoryBookGridView.h"

static NSString *BaseCellIdentifier = @"CollectionViewCell";
static NSString *TextCellIdentifier = @"TextCollectionViewCell";
static NSString *PhotoCellIdentifier = @"PhotoCollectionViewCell";
static NSString *VoiceCellIdentifier = @"VoiceCollectionViewCell";
static NSString *StoryBookCellIdentifier = @"StoryBookCollectionViewCell";

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
@property (nonatomic, strong) CALayer *origamiLayer;
@property (nonatomic) CGFloat start;
@property (nonatomic) CGFloat end;
@property (nonatomic, strong) UIImage *viewSnapShot;
@property (nonatomic, strong) GHContextMenuView* menuOverlay;

-(IBAction)actionForItem:(id)sender;

@end

@implementation SDBaseGridView

+ (CGFloat)heightForCell
{
    return 304.0f;
}

+(instancetype)gridViewWithStory:(SDStory*)story collectionView:(UICollectionView*)collectionView forIndexPath:(NSIndexPath*)indexPath{
    NSString* reuseIdentifier = BaseCellIdentifier;
    switch( story.type.intValue ){
        case SDStoryType_Text:
            reuseIdentifier = TextCellIdentifier;
            break;
        case SDStoryType_Photo:
            reuseIdentifier = PhotoCellIdentifier;
            break;
        case SDStoryType_Voice:
            reuseIdentifier = VoiceCellIdentifier;
            break;
        case SDStoryType_Event:
            reuseIdentifier = TextCellIdentifier;
            break;
        case SDStoryType_Storybook:
            reuseIdentifier = StoryBookCellIdentifier;
            break;
        case SDStoryType_Link:
            reuseIdentifier = TextCellIdentifier;
            break;
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

+(Class)classWithStory:(SDStory*)story{
    Class class = [SDBaseGridView class];
    switch( story.type.intValue ){
        case SDStoryType_Text:
            class = [SDTextGridView class];
            break;
        case SDStoryType_Photo:
            class = [SDPhotoGridView class];
            break;
        case SDStoryType_Voice:
            class = [SDVoiceGridView class];
            break;
        case SDStoryType_Event:
            class = [SDTextGridView class];
            break;
        case SDStoryType_Storybook:
            class = [SDStoryBookGridView class];
            break;
        case SDStoryType_Link:
            class = [SDTextGridView class];
            break;
    }
    
    return class;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self initBaseGridView];
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
    // Add like menu
    self.menuOverlay = [[GHContextMenuView alloc] init];
    self.menuOverlay.dataSource = self;
    self.menuOverlay.delegate = self;
    
    // Add Gesture recognizer
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    recognizer.direction =  UISwipeGestureRecognizerDirectionLeft;
    [recognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:recognizer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // BackgroundColor
    self.backgroundColor = [UIColor clearColor];
    
    // Shadow and round corner Effect
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 8.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowPath =  [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    
    self.mainContentView.layer.masksToBounds = TRUE;
    self.mainContentView.layer.cornerRadius = 8.0f;
    
    self.backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.story.imageName]];
    
    [self.shareButton setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:9];
    
    self.userButton.clipsToBounds = TRUE;
    self.userButton.layer.masksToBounds = TRUE;
    self.userButton.layer.cornerRadius = CGRectGetWidth(self.userButton.bounds) / 2;
    self.userButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.userButton.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    self.userButton.layer.shadowOpacity = 0.7f;
    self.userButton.layer.shadowPath =  [UIBezierPath bezierPathWithRoundedRect:self.userButton.bounds cornerRadius:self.userButton.layer.cornerRadius].CGPath;
    self.userButton.layer.borderWidth = 2;
    self.userButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.userButton setImage:[UIImage imageNamed:self.story.userIconName] forState:UIControlStateNormal];
    
    self.userNameLabel.text = self.story.userName;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"h:mm a";
    self.infoLabel.text = [NSString stringWithFormat:@"%@ at %@", [dateFormatter stringFromDate:self.story.date], self.story.address];
    
    NSInteger count = self.story.likeCount.intValue;
    NSString* string = count >= 1000 ? [NSString stringWithFormat:@"%ldk", count / 1000] : [NSString stringWithFormat:@"%ld", count];
    [self.likeButton setTitle:string forState:UIControlStateNormal];
    
    count = self.story.commentCount.intValue;
    string = count >= 1000 ? [NSString stringWithFormat:@"%ldk", count / 1000] : [NSString stringWithFormat:@"%ld", count];
    [self.commentButton setTitle:string forState:UIControlStateNormal];
    
}

- (void)prepareForReuse
{
    _menuState = SDGridMenuStateIdle;
    [self.origamiLayer removeFromSuperlayer];
    self.origamiLayer = nil;
    self.mainContentView.hidden = FALSE;
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    [self initBaseGridView];
}

#pragma mark -

- (void)handleSwipeGesture:(UISwipeGestureRecognizer*)gestureRecognizer
{
    UISwipeGestureRecognizer *recognizer = gestureRecognizer;
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionRight: {
            [self showTransitionWithImageView: self.mainContentView NumberOfFolds:3 Duration:0.4f Direction:SDMenuDirectionFromRight completion:^(BOOL finished) {
                    self.backgroundImageView.userInteractionEnabled = NO;
            }];
        }
            break;
        case UISwipeGestureRecognizerDirectionLeft:
        {
            [self hideTransitionWithImageView:self.mainContentView NumberOfFolds:3 Duration:0.4f Direction:SDMenuDirectionFromRight completion:^(BOOL finished) {
                self.backgroundImageView.image = [UIImage imageNamed:self.story.imageName];
                self.layer.shadowOpacity = 0.7f;
                self.backgroundImageView.userInteractionEnabled = YES;
                self.mainContentView.hidden = FALSE;
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
            self.backgroundImageView.image = [UIImage imageNamed:self.story.imageName];;
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

- (void)hideTransitionWithImageView:(UIView*)_view
                      NumberOfFolds:(NSInteger)folds
                           Duration:(CGFloat)duration
                          Direction:(SDMenuDirection)direction
                         completion:(void (^)(BOOL finished))completion
{

    if (_menuState != SDGridMenuStateShow) {
        return;
    }
    _menuState = SDGridMenuStateUpdate;
    
    [self.origamiLayer removeFromSuperlayer];
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
    self.origamiLayer.frame = view.bounds;
    self.origamiLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.origamiLayer.sublayerTransform = transform;
    self.origamiLayer.shadowColor = [UIColor blackColor].CGColor;
    self.origamiLayer.shadowOffset = CGSizeMake(3.0, 3.0);
    self.origamiLayer.shadowOpacity = 0.7f;
    
    [view.layer addSublayer:self.origamiLayer];
    
    //setup rotation angle
    double startAngle;
    CGFloat frameWidth = view.bounds.size.width;
    CGFloat frameHeight = view.bounds.size.height;
    CGFloat foldWidth = (direction < 2)?frameWidth/folds:frameHeight/folds;
    CALayer *prevLayer = self.origamiLayer;
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
        CATransformLayer *transLayer = [self transformLayerFromImage:self.viewSnapShot Frame:imageFrame fold:b Duration:duration AnchorPiont:anchorPoint StartAngle:startAngle EndAngle:0];
        [prevLayer addSublayer:transLayer];
        prevLayer = transLayer;
    }
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        self.frame = selfFrame;
        [self.origamiLayer removeFromSuperlayer];
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

- (void)showTransitionWithImageView:(UIView*)_view
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
    
//    if (imageView) {
//        // remove the image first
//        imageView.image = nil;
//    }
    self.mainContentView.hidden = TRUE;
    // remove the shadow
    view.layer.shadowOpacity = 0.0f;
    
    //set 3D depth
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/800.0;
    if (!self.origamiLayer)
        self.origamiLayer = [CALayer layer];
    self.origamiLayer.frame = view.bounds;
    self.origamiLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.origamiLayer.sublayerTransform = transform;
    
    self.origamiLayer.shadowColor = [UIColor blackColor].CGColor;
    self.origamiLayer.shadowOffset = CGSizeMake(3.0, 3.0);
    self.origamiLayer.shadowOpacity = 0.7f;
    
    [view.layer addSublayer:self.origamiLayer];
    
    //setup rotation angle
    double endAngle;
    CGFloat frameWidth = view.bounds.size.width;
    CGFloat frameHeight = view.bounds.size.height;
    CGFloat foldWidth = (direction < 2)?frameWidth/folds:frameHeight/folds;
    CALayer *prevLayer = self.origamiLayer;
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
        CATransformLayer *transLayer = [self transformLayerFromImage:self.viewSnapShot Frame:imageFrame fold:b Duration:duration AnchorPiont:anchorPoint StartAngle:0 EndAngle:endAngle];
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
    [self.menuOverlay showMenu];
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

-(void)setStory:(SDStory *)story{
    _story = story;
    
    [self setNeedsLayout];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return !_disableSwipeGesture;
}

@end
