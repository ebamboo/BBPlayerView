//
//  VideoTableViewCell.m
//  BBPlayerView
//
//  Created by ebamboo on 2021/3/26.
//

#import "VideoTableViewCell.h"
#import "PlayerViewCellManager.h"

@interface VideoTableViewCell () <BBPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet BBPlayerView *playerView;

@property (weak, nonatomic) IBOutlet UIView *interfaceView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *operationBtn;

@end

@implementation VideoTableViewCell

#pragma mark - basic

- (void)awakeFromNib {
    [super awakeFromNib];
    _playerView.bb_delegate = self;
    _playerView.bb_videoGravity = BBPlayerViewGravityAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_playerView bb_release];
    [PlayerViewCellManager.shared removeCell:self];
    self.status = VideoTableViewCellStatusUnknown;
}

#pragma mark - public method

- (void)setVideoURL:(NSString *)videoURL {
    _videoURL = videoURL;
    [_playerView bb_loadDataWithURL:videoURL];
}

// 只修改相应的 UI
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

- (void)tryPlay {
    if (_status == VideoTableViewCellStatusPaused) {
        [PlayerViewCellManager.shared pauseAllCells];
        [_playerView bb_play];
        self.status = VideoTableViewCellStatusPlaying;
        [PlayerViewCellManager.shared addCell:self];
    }
}

- (void)tryPause {
    if (_status == VideoTableViewCellStatusPlaying) {
        [_playerView bb_pause];
        self.status = VideoTableViewCellStatusPaused;
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
        [_playerView bb_loadDataWithURL:_videoURL];
        self.status = VideoTableViewCellStatusUnknown;
        return;
    }
    if (status == VideoTableViewCellStatusPlaying) {
        NSLog(@"按钮操作--暂停");
        [_playerView bb_pause];
        self.status = VideoTableViewCellStatusPaused;
        return;
    }
    if (status == VideoTableViewCellStatusPaused) {
        NSLog(@"按钮操作--播放");
        [PlayerViewCellManager.shared pauseAllCells];
        [_playerView bb_play];
        self.status = VideoTableViewCellStatusPlaying;
        [PlayerViewCellManager.shared addCell:self];
        return;
    }
    if (status == VideoTableViewCellStatusPausedAtEnd) {
        NSLog(@"按钮操作--重播");
        __weak typeof(self) weakSelf = self;
        [_playerView bb_seekToProgress:0.0 completionHandler:^(BOOL finished) {
            if (finished) {
                [PlayerViewCellManager.shared pauseAllCells];
                [weakSelf.playerView bb_play];
                weakSelf.status = VideoTableViewCellStatusPlaying;
                [PlayerViewCellManager.shared addCell:weakSelf];
            }
        }];
        return;
    }
}

#pragma mark - BBPlayerViewDelegate

- (void)bb_playerView:(nullable BBPlayerView *)playerView progressDidUpdatedAtTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime progress:(CGFloat)progress {
    NSLog(@"播放进度：(%.0f, %.0f, %.0f%%)", currentTime, totalTime, progress * 100);
    if (progress >= 1.0) {
        self.status = VideoTableViewCellStatusPausedAtEnd;
    }
}

- (void)bb_playerView:(nullable BBPlayerView *)playerView statusDidUpdated:(BBPlayerViewStatus)status {
    if (status == BBPlayerViewStatusUnknown) {
        self.status = VideoTableViewCellStatusUnknown;
    }
    if (status == BBPlayerViewStatusFailed) {
        self.status = VideoTableViewCellStatusFailed;
    }
    if (status == BBPlayerViewStatusReadyToPlay) {
        if (_onShouldPlay()) {
            [PlayerViewCellManager.shared pauseAllCells];
            [_playerView bb_play];
            self.status = VideoTableViewCellStatusPlaying;
            [PlayerViewCellManager.shared addCell:self];
        } else {
            [_playerView bb_pause];
            self.status = VideoTableViewCellStatusPaused;
        }
    }
}

- (void)bb_playerView:(nullable BBPlayerView *)playerView didPreloadData:(CGFloat)startTime durationTime:(CGFloat)durationTime totalLoadedTime:(CGFloat)totalLoadedTime totalTime:(CGFloat)totalTime {
    
}

@end
