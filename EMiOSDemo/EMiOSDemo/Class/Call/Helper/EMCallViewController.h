//
//  EMCallViewController.h
//  ChatDemo-UI3.0
//
//  Created by XieYajie on 2018/9/19.
//  Copyright © 2018 XieYajie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EMButton.h"

static bool isHeadphone()
{
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    
    return NO;
}

@interface EMCallViewController : UIViewController


@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) EMButton *microphoneButton;
@property (nonatomic, strong) EMButton *speakerButton;

@property (nonatomic, strong) UIButton *hangupButton;
@property (nonatomic, strong) UIButton *minButton;

- (void)microphoneButtonAction;

- (void)speakerButtonAction;

- (void)minimizeAction;

- (void)hangupAction;

@end
