//
//  ViewController.m
//  YWFilePreviewDemo
//
//  Created by dyw on 2017/3/16.
//  Copyright © 2017年 dyw. All rights reserved.
//

#import "ViewController.h"
#import "YWFilePreviewController.h"
#import "YWFilePreviewView.h"
#import <AFNetworking.h>
//#import <SVProgressHUD.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    
}


- (IBAction)filePreviewButtonClick:(id)sender {
    
//    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"1.xlsx" ofType:nil ];
//    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"2.docx" ofType:nil ];
//    NSString *filePath3 = [[NSBundle mainBundle] pathForResource:@"3.ppt" ofType:nil ];
//    NSString *filePath4 = [[NSBundle mainBundle] pathForResource:@"4.pdf" ofType:nil ];
//    NSString *filePath5 = [[NSBundle mainBundle] pathForResource:@"5.png" ofType:nil ];
//    NSArray *filePathArr = @[filePath2,filePath1, filePath3, filePath4, filePath5];
//
//    YWFilePreviewController *_filePreview = [[YWFilePreviewController alloc] init];
//    [_filePreview previewFileWithPaths:filePathArr on:self jump:YWJumpPresentAnimat];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString *urlStr = @"http://113.62.127.199:8090/fileUpload/1.docx";
    NSString *fileName = [urlStr lastPathComponent]; //获取文件名称
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    YWFilePreviewController *_filePreview = [[YWFilePreviewController alloc] init];
//    UIViewController *vc = [ViewController dc_findCurrentShowingViewController];
    
    //判断是否存在
    if([self isFileExist:fileName]) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        
        // 下载完成
        NSArray *filePathArr = @[url.path];
        [_filePreview previewFileWithPaths:filePathArr on:self jump:YWJumpPresentAnimat];
    }else {
//        [SVProgressHUD showWithStatus:@"下载中"];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
            
        } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
            return url;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//            [SVProgressHUD dismiss];
            
            // 下载完成
            NSArray *filePathArr = @[filePath.path];
            [_filePreview previewFileWithPaths:filePathArr on:self jump:YWJumpPresentAnimat];

        }];
        [downloadTask resume];
    }
}

- (IBAction)filePreviewSimpleness:(id)sender {
    NSString *filePath4 = [[NSBundle mainBundle] pathForResource:@"4.pdf" ofType:nil ];

    [YWFilePreviewView previewFileWithPaths:filePath4];
    
}

// 判断文件是否已经在沙盒中存在
-(BOOL) isFileExist:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

// 获取当前显示的 UIViewController
+ (UIViewController *)dc_findCurrentShowingViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].windows[0].rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}
+ (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc
{
    // 递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) {
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];

    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];

    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];

    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }

    return currentShowingVC;
}

@end
