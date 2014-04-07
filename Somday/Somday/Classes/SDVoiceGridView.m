//
//  SDVoiceGridView.m
//  Somday
//
//  Created by Freddy on 18/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "SDVoiceGridView.h"

#import <objc/runtime.h>

static const char* UIButton_AudioStateKey = "&#_UIButton_AudioStateKey_#&";

typedef NS_ENUM(NSUInteger, SDAudioState){
    SDAudioState_Play,
    SDAudioState_Stop,
};

@interface UIButton (Audio)

@property (nonatomic) SDAudioState audioState;

@end

@implementation UIButton (Audio)

-(SDAudioState)audioState{
    NSNumber* number = objc_getAssociatedObject(self, UIButton_AudioStateKey);
    return number.intValue;
}

-(void)setAudioState:(SDAudioState)audioState{
    NSNumber* number = [NSNumber numberWithInt:audioState];
    objc_setAssociatedObject(self, UIButton_AudioStateKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    switch( number.intValue ){
        case SDAudioState_Play:
            [self setBackgroundImage:[UIImage imageNamed:@"icons-shadow-24px_play"] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"icons-shadow-24px_play-bold"] forState:UIControlStateSelected];
            [self setBackgroundImage:[UIImage imageNamed:@"icons-shadow-24px_play-bold"] forState:UIControlStateHighlighted];
            break;
        case SDAudioState_Stop:
            [self setBackgroundImage:[UIImage imageNamed:@"icons-shadow-24px_stop"] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"icons-shadow-24px_stop-bold"] forState:UIControlStateSelected];
            [self setBackgroundImage:[UIImage imageNamed:@"icons-shadow-24px_stop-bold"] forState:UIControlStateHighlighted];
            break;
    }
}

@end

@interface SDVoiceGridView ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) IBOutlet UIButton* audioButton;
@property (nonatomic, strong) IBOutlet UILabel* timeLabel;
@property (nonatomic, strong) AVAudioPlayer* player;

@end

@implementation SDVoiceGridView

+ (CGFloat)heightForCell{
    return 152;
}

-(void)touchUpInside:(id)sender{
    [super touchUpInside:sender];
    
    if( [self.audioButton isEqual:sender] ){
        switch( self.audioButton.audioState ){
            case SDAudioState_Play:
            {
                NSString* filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.story.audioName];
                NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
                if( self.player && self.player.isPlaying ){
                    [self.player stop];
                }
                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
                self.player.delegate = self;
                [self.player play];
                self.audioButton.audioState = SDAudioState_Stop;
            }
                break;
            case SDAudioState_Stop:
                if( self.player && self.player.isPlaying ){
                    [self.player stop];
                    self.player = nil;
                }
                self.audioButton.audioState = SDAudioState_Play;
                break;
        }
    }
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    [self.player stop];
    self.player = nil;
}

-(void)dealloc{
    [self.player stop];
    self.player = nil;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    self.audioButton.audioState = SDAudioState_Play;
}

@end
