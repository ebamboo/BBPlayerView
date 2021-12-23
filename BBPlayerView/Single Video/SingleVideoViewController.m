//
//  SingleVideoViewController.m
//  BBPlayerView
//
//  Created by ebamboo on 2021/3/27.
//

#import "SingleVideoViewController.h"
#import "BBPlayerView.h"

@interface SingleVideoViewController () <BBPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *URLField;
@property (weak, nonatomic) IBOutlet UITextField *progressField;
@property (weak, nonatomic) IBOutlet UISwitch *loopSwitch;

@property (weak, nonatomic) IBOutlet BBPlayerView *playerView;

@end

@implementation SingleVideoViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单个视频";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - actions

- (IBAction)loadData:(id)sender {
    [_playerView bb_loadDataWithURL:_URLField.text];
}

- (IBAction)releasePlayer:(id)sender {
    [_playerView bb_release];
}

- (IBAction)testURLAction:(UIButton *)sender {
    if (sender.tag == 0) {
        _URLField.text = @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/983aa2af387702293313925640/j6qit3Ub0hsA.mp4";
    }
    if (sender.tag == 1) {
        _URLField.text = @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/91277451387702293313612892/Vi7xh7EbzNgA.mp4";
    }
}

- (IBAction)play:(id)sender {
    [_playerView bb_play];
}

- (IBAction)pause:(id)sender {
    [_playerView bb_pause];
}

- (IBAction)seekToProgress:(id)sender {
    [_playerView bb_seekToProgress:[_progressField.text floatValue] completionHandler:nil];
}

- (IBAction)replay:(id)sender {
    __weak typeof(self) weakSelf = self;
    [_playerView bb_seekToProgress:0.0 completionHandler:^(BOOL finished) {
        if (finished) {
            [weakSelf.playerView bb_play];
        }
    }];
}

#pragma mark - BBPlayerViewDelegate

- (void)bb_playerView:(nullable BBPlayerView *)playerView progressDidUpdatedAtTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime progress:(CGFloat)progress {
    if (progress >= 1.0) {
        if (_loopSwitch.isOn) {
            [self replay:nil];
        }
    }
}

- (void)bb_playerView:(nullable BBPlayerView *)playerView statusDidUpdated:(BBPlayerViewStatus)status {
    NSLog(@"status = %@", @(status));
}

- (void)bb_playerView:(nullable BBPlayerView *)playerView didPreloadData:(CGFloat)startTime durationTime:(CGFloat)durationTime totalLoadedTime:(CGFloat)totalLoadedTime totalTime:(CGFloat)totalTime {
    
}

@end
