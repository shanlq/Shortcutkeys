//
//  ViewController.m
//  桌面快捷键
//
//  Created by apple on 17/7/5.
//  Copyright © 2017年 slq. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

//创建本地服务器
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

@interface ViewController ()

@property (nonatomic, strong) HTTPServer *httpServer;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ShortKeyOut"])
//        [self.navigationController pushViewController:[[SecondViewController alloc] init] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"第一个界面";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JumpToSecondVC) name:@"JumpToSecondVC" object:nil];
    
    self.addBtn.frame = CGRectMake(100, 100, 200, 40);
    [self.view addSubview:self.addBtn];
    
    
}

-(void)JumpToSecondVC
{
    [self.navigationController pushViewController:[[SecondViewController alloc] init] animated:YES];
}

-(void)AddShortCutKey
{
//    //1、使用外网服务器：将创建的含有快捷键相关信息的html文件放在外网上，则无论app处于什么状态都能够随时通过该html（快捷键）启动app。
//    //无需导入html文件
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://192.168.1.47:9090/sjtWeb/test.html"] options:@{} completionHandler:^(BOOL success) {
//        
//        if(success)
//            NSLog(@"打开网页成功");
//    }];
    
    
    
    //2、使用第三方库cocoaHttpServer创建临时的本地服务器，将html文件添加到本地链接中，则每次点击快捷键都是通过本地的服务器加载该html进而启动app。（但是因为本地服务器的创建是写在app中的，所以如果app被关闭则本地服务器也会被关闭，进而导致该html无法链接服务器即不会加载成功，进而不能启动app。所以这种方式可以用作测试，但是在正式使用时还是要将html放在外网上）
    //流程：1、导入core、vendor两个文件夹（选择Create Groups选项） 2、导入html文件（选择Create folder references选项，是将html放入工程的资源文件中）
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    _httpServer = [[HTTPServer alloc] init];
    [_httpServer setType:@"_http._tcp."];
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
    NSLog(@"Setting document root: %@", webPath);
    [_httpServer setDocumentRoot:webPath];
    
    NSError *error;
    if([_httpServer start:&error])
    {
        NSLog(@"Started HTTP Server on port %hu", [_httpServer listeningPort]);
        // open the url.
        NSString *urlStrWithPort = [NSString stringWithFormat:@"http://localhost:%d",[_httpServer listeningPort]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStrWithPort] options:@{} completionHandler:^(BOOL success) {
            NSLog(@"通过本地服务器打开网页成功");
        }];
    }
    else
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}

-(UIButton *)addBtn
{
    if(!_addBtn)
    {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"点击添加快捷键到桌面" forState:UIControlStateNormal];
        [_addBtn setBackgroundColor:[UIColor blueColor]];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(AddShortCutKey) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
