//
//  RootViewController.m
//  KuaishouFresh
//
//  Created by lly on 2017/4/13.
//  Copyright © 2017年 lly. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIImageView *freshImageView;

@property (nonatomic,assign) BOOL isFreshing;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"刷新动画";
    [self.mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.isFreshing = NO;
    
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 64)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.mTableView addSubview:self.headerView];
    
    self.freshImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.freshImageView.image = [UIImage imageNamed:@"refresh_camera_frame1"];
    
    [self.headerView addSubview:_freshImageView];
    self.freshImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 32);
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 60;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor redColor];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offsetY = scrollView.contentOffset.y;
    
    NSLog(@"offset = %f",offsetY);
    
    if (self.isFreshing) {
        scrollView.contentOffset = CGPointMake(0, -110);
        return;
    }
    
    if (offsetY < -100) {
        int index = ceil((fabs(offsetY) - 100));
        
        NSLog(@"====index===%d",index);
        self.freshImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_camera_frame%d",index]];
        
        if (index > 20) {
            self.freshImageView.image = [UIImage imageNamed:@"refresh_camera_frame20"];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < -120) {
        NSMutableArray <UIImage *>*imageArray = [NSMutableArray array];
        for (int i = 21; i < 42; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_camera_frame%d",i]];
            [imageArray addObject:image];
        }
        self.freshImageView.animationImages = imageArray;
        self.freshImageView.animationDuration = 1.0f;
        self.freshImageView.animationRepeatCount = HUGE_VALF;
        [self.freshImageView startAnimating];
        
        self.isFreshing = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isFreshing = NO;
            self.freshImageView.animationImages = nil;
        });
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
