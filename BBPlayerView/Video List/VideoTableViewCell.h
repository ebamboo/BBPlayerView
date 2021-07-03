//
//  VideoTableViewCell.h
//  BBPlayerViewTest
//
//  Created by 征国科技 on 2021/3/26.
//

#import <UIKit/UIKit.h>
#import "BBPlayerView.h"

typedef NS_ENUM(NSInteger, VideoTableViewCellStatus) {
    VideoTableViewCellStatusUnknown       = 0,
    VideoTableViewCellStatusFailed        = 1,
    VideoTableViewCellStatusPlaying       = 2,
    VideoTableViewCellStatusPaused        = 3,
    VideoTableViewCellStatusPausedAtEnd   = 4
};

@interface VideoTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *dataURL;
- (void)bb_pause;
- (void)playWithWaitToPlayHandler:(void (^)(VideoTableViewCellStatus status))waitToPlayHandler;
@end
