//
//  VideoTableViewCell.m
//  BBPlayerViewTest
//
//  Created by ebamboo on 2021/3/26.
//

#import "VideoTableViewCell.h"

@interface VideoTableViewCell () <BBPlayerViewDelegate, BBPlayerViewCellManagerDelegate>
@property (weak, nonatomic) IBOutlet BBPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIView *interfaceView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *operationBtn;

@property (nonatomic, assign) VideoTableViewCellStatus status;
@property (nonatomic, copy) void (^waitToPlayHandler)(VideoTableViewCellStatus status);
@end

@implementation VideoTableViewCell

#pragma mark - basic

- (void)awakeFromNib {
    [super awakeFromNib];
    _playerView.bb_delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_playerView bb_release];
    _waitToPlayHandler = nil;
    [BBPlayerViewCellManager.bb_manager removeCell:self];
    [self setStatus:VideoTableViewCellStatusUnknown];
}

- (void)setStatus:(VideoTableViewCellStatus)status {
    _status = status;
    if (status == VideoTableViewCellStatusUnknown) {
        _statusLabel.text = @"状态：加载中";
        [_operationBtn setTitle:@"可用操作：无操作" forState:UIControlStateNormal];
        return;
    }
    if (status == VideoTableViewCellStatusFailed) {
        _statusLabel.text = @"状态：失败状态中";
        [_operationBtn setTitle:@"可用操作：重新加载资源" forState:UIControlStateNormal];
        return;
    }
    if (status == VideoTableViewCellStatusPlaying) {
        _statusLabel.text = @"状态：播放中";
        [_operationBtn setTitle:@"可用操作：暂停" forState:UIControlStateNormal];
        return;
    }
    if (status == VideoTableViewCellStatusPaused) {
        _statusLabel.text = @"状态：暂停中";
        [_operationBtn setTitle:@"可用操作：播放" forState:UIControlStateNormal];
        return;
    }
    if (status == VideoTableViewCellStatusPausedAtEnd) {
        _statusLabel.text = @"状态：播放结束";
        [_operationBtn setTitle:@"可用操作：重播" forState:UIControlStateNormal];
        return;
    }
}

#pragma mark - public method

- (void)setDataURL:(NSString *)dataURL {
    _dataURL = dataURL;
    [_playerView bb_loadDataWithURL:dataURL];
}

- (void)bb_pause {
    if (_status == VideoTableViewCellStatusPlaying) {
        [_playerView bb_pause];
        [self setStatus:VideoTableViewCellStatusPaused];
    }
}

- (void)playWithWaitToPlayHandler:(void (^)(VideoTableViewCellStatus status))waitToPlayHandler {
    [BBPlayerViewCellManager.bb_manager pauseAllCellPlayers];
    if (_status == VideoTableViewCellStatusUnknown) {
        _waitToPlayHandler = waitToPlayHandler;
        return;
    }
    if (_status == VideoTableViewCellStatusFailed) {
        return;
    }
    if (_status == VideoTableViewCellStatusPlaying) {
        return;
    }
    if (_status == VideoTableViewCellStatusPaused) {
        [BBPlayerViewCellManager.bb_manager addCell:self];
        [_playerView bb_play];
        [self  setStatus:VideoTableViewCellStatusPlaying];
        return;
    }
    if (_status == VideoTableViewCellStatusPausedAtEnd) {
        return;
    }
}

#pragma mark - 操作事件

- (IBAction)operationAction:(UIButton *)sender {
    VideoTableViewCellStatus status = _status;
    if (status == VideoTableViewCellStatusUnknown) {
        NSLog(@"按钮操作--无");
        return;
    }
    if (status == VideoTableViewCellStatusFailed) {
        NSLog(@"按钮操作--重新加载资源");
        [_playerView bb_loadDataWithURL:_dataURL];
        return;
    }
    if (status == VideoTableViewCellStatusPlaying) {
        NSLog(@"按钮操作--暂停");
        [self bb_pause];
        return;
    }
    if (status == VideoTableViewCellStatusPaused) {
        NSLog(@"按钮操作--播放");
        [self playWithWaitToPlayHandler:nil];
        return;
    }
    if (status == VideoTableViewCellStatusPausedAtEnd) {
        NSLog(@"按钮操作--重播");
        __weak typeof(self) weakSelf = self;
        [_playerView bb_seekToProgress:0.0 completionHandler:^(BOOL finished) {
            [weakSelf setStatus:VideoTableViewCellStatusPaused];
            [weakSelf playWithWaitToPlayHandler:nil];
        }];
        return;
    }
}

#pragma mark - BBPlayerViewDelegate

- (void)bb_playerView:(nullable BBPlayerView *)playerView progressDidUpdatedAtTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime progress:(CGFloat)progress {
    NSLog(@"====== (%.0f, %.0f, %.0f%%)", currentTime, totalTime, progress * 100);
    if (progress >= 1.0) {
        [self setStatus:VideoTableViewCellStatusPausedAtEnd];
    }
}

- (void)bb_playerView:(nullable BBPlayerView *)playerView statusDidUpdated:(BBPlayerViewStatus)status {
    if (status == BBPlayerViewStatusUnknown) {
        [self setStatus:VideoTableViewCellStatusUnknown];
    }
    if (status == BBPlayerViewStatusFailed) {
        [self setStatus:VideoTableViewCellStatusFailed];
    }
    if (status == BBPlayerViewStatusReadyToPlay) {
        [self setStatus:VideoTableViewCellStatusPaused];
    }
    if (_waitToPlayHandler) {
        _waitToPlayHandler(_status);
    }
}

- (void)bb_playerView:(nullable BBPlayerView *)playerView didPreloadData:(CGFloat)startTime durationTime:(CGFloat)durationTime totalLoadedTime:(CGFloat)totalLoadedTime totalTime:(CGFloat)totalTime {
    
}

@end
