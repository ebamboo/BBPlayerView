//
//  VideoTableViewCell.h
//  BBPlayerView
//
//  Created by ebamboo on 2021/3/26.
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

@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, copy) BOOL (^onShouldPlay)(void);

@property (nonatomic, assign) VideoTableViewCellStatus status;
- (void)tryPlay;
- (void)tryPause;

@end
