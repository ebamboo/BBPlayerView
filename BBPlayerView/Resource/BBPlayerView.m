//
//  BBPlayerView.m
//  BBCommonKits
//
//  Created by 征国科技 on 2021/3/24.
//

#import "BBPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface BBPlayerView ()
@property (nonatomic, retain, nullable) AVPlayerItem *playerItem;
@property (nonatomic, retain, nullable) AVPlayer *player;
@property (nonatomic, retain, nonnull) AVPlayerLayer *playerLayer;
@end

@interface BBPlayerView ()
@property (nonatomic, copy, nullable) NSString *url;
@property (nonatomic, retain, nullable) id timeObserver;
@end

@implementation BBPlayerView

#pragma mark - life circle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:nil];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer insertSublayer:_playerLayer atIndex:0];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _playerLayer.frame = self.layer.bounds;
    [CATransaction commit];
}

- (void)dealloc {
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_player removeTimeObserver:_timeObserver];
}

#pragma mark - public method

- (void)bb_loadDataWithURL:(NSString *)url {
    if ([_url isEqualToString:url] && _playerItem.status == AVPlayerItemStatusReadyToPlay) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 清理释放资源
        [weakSelf bb_release];
        // 加载新资源
        weakSelf.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
        [weakSelf.playerItem addObserver:weakSelf forKeyPath:@"status" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [weakSelf.playerItem addObserver:weakSelf forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        weakSelf.player = [AVPlayer playerWithPlayerItem:weakSelf.playerItem];
        weakSelf.playerLayer.player = weakSelf.player;
        // 标记量
        weakSelf.timeObserver = [weakSelf.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            [weakSelf updateProgress:time];
        }];
        weakSelf.url = url;
    });
}

- (void)bb_release {
    _url = nil;
    [_player removeTimeObserver:_timeObserver];
    _timeObserver = nil;
    
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    _playerItem = nil;
    [_player pause];
    _player = nil;
    _playerLayer.player = nil;
    [_playerLayer setHidden:YES];
}

- (void)bb_play {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{ // 可以保证在创建 player 之后调用播放功能，比如刚调用 -bb_loadDataWithURL 方法就调用本方法，不会使命令无效。
        [weakSelf.player play];
    });
}

- (void)bb_pause {
    [_player pause];
}

- (void)bb_seekToProgress:(CGFloat)progress completionHandler:(void (^)(BOOL finished))completionHandler {
    if (progress < 0.0) {
        progress = 0.0;
    }
    if (progress > 1.0) {
        progress = 1.0;
    }
    CGFloat value = _playerItem.duration.value * progress;
    CGFloat timescale = _playerItem.duration.timescale;
    CMTime time = CMTimeMake(value, timescale);
    [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if (completionHandler) {
            completionHandler(finished);
        }
    }];
}

#pragma mark - 信息回调

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{ // 保证可能的 UI 刷新在主线程中
        // 播放状态回调
        if ([keyPath isEqualToString:@"status"]) {
            NSNumber *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
            NSNumber *newValue = [change objectForKey:NSKeyValueChangeNewKey];
            // 调用 seekToTime 方法可能会导致新旧值相同情况下 setting 操作
            // 确保状态值真的变化之后进行回调
            if (![oldValue isEqualToNumber:newValue]) {
                if(weakSelf.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                    [weakSelf.playerLayer setHidden:NO];
                }
                if (weakSelf.bb_delegate && [weakSelf.bb_delegate respondsToSelector:@selector(bb_playerViewStatusDidUpdated:)]) {
                    [weakSelf.bb_delegate bb_playerViewStatusDidUpdated:(BBPlayerViewStatus)weakSelf.playerItem.status];
                }
            }
        }
        // 预加载回调
        if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            CMTimeRange timeRange = [weakSelf.playerItem.loadedTimeRanges.firstObject CMTimeRangeValue];
            CGFloat startTime = CMTimeGetSeconds(timeRange.start);
            CGFloat durationTime = CMTimeGetSeconds(timeRange.duration);
            CGFloat totalLoadedTime = startTime + durationTime;
            CGFloat totalTime = CMTimeGetSeconds(weakSelf.playerItem.duration);
            if (weakSelf.bb_delegate && [weakSelf.bb_delegate respondsToSelector:@selector(bb_playerViewDidPreloadData:durationTime:totalLoadedTime:totalTime:)]) {
                [weakSelf.bb_delegate bb_playerViewDidPreloadData:startTime durationTime:durationTime totalLoadedTime:totalLoadedTime totalTime:totalTime];
            }
        }
    });
}

// 播放进度回调
- (void)updateProgress:(CMTime)time {
    if (_playerItem.status == AVPlayerItemStatusReadyToPlay) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        CGFloat totalTime = CMTimeGetSeconds(_playerItem.duration);
        CGFloat progress = currentTime / totalTime;
        if (progress > 1.0) { // 实际测试中发现 currentTime 在结束时可能大于 totalTime，可能计时器不准确造成的
            progress = 1.0;
        }
        if (_bb_delegate && [_bb_delegate respondsToSelector:@selector(bb_playerViewProgressDidUpdatedAtTime:totalTime:progress:)]) {
            [_bb_delegate bb_playerViewProgressDidUpdatedAtTime:currentTime totalTime:totalTime progress:progress];
        }
    }
}

@end
