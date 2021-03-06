//
//  WonderMovieDownloadController.m
//  WonderMoviePlayer
//
//  Created by Zhuang Yanjun on 2/3/14.
//  Copyright (c) 2014 Tencent. All rights reserved.
//

#import "WonderMovieDownloadController.h"
#import "TVDramaManager.h"
#import "UIView+Sizes.h"
#import "WonderMoviePlayerConstants.h"
#import "VideoModels.h"

@interface WonderMovieDownloadController ()<UIActionSheetDelegate> {
    BOOL _supportBatchDownload;
}
@end

@implementation WonderMovieDownloadController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTVDramaManager:(TVDramaManager *)tvDramaManager batMovieDownloader:(id<BatMovieDownloader>)batMovieDownloader
{
    if (self = [super init]) {
        self.tvDramaManager = tvDramaManager;
        self.batMovieDownloader = batMovieDownloader;
        _supportBatchDownload = YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"选择视频";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClickCancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDownload:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    CGFloat footerHeight = 44;
    WonderMovieDownloadView *downloadView = [[WonderMovieDownloadView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - footerHeight)];
    downloadView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    downloadView.tvDramaManager = self.tvDramaManager;
    downloadView.delegate = self;
    self.downloadView = downloadView;
    self.downloadView.supportBatchDownload = _supportBatchDownload;
    self.downloadView.backgroundColor = [UIColor clearColor];
    self.downloadView.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:downloadView];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, downloadView.bottom, self.view.width, footerHeight)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    footerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1]; // FIXME
    footerView.clipsToBounds = YES;
    [self.view addSubview:footerView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, footerView.width - 10, footerView.height)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.textAlignment = UITextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"可用空间0G";
    self.availableSpaceLabel = label;
    [footerView addSubview:label];
    
    if (self.tvDramaManager.clarityCount > 0) {
        NSArray *resoultions = @[@"流畅", @"标清", @"高清", @"蓝光"];
        if (self.tvDramaManager.clarityCount < resoultions.count) {
            resoultions = [resoultions subarrayWithRange:NSMakeRange(0, self.tvDramaManager.clarityCount)];
        }
        self.resolutions = resoultions;
        
        UIButton *clarityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clarityButton setTitle:resoultions[0] forState:UIControlStateNormal];
        [clarityButton addTarget:self action:@selector(onClickClarity:) forControlEvents:UIControlEventTouchUpInside];
        clarityButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        clarityButton.frame = CGRectMake(footerView.width - 60, 0, 60, footerHeight);
        [clarityButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        clarityButton.titleLabel.font = [UIFont systemFontOfSize:13];
        self.clarityButton = clarityButton;
        
        [footerView addSubview:clarityButton];
    }
    
    [self.downloadView reloadData];
    [self.downloadView scrollToThePlayingOne];
    [self updateAvailableSpace];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.downloadView.tableView beginUpdates];
    [self.downloadView.tableView reloadRowsAtIndexPaths:self.downloadView.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.downloadView.tableView endUpdates];
}

#pragma mark WonderMovieDownloadViewDelegate
- (void)wonderMovieDownloadViewDidCancel:(WonderMovieDownloadView *)downloadView
{
		
}

- (void)wonderMovieDownloadView:(WonderMovieDownloadView *)downloadView didDownloadVideos:(NSArray *)videos
{
    [self startBatDownload:videos];
}

- (void)wonderMovieDownloadView:(WonderMovieDownloadView *)downloadView didChangeSelectedVideos:(NSArray *)videos
{
    self.navigationItem.rightBarButtonItem.enabled = videos.count > 0;
}

#pragma mark Action
- (IBAction)onClickCancel:(id)sender
{
    [self.downloadView cancel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickDownload:(id)sender
{
    AddStatWithKey(VideoStatKeyDownloadInBatch);
    [self.downloadView confirm];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickClarity:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    for (NSString *res in self.resolutions) {
        [sheet addButtonWithTitle:res];
    }
    [sheet addButtonWithTitle:@"ÂèñÊ∂à"];
    sheet.delegate = self;
    [sheet showInView:self.view];
}

- (void)startBatDownload:(NSArray *)videos
{
    if (self.tvDramaManager.videoGroup == nil) {
        return;
    }
    
    __block NSMutableArray *downloadURLs = [NSMutableArray array];
    __block NSMutableDictionary *titleDict = [NSMutableDictionary dictionaryWithCapacity:downloadURLs.count];
    __block NSMutableDictionary *knownVideoSourceDict = [NSMutableDictionary dictionaryWithCapacity:1];

    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        VideoGroup *videoGroup = [self.tvDramaManager.videoGroup MR_inContext:localContext];
        
        for (NSNumber *setNum in videos) {
            Video *video = [videoGroup videoAtSetNum:setNum];
            NSString *downloadURL = [video webURLAtSrcIndex:self.tvDramaManager.srcIndex];
            
            if (downloadURL == nil) {
                downloadURL = @"";
                NSLog(@"Warnning: Start to download with nil webURL %@", video);
            }
            
            [downloadURLs addObject:downloadURL];
            titleDict[downloadURL] = [video displayName];
            
            [video saveCreateTimeInContext:localContext];
            
            /**
             * downloadURL is provided by server side drama info
             * webURL is the current playing web page url, it might contains some subfix
             * example:
             * downloadURL: http://m.v.qq.com/cover/3/3b9b76xc1vdwide.html?vid=d0013jdh2nm
             * webURL:      http://m.v.qq.com/cover/3/3b9b76xc1vdwide.html?vid=d0013jdh2nm&ptag=qqbrowser.tv%23v.play.adaptor%231&mreferrer=http%3A%2F%2Fv.html5.qq.com%2F
             **/
            if ([self.tvDramaManager.webURL hasPrefix:downloadURL] && self.tvDramaManager.playingURL.length > 0) {
                knownVideoSourceDict[downloadURL] = self.tvDramaManager.playingURL;
            }
        }
    }];

    [self.batMovieDownloader batchDownloadURLs:downloadURLs titles:titleDict knownVideoSources:knownVideoSourceDict clarity:_currentClarity];
}

#pragma mark Public
- (void)setSupportBatchDownload:(BOOL)supportBatchDownload
{
    _supportBatchDownload = supportBatchDownload;
}

#pragma mark Utils
- (void)updateAvailableSpace
{
    uint64_t space = [self getFreeDiskspace];
    if (space < 1024 * 1024 * 1024) {
        self.availableSpaceLabel.text = [NSString stringWithFormat:@"可用空间%.1fM", space / 1024. / 1024];
    }
    else {
        self.availableSpaceLabel.text = [NSString stringWithFormat:@"可用空间%.1fG", space / 1024. / 1024 / 1024];
    }
}

- (uint64_t)getFreeDiskspace
{
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
//        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d", [error domain], [error code]);
    }
    return totalFreeSpace;
}

- (void)selectClarity:(NSInteger)clarity
{
    if (clarity < self.resolutions.count && clarity >= 0) {
        _currentClarity = clarity;
        [self.clarityButton setTitle:self.resolutions[_currentClarity] forState:UIControlStateNormal];
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self selectClarity:buttonIndex];
}

@end
