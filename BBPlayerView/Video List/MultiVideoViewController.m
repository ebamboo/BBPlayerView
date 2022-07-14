//
//  MultiVideoViewController.m
//  BBPlayerView
//
//  Created by ebamboo on 2021/3/26.
//

#import "MultiVideoViewController.h"
#import "VideoTableViewCell.h"
#import "BBPlayerViewCellManager.h"

@interface MultiVideoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *urlList;
@property (nonatomic, retain, readonly) NSIndexPath *middleIndexPath; // 列表中间的 indexPath，可能为空

@end

@implementation MultiVideoViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频列表";
    [_tableView registerNib:[UINib nibWithNibName:@"VideoTableViewCell" bundle:nil] forCellReuseIdentifier:@"VideoTableViewCell"];
    _urlList = @[
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/940cd45e387702293313791879/dmEhMtMnuVAA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/8c6ec7b4387702293313409297/Sb2hYSuZFmEA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/914c2930387702293313633690/5cQsulaDJdAA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/940cc311387702293313791452/u2obyyGb9UgA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/983a8db3387702293313925167/fifw6tY3JaIA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/940cbaf7387702293313791287/xSxS1l5Uv3gA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/91706617387702293313653929/8ZpVnppBd8cA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/9127736a387702293313612822/51veatWYqEwA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/914c35f5387702293313633992/dGevkJOtPHgA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/983aa2af387702293313925640/j6qit3Ub0hsA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/9127e686387702293313613241/H29zZmHGlAQA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/940cc794387702293313791572/xGa6eGGlnDkA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/91277451387702293313612892/Vi7xh7EbzNgA.mp4",
        @"http://1257982215.vod2.myqcloud.com/dcd3428cvodcq1257982215/983aa6af387702293313925721/L4Wf5oM7q1QA.mp4",
    ];
    
}

- (NSIndexPath *)middleIndexPath {
    return [_tableView indexPathForRowAtPoint:CGPointMake(_tableView.frame.size.width/2, _tableView.contentOffset.y + _tableView.frame.size.height/2)];
}

- (void)tryPlayMiddelVideo {
    if (self.middleIndexPath) {
        VideoTableViewCell *cell = [_tableView cellForRowAtIndexPath:self.middleIndexPath];
        [cell tryPlay];
    }
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
    cell.videoURL = _urlList[indexPath.section];
    __unsafe_unretained typeof(self) unsafeself = self;
    cell.onShouldPlay = ^BOOL{
        return unsafeself.middleIndexPath && (unsafeself.middleIndexPath.section == indexPath.section) && !PlayerViewCellManager.shared.someOneIsPlaying;
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - scroll view：scrollView 从运动状态变换到静止状态

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self tryPlayMiddelVideo];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self tryPlayMiddelVideo];
}

@end
