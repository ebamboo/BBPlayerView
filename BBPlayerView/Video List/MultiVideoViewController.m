//
//  MultiVideoViewController.m
//  BBPlayerView
//
//  Created by ebamboo on 2021/3/26.
//

#import "MultiVideoViewController.h"
#import "VideoTableViewCell.h"
#import "VideoUrl.h"

@interface MultiVideoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *urlList;
@property (nonatomic, retain) NSIndexPath *playingIndexPath;

@end

@implementation MultiVideoViewController

#pragma mark - life circle

- (void)dealloc {
    [BBPlayerViewCellManager.bb_manager removeAllCells];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频列表";
//    _urlList = @[
//        url01, url02, url03, url04,
//        url05, url06, url07, url08,
//        url09, url10, url11, url12,
//        url13, url14, url15, url16
//    ];
    _urlList = @[
        @"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4",
        @"https://vod.kuama.tv/8319a8f1e8bb45f480bb5e4fe94535e2/adcf8f344dcb42e4829e2e08f027badc-d3b97a7995e831d445ce5cc9994c603e-sd.mp4",
        @"https://vod.kuama.tv/23e05338920f4c668c8f0ef8d4994ba2/d556bb6e83c44350a24f15c80c4b67b7-21b1c4a9f565a93a071d802ab1a64b20-sd.mp4",
        @"https://vod.kuama.tv/5cba136e27b5497ead5a21c9391760dd/abe6a1a51f3b4cb9a57d365ab7534e01-7f11e7f690efa6ba85e053ef718f4ddf-sd.mp4",
        @"https://vod.kuama.tv/8635aa26eb1f46579c22f6f69e271c0a/ed92786e4aed410db862d559a12fc83b-3fb0f3f7d44270e5e3cfb22137939ce2-sd.m3u8",
        @"https://vod.kuama.tv/94022f01984949f28cb675a2c0b77525/a8eedb054aa149ddbafbf0520c22ca62-96d898e0fd23087f3e353bf246adc583-sd.m3u8",
        @"https://vod.kuama.tv/07f1a82c59b246db984646ce1c394351/1ea4c94e0f60475d8ef466aeef1bb651-648e7cb6e53873efdf34b4b081c94f19-sd.m3u8",
        @"https://vod.kuama.tv/ddb2c7db7f884d3daf415cd39f6f47cd/e3fea60867bf45f0bdcad6b3a8867812-688355250db8711644e696a347301a9c-sd.mp4",
        @"https://vod.kuama.tv/67f0b5d0c5d94de0816c44b3b36a9fc8/f9fb991a35f64432b905e479503ddcaa-66e543fbe4d660e95701dfe89f8757a6-sd.mp4",
        @"https://vod.kuama.tv/654db77c45d8442193d4f62738933eee/6a2f561366ae4f09b0616ac496055384-6d83f0348b879121f04910968a73482c-sd.mp4",
        @"https://vod.kuama.tv/43764eb8641e47d09f10e9907ebc1d8c/fa96f7b3ab3342a78dc90863e90fce42-504327a4286ca348361f25aa7acfa21b-sd.mp4"
    ];
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [_tableView registerNib:[UINib nibWithNibName:@"VideoTableViewCell" bundle:nil] forCellReuseIdentifier:@"VideoTableViewCell"];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _urlList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 280;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCell"];
    cell.dataURL = _urlList[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        UITableView *tableView = (UITableView *)scrollView;
        NSIndexPath *middleIndexPath = [tableView indexPathForRowAtPoint:CGPointMake(tableView.frame.size.width/2, tableView.contentOffset.y + tableView.frame.size.height/2)];
        _playingIndexPath = middleIndexPath;
        [self playVideoOnCell:middleIndexPath];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UITableView *tableView = (UITableView *)scrollView;
    NSIndexPath *middleIndexPath = [tableView indexPathForRowAtPoint:CGPointMake(tableView.frame.size.width/2, tableView.contentOffset.y + tableView.frame.size.height/2)];
    _playingIndexPath = middleIndexPath;
    [self playVideoOnCell:middleIndexPath];
}

#pragma mark - 滑动结束播放居中视频

- (void)playVideoOnCell:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    __weak typeof(cell) weakCell = cell;
    [cell playWithWaitToPlayHandler:^(VideoTableViewCellStatus status) {
        if (status == VideoTableViewCellStatusUnknown) {
            NSLog(@"加载中");
        }
        if (status == VideoTableViewCellStatusFailed) {
            NSLog(@"加载失败");
        }
        if (status == VideoTableViewCellStatusPaused) {
            [weakCell playWithWaitToPlayHandler:nil];
        }
    }];
}

@end
