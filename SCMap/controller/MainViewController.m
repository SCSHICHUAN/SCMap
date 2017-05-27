//
//  MainViewController.m
//  SCMap
//
//  Created by SHICHUAN on 2017/4/19.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import "MainViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "LocalNameTableViewCell.h"
#import "YYAnnotation.h"
#import "PointModel.h"
#import "SCTableViewCell.h"

#define kScreenWith ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

typedef enum{
    gprs_YES,
    gprs_NO
}Gprs_Typ;




@interface MainViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    MKUserLocation *_userLocation;
    CLLocation *_cLocation;
    int pointCount;
    CGFloat  aggregateDistance;
    float currentWorkTime;
    float planWorkTime;
    float planWorkSpeedFloat;
    
    
}
@property(nonatomic,assign)Gprs_Typ  gprs_Typ;

//地图
@property(strong,nonatomic)MKMapView *mapView;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;
@property(nonatomic,strong)UIButton *button3;
@property(nonatomic,strong)UIButton *button4;
@property(nonatomic,strong)UIButton *button5;
@property(nonatomic,strong)UIButton *button6;
@property(nonatomic,strong)UIButton *button7;
@property(nonatomic,strong)UIButton *button8;
@property(nonatomic,strong)UIButton *button9;
@property(nonatomic,strong)UIButton *button10;
@property(nonatomic,strong)UIView *navigationHeadView;
@property(nonatomic,strong)CLGeocoder *geocoder;//地理编码工具
@property(nonatomic,strong)UILabel *headLabel;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *nameArray;
@property(nonatomic,strong)NSMutableArray *pointArray;
@property(strong,nonatomic)MKDirections *directs;//用于发送请求给服务器，获取规划好后的路线。
@property(nonatomic,strong)UITextView *titleHead;
@property(nonatomic,strong)UITextField *TextField1;
@property(nonatomic,strong)UITextField *TextField2;
@property(nonatomic,strong)UITextField *TextField3;
@property(nonatomic,strong)UITextField *TextField4;
@property(nonatomic,strong)UILabel *label1;
@property(nonatomic,strong)UILabel *label2;
@property(nonatomic,strong)UILabel *label3;
@property(nonatomic,strong)UIView *wordView;
@property(nonatomic,weak)CLLocation *myLocation;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
//自己纬度
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *decesentLabel;
@property(nonatomic,strong)UILabel *planWorkSpeed;
@property(nonatomic,strong)CLLocation* lastAccurateLocation;
@property(nonatomic,strong)UILabel *speedLabel;
@property(nonatomic,strong)UILabel *speedAverageLabel;
@property(nonatomic,strong)NSMutableArray *speedArray;
@property(nonatomic,strong)UIView *plate;
@property(nonatomic,strong)UILabel *tipsSpeed;
@property(nonatomic,strong)NSTimer *timer1;
@property(nonatomic,strong)UITableView *tableView2;
@property(nonatomic,strong)NSMutableArray *localationArray;
@end

@implementation MainViewController

#pragma mark-丹利化
-(MKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-0)];
    }
    return _mapView;
}
-(UIButton *)button1
{
    if (_button1 == nil) {
        _button1 = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button1 setImage:[UIImage imageNamed: @"gps7"] forState:UIControlStateNormal];
        _button1.frame = CGRectMake(kScreenWith - 40,64+5,35, 35);
        [_button1 addTarget:self action:@selector(gprsUser1) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}
-(UIButton *)button2
{
    if (_button2 == nil) {
        _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button2 setImage:[UIImage imageNamed: @"road29"] forState:UIControlStateNormal];
        _button2.frame = CGRectMake(kScreenWith - 40,64+5+10+35,35, 35);
        [_button2 addTarget:self action:@selector(gprsUser2) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}
-(UIButton *)button3
{
    if (_button3 == nil) {
        _button3 = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button3 setImage:[UIImage imageNamed: @"magnifier11"] forState:UIControlStateNormal];
        _button3.frame = CGRectMake(kScreenWith - 40,64+5+10+35+10+35,35, 35);
        [_button3 addTarget:self action:@selector(gprsUser3) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
}
-(UIButton *)button4
{
    if (_button4 == nil) {
        _button4 = [UIButton buttonWithType:UIButtonTypeSystem];
        _button4.backgroundColor = [UIColor colorWithRed:5.0/255 green:124.0/255 blue:255.0/255 alpha:1.0];
        _button4.frame = CGRectMake(60, 70+160, 80, 80);
        _button4.layer.cornerRadius = 40;
        [_button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button4 setTitle:@"开始计算" forState:UIControlStateNormal];
        [_button4 addTarget:self action:@selector(gprsUser4) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button4;
}
-(UIButton *)button5
{
    if (_button5 == nil) {
        _button5 = [UIButton buttonWithType:UIButtonTypeSystem];
        _button5.backgroundColor = [UIColor colorWithRed:5.0/255 green:124.0/255 blue:255.0/255 alpha:1.0];
        _button5.frame = CGRectMake(kScreenWith - 80-60, 70+160, 80,80);
        _button5.layer.cornerRadius = 40;
        [_button5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button5 setTitle:@"移除大头" forState:UIControlStateNormal];
        [_button5 addTarget:self action:@selector(gprsUser5) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button5;
}
-(UIButton *)button6
{
    if (_button6 == nil) {
        _button6 = [UIButton buttonWithType:UIButtonTypeSystem];
        _button6.backgroundColor = [UIColor colorWithRed:5.0/255 green: 200.0/255 blue: 124.0/255 alpha:1.0];
        _button6.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height-90-44, 80,80);
        _button6.layer.cornerRadius = 40;
        [_button6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button6 setTitle:@"出发" forState:UIControlStateNormal];
        _button6.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _button6.layer.shadowColor = [UIColor blackColor].CGColor;
        _button6.layer.shadowOpacity = 0.5;
        _button6.layer.shadowOffset = CGSizeMake(0, 0);
        [_button6 addTarget:self action:@selector(gprsUser6) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button6;
}
-(UIButton *)button8
{
    if (_button8 == nil) {
        _button8 = [UIButton buttonWithType:UIButtonTypeSystem];
        _button8.backgroundColor = [UIColor colorWithRed:200.0/255 green: 5.0/255 blue: 124.0/255 alpha:1.0];
        _button8.frame = CGRectMake(kScreenWith- 80-10, [UIScreen mainScreen].bounds.size.height-90-44, 80,80);
        _button8.layer.cornerRadius = 40;
        [_button8 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button8 setTitle:@"结束" forState:UIControlStateNormal];
        _button8.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _button8.layer.shadowColor = [UIColor blackColor].CGColor;
        _button8.layer.shadowOpacity = 0.5;
        _button8.layer.shadowOffset = CGSizeMake(0, 0);
        [_button8 addTarget:self action:@selector(gprsUser8) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button8;
}

-(UIButton *)button7
{
    if (_button7 == nil) {
        _button7 = [UIButton buttonWithType:UIButtonTypeSystem];
        [_button7 setImage:[UIImage imageNamed: @"level8"] forState:UIControlStateNormal];
        _button7.frame = CGRectMake(kScreenWith - 40,64+5+10+35+10+35+10+35,35, 35);
        [_button7 addTarget:self action:@selector(showPate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button7;
}
-(UIButton *)button9
{
    if (_button9 == nil) {
        _button9 = [UIButton buttonWithType:UIButtonTypeSystem];
        _button9.backgroundColor = [UIColor colorWithRed:5.0/255 green:124.0/255 blue:255.0/255 alpha:1.0];
        _button9.frame = CGRectMake((kScreenWith-10)/2-80/2, 70+160+90, 80,80);
        _button9.layer.cornerRadius = 40;
        [_button9 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button9 setTitle:@"保存记录" forState:UIControlStateNormal];
        [_button9 addTarget:self action:@selector(saveRecord) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button9;
}
-(UIButton *)button10
{
    if (_button10 == nil) {
        _button10 = [UIButton buttonWithType:UIButtonTypeSystem];
//        _button10.backgroundColor = [UIColor colorWithRed:5.0/255 green:124.0/255 blue:255.0/255 alpha:1.0];
        _button10.frame = CGRectMake(kScreenWith - 40,64+5+10+35+10+35+10+35+10+35,35, 35);
        _button10.layer.cornerRadius = 40;
        [_button10 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button10 setImage:[UIImage imageNamed:@"left_footprint"] forState:UIControlStateNormal];
        [_button10 setTitle:@"打开记录" forState:UIControlStateNormal];
        [_button10 addTarget:self action:@selector(openRecord) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button10;
}



-(UIView *)navigationHeadView
{
    if (_navigationHeadView == nil) {
        _navigationHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith, 64)];
        _navigationHeadView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    }
    return _navigationHeadView;
}
-(CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}
-(UILabel *)headLabel
{
    if (_headLabel == nil) {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64/2-20/2+10, kScreenWith, 20)];
        _headLabel.textColor = [UIColor whiteColor];
        _headLabel.textAlignment = NSTextAlignmentCenter;
        _headLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _headLabel;
}
-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 5*25.0)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.tag = 1;
        
        UISwipeGestureRecognizer *swipwe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiweLift:)];
        swipwe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.tableView addGestureRecognizer:swipwe];
        
    }
    return _tableView;
}
-(UITableView *)tableView2
{
    if (_tableView2 == nil) {
        _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40-50)];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.tag = 2;
        
        UISwipeGestureRecognizer *swipwe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiweLift:)];
        swipwe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.tableView2 addGestureRecognizer:swipwe];
        
    }
    return _tableView2;
}

-(NSMutableArray *)nameArray
{
    if (_nameArray == nil) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}
-(NSMutableArray *)pointArray
{
    if (_pointArray == nil) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}
-(UITextView *)titleHead
{
    if (_titleHead == nil) {
        _titleHead = [[UITextView alloc] initWithFrame:CGRectMake(5, 44, kScreenWith-5, 45)];
        _titleHead.font = [UIFont systemFontOfSize:15];
        _titleHead.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        _titleHead.textColor = [UIColor blackColor];
    }
    return _titleHead;
}
-(UIView *)wordView
{
    if (_wordView == nil) {
        _wordView = [[UIView alloc] initWithFrame:CGRectMake(5,(CGRectGetMaxY(self.button3.frame))-60, kScreenWith-10, kScreenHeight-260)];
        _wordView.backgroundColor = [UIColor whiteColor];
        _wordView.layer.cornerRadius = 8;
        _wordView.layer.shadowColor = [UIColor blackColor].CGColor;
        _wordView.layer.shadowOffset = CGSizeMake(0, 0);
        _wordView.layer.shadowOpacity = 0.5;
    }
    return _wordView;
}
-(UILabel *)label1
{
    if (_label1 == nil) {
        _label1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 80, 35)];
        _label1.font = [UIFont boldSystemFontOfSize:17];
        _label1.textColor = [UIColor colorWithRed:5.0/255 green:124.0/255 blue:255.0/255 alpha:1.0];
        _label1.text = @"起点";
    }
    return _label1;
}
-(UILabel *)label2
{
    if (_label2 == nil) {
        _label2 = [[UILabel alloc] initWithFrame:CGRectMake(12, 70, 80, 35)];
        _label2.font = [UIFont boldSystemFontOfSize:17];
        _label2.textColor = [UIColor redColor];
        _label2.text = @"终点";
    }
    return _label2;
}
-(UILabel *)label3
{
    if (_label3 == nil) {
        _label3 = [[UILabel alloc] initWithFrame:CGRectMake(12, 70+70, 80, 35)];
        _label3.font = [UIFont boldSystemFontOfSize:17];
        _label3.textColor = [UIColor colorWithRed:5.0/255 green:124.0/255 blue:255.0/255 alpha:1.0];
        _label3.text = @"目的";
    }
    return _label3;
}

-(UITextField *)TextField1
{
    if (_TextField1 == nil) {
        _TextField1 = [[UITextField alloc] initWithFrame:CGRectMake(60, 20, kScreenWith - 90-10, 35)];
        _TextField1.borderStyle = UITextBorderStyleRoundedRect;
        _TextField1.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    }
    return _TextField1;
}
-(UITextField *)TextField2
{
    if (_TextField2 == nil) {
        _TextField2 = [[UITextField alloc] initWithFrame:CGRectMake(60, 70, kScreenWith - 90-10, 35)];
        _TextField2.borderStyle = UITextBorderStyleRoundedRect;
        _TextField2.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    }
    return _TextField2;
}
-(UITextField *)TextField3
{
    if (_TextField3 == nil) {
        _TextField3 = [[UITextField alloc] initWithFrame:CGRectMake(60, 70+70, (kScreenWith - 90-10)/2-15, 35)];
        _TextField3.borderStyle = UITextBorderStyleRoundedRect;
        _TextField3.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        _TextField3.keyboardType = UIKeyboardTypeNumberPad;
        _TextField3.delegate = self;
        _TextField3.placeholder = @"输入小时";
    }
    return _TextField3;
}
-(UITextField *)TextField4
{
    if (_TextField4 == nil) {
        _TextField4 = [[UITextField alloc] initWithFrame:CGRectMake(60+(kScreenWith - 90-10)/2, 70+70, (kScreenWith - 90-10)/2-15, 35)];
        _TextField4.borderStyle = UITextBorderStyleRoundedRect;
        _TextField4.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        _TextField4.delegate = self;
        _TextField4.keyboardType = UIKeyboardTypeNumberPad;
        _TextField4.placeholder = @"输入分钟";
    }
    return _TextField4;
}
-(UILabel *)speedLabel
{
    if (_speedLabel == nil) {
        _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 70)];
        _speedLabel.backgroundColor = [UIColor blackColor];
        _speedLabel.textColor = [UIColor whiteColor];
        _speedLabel.textAlignment = NSTextAlignmentCenter;
        _speedLabel.font = [UIFont systemFontOfSize:70];
    }
    return _speedLabel;
}
-(NSMutableArray *)speedArray
{
    if (_speedArray == nil) {
        _speedArray = [NSMutableArray array];
    }
    return _speedArray;
}
-(UILabel *)speedAverageLabel
{
    if (_speedAverageLabel == nil) {
        _speedAverageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 40)];
        _speedAverageLabel.backgroundColor = [UIColor blackColor];
        _speedAverageLabel.textColor = [UIColor yellowColor];
        _speedAverageLabel.textAlignment = NSTextAlignmentCenter;
        _speedAverageLabel.font = [UIFont systemFontOfSize:40];
    }
    return _speedAverageLabel;
}
-(UILabel *)decesentLabel
{
    if (_decesentLabel == nil) {
        _decesentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-100, [UIScreen mainScreen].bounds.size.width, 40)];
        _decesentLabel.backgroundColor = [UIColor blackColor];
        _decesentLabel.textColor = [UIColor whiteColor];
        _decesentLabel.textAlignment = NSTextAlignmentCenter;
        _decesentLabel.font = [UIFont systemFontOfSize:40];
    }
    return _decesentLabel;
    
}
-(UILabel *)planWorkSpeed
{
    if (_planWorkSpeed == nil) {
        _planWorkSpeed = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 17)];
        _planWorkSpeed.backgroundColor = [UIColor blackColor];
        _planWorkSpeed.textColor = [UIColor whiteColor];
        _planWorkSpeed.textAlignment = NSTextAlignmentCenter;
        _planWorkSpeed.font = [UIFont systemFontOfSize:17];
    }
    return _planWorkSpeed;
    
}
-(UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-200, [UIScreen mainScreen].bounds.size.width, 70)];
        _timeLabel.backgroundColor = [UIColor blackColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:70];
    }
    return _timeLabel;
    
}
-(UILabel *)tipsSpeed
{
    if (_tipsSpeed == nil) {
        _tipsSpeed = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 70)];        
        _tipsSpeed.backgroundColor = [UIColor blackColor];
        _tipsSpeed.textColor = [UIColor whiteColor];
        _tipsSpeed.textAlignment = NSTextAlignmentCenter;
        _tipsSpeed.font = [UIFont systemFontOfSize:70];
    }
    return _tipsSpeed;
    
}
-(UIView *)plate
{
    if (_plate == nil) {
        _plate = [[UIView alloc] initWithFrame:self.view.bounds];
        _plate.backgroundColor = [UIColor blackColor];
        [_plate addSubview:self.decesentLabel];
        [_plate addSubview:self.planWorkSpeed];
        [_plate addSubview:self.timeLabel];
        [_plate addSubview:self.tipsSpeed];
        [_plate addSubview:self.speedLabel];
        [_plate addSubview:self.speedAverageLabel];
        
        UITapGestureRecognizer *backMapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backMap)];
        backMapTap.numberOfTouchesRequired = 2;
        [self.plate addGestureRecognizer:backMapTap];
        UITapGestureRecognizer *backMapTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPate)];
        backMapTap2.numberOfTouchesRequired = 3;
        [self.mapView addGestureRecognizer:backMapTap2];

    }
    return _plate;
}

-(NSTimer *)timer1
{
    if (_timer1 == nil) {
        _timer1 = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                          target:self
                                                        selector:@selector(alarmTimerStar1)
                                                        userInfo:nil
                                                         repeats:YES];
        //滚动时不会暂停时钟
        [[NSRunLoop currentRunLoop] addTimer:_timer1 forMode:NSRunLoopCommonModes];
    }
    return _timer1;
}
-(NSMutableArray *)localationArray
{
    if (_localationArray == nil) {
        
        NSData *data = [NSData dataWithContentsOfFile:[self pathUSER]];
        _localationArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if (_localationArray == nil) {
            _localationArray = [NSMutableArray array];
        }
        
    }
    return _localationArray;
}
-(void)openRecord
{
    [self.view addSubview:self.tableView2];
    
    CGRect fream2;
    fream2 = self.tableView2.frame;
    fream2.origin.y = -[UIScreen mainScreen].bounds.size.height;
    self.tableView2.frame = fream2;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect fream2;
        fream2 = self.tableView2.frame;
        fream2.origin.y = 40;
        self.tableView2.frame = fream2;
    }];
    
    
}
-(void)saveRecord
{
    [self.tableView2 reloadData];
    
    if (self.TextField2.text == nil||self.TextField3 == nil||self.TextField4==nil) {
        return;
    }
    
    NSDictionary *dict = @{@"localation":self.TextField2.text,
                           @"hour":self.TextField3.text,
                           @"mim" :self.TextField4.text,
                           };
    [self.localationArray addObject:dict];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.localationArray];
    [data writeToFile:[self pathUSER] atomically:NO];
    
}

-(NSString*)pathUSER
{
    NSArray *pathArray =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = pathArray.firstObject;
    NSString *path2 = [path1 stringByAppendingPathComponent:@"USER_information"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path2] ) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path2 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    path2 = [path2 stringByAppendingPathComponent:@"user.data"];
    
    return path2;
}









-(void)swiweLift:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"UISwipeGestureRecognizerDirectionLeft");
        [self hiddenTabVie];
        [self hiddenTableView2];
        
     }
}
-(void)hiddenTableView2
{
    CGRect fream2;
    fream2 = self.tableView2.frame;
    fream2.origin.y = -[UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tableView2.frame = fream2;
    } completion:^(BOOL finished) {
        [self.tableView2 removeFromSuperview];
    }];
    

}
-(void)hiddenTabVie
{
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.frame = CGRectMake(-kScreenWith, 65, kScreenWith, self.tableView.bounds.size.height);
        self.navigationHeadView.frame = CGRectMake(0, 0, kScreenWith, 40);
        self.headLabel.frame = CGRectMake(0, 25, kScreenWith, 10);
        self.headLabel.font = [UIFont systemFontOfSize:15];
        self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight, kScreenWith, 44);
    } completion:^(BOOL finished) {
        self.tableView.frame = CGRectMake(0, 65, kScreenWith,5*25.0);
        [self.tableView removeFromSuperview];
    }];
}
-(void)showTabView
{
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:self.button1];
    [self.view bringSubviewToFront:self.button2];
    [self.view bringSubviewToFront:self.button3];
    [self.view bringSubviewToFront:self.button7];
    [self.view bringSubviewToFront:self.button10];
    [self.view bringSubviewToFront:self.navigationHeadView];
    self.tableView.frame = CGRectMake(0,65, kScreenWith, 0);
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableView setContentOffset:CGPointZero];
        self.tableView.frame = CGRectMake(0, 65, kScreenWith, 5*25);
        self.navigationHeadView.frame = CGRectMake(0, 0, kScreenWith, 64);
        self.headLabel.frame = CGRectMake(0, 64/2-20/2+10, kScreenWith, 20);
        self.headLabel.font = [UIFont systemFontOfSize:20];
        self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight-44, kScreenWith, 44);
        
    } completion:nil];
}

-(void)gprsUser2
{
    [self hiddenTabVie];
    [self.mapView removeOverlays:self.mapView.overlays];//移除划的线路
    [self line];
}
-(void)gprsUser3
{
    [self.view addSubview:self.wordView];
    self.wordView.frame = self.button3.frame;
    
    
    //    //1.创建动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    //2.设置关键帧动画的values
    NSValue *value0 = [NSValue valueWithCGRect:self.button3.frame];
    NSValue *value1 = [NSValue valueWithCGRect:CGRectMake(5,(CGRectGetMaxY(self.button3.frame))-100, (kScreenWith-10)*0.5, (kScreenHeight-260)*0.5)];
    NSValue *value2 = [NSValue valueWithCGRect:CGRectMake(5,(CGRectGetMaxY(self.button3.frame))-70, (kScreenWith-10)*1.2, (kScreenHeight-260)*1.2)];
    NSValue *value3 = [NSValue valueWithCGRect:CGRectMake(5,(CGRectGetMaxY(self.button3.frame))-60, kScreenWith-10, kScreenHeight-260)];
    animation.values = @[value0,value1,value2,value3];
    //3.添加动画
    [self.wordView.layer addAnimation:animation forKey:nil];
    
    
    //
    //    [UIView animateWithDuration:0.2 animations:^{
    //        self.wordView.frame =  CGRectMake(5,(CGRectGetMaxY(self.button3.frame))+10, kScreenWith-10, 2);
    //    } completion:^(BOOL finished) {
    //        [UIView animateWithDuration:0.2 animations:^{
    self.wordView.frame =  CGRectMake(5,(CGRectGetMaxY(self.button3.frame))-60, kScreenWith-10, kScreenHeight-260);
    //        } completion:nil];
    //    }];
    
    
    
    
    [self performSelector:@selector(addWordSubView) withObject:nil afterDelay:0.4];
}
-(void)addWordSubView
{
//    [self.wordView addSubview:self.label1];
    [self.wordView addSubview:self.label2];
    [self.wordView addSubview:self.label3];
//    [self.wordView addSubview:self.TextField1];
    [self.wordView addSubview:self.TextField2];
    [self.wordView addSubview:self.TextField3];
    [self.wordView addSubview:self.TextField4];
    [self.wordView addSubview:self.button4];
    [self.wordView addSubview:self.button5];
    [self.wordView addSubview:self.button9];
//    [self.wordView addSubview:self.button6];
}
-(void)hiddenWordSubView
{
    [self.label1 removeFromSuperview] ;
    [self.label2 removeFromSuperview];
    [self.label3 removeFromSuperview];
    [self.TextField1 removeFromSuperview];
    [self.TextField2 removeFromSuperview];
    [self.TextField3 removeFromSuperview];
    [self.TextField4 removeFromSuperview];
    [self.button4 removeFromSuperview];
    [self.button5 removeFromSuperview];
    [self.button9 removeFromSuperview];
//    [self.button6 removeFromSuperview];
}

-(void)gprsUser5
{
    // 获取地图上所有的大头针数据模型
    NSArray *annotations = self.mapView.annotations;
    // 移除大头针
    [self.mapView removeAnnotations:annotations];
}
-(void)gprsUser6
{
    [self tapPress2:nil];
    [self hiddenWordSubView];
    [self showPate];
    [self.timer1 fire];
}
-(void)gprsUser8
{
    [self.timer1 setFireDate:[NSDate distantFuture]];
    [self.button6 removeFromSuperview];
    [self.button8 removeFromSuperview];
}
-(void)showPate
{
    self.plate.frame = CGRectMake(0, kScreenHeight, kScreenWith, kScreenHeight);
    [self.view addSubview:self.plate];
    [UIView animateWithDuration:0.25 animations:^{
        self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight, kScreenWith, 44);
        self.plate.frame = CGRectMake(0, 0, kScreenWith, kScreenHeight);
        
    }];

}
-(void)backMap
{
  
    [UIView animateWithDuration:0.25 animations:^{
        self.tabBarController.tabBar.frame = CGRectMake(0, kScreenHeight-44, kScreenWith, 44);
        self.plate.frame = CGRectMake(0, kScreenHeight, kScreenWith, kScreenHeight);
        
    } completion:^(BOOL finished) {
         [self.plate removeFromSuperview];
    }];
   
}






- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    
    [self typOrinig];
    //设置MapView的委托为自己
    [self.mapView setDelegate:self];
    //标注自身位置
    [self.mapView setShowsUserLocation:YES];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.titleHead];
   
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//屏幕常亮
    
    //1. 先启动定位功能
    self.locationManager = [[CLLocationManager alloc]init];
    //如果定位服务可用。
    // 1)定位服务只会定位一次
    // 2）iOS8和以后要进行需要手动调用CLLocationManager对象的requestAlwaysAuthorization方法。调用该方法需要在Info.plist中设           置NSLocationAlwaysUsageDescription的值，这个值会显示在系统提示框中,值可以为空。
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        // [_locationManager requestWhenInUseAuthorization];//必须配合使用，2种方式都可以。
        // [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse
        [_locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;  //设置最高的精度
    [self.locationManager startUpdatingLocation];  //开始定位
   
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
    [self.view addSubview:self.button7];
    [self.view addSubview:self.button10];
    
    [self performSelector:@selector(gprsUser1) withObject:nil afterDelay:2.0];
    [self.view addSubview:self.navigationHeadView];
    
    [self.navigationHeadView addSubview:self.headLabel];
    
    UILongPressGestureRecognizer *mTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.mapView addGestureRecognizer:mTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTabView)];
    [self.navigationHeadView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *mTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress2:)];
    [self.mapView addGestureRecognizer:mTap2];
    
    
    
    pointCount = 0;
    
}

- (void)tapPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
        CLLocationCoordinate2D touchMapCoordinate =
        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
        NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
        CLLocationCoordinate2D location2D=CLLocationCoordinate2DMake(touchMapCoordinate.latitude, touchMapCoordinate.longitude);
        _cLocation = [[CLLocation alloc] initWithLatitude:location2D.latitude longitude:location2D.longitude];
        [self getLocalNameWithLocation:_cLocation andType:@"1"];
        
        
        
        
    }
}
- (void)tapPress2:(UITapGestureRecognizer *)tapGesture
{
    [self.titleHead resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.wordView.frame =  CGRectMake(5,(CGRectGetMaxY(self.button3.frame))+10, kScreenWith-10,2);
        [self hiddenWordSubView];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.wordView.frame =  self.button3.frame;
        } completion:^(BOOL finished) {
            [self.wordView removeFromSuperview];
        }];
    }];
}







-(void)typOrinig
{
    self.gprs_Typ = YES;
    
}



#pragma mark -MKMapViewDelegate
//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _userLocation  = userLocation;
    //
    //        CLLocationCoordinate2D loc = [userLocation coordinate];
    //显示到label上
    //        self.longitudeLabel.text = [NSString stringWithFormat:@"%f",loc.longitude];
    //
    //        self.latitudeLabel.text = [NSString stringWithFormat:@"%f",loc.latitude];
    
    
}

//定位当前的位置
-(void)gprsUser1
{
    
    [self.tableView removeFromSuperview];
    
    CLLocationCoordinate2D loc = [_userLocation coordinate];
    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [self.mapView setRegion:region animated:YES];
    
    [self performSelector:@selector(addressesName) withObject:nil afterDelay:2.0];
}
-(void)addressesName
{
    [self getLocalNameWithLocation:_userLocation.location andType:@"0"];
}
//location 来反编码出地理名字
-(void)getLocalNameWithLocation:(CLLocation *)location andType:(NSString *)type
{
    
    
    CLLocationCoordinate2D loc = [location coordinate];
    
    
    NSLog(@"loc.latitude= [ %f ]",loc.latitude);
    NSLog(@"loc.longitude= [ %f ]",loc.longitude);
    
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
         
         if (!error) {
             
             
             CLPlacemark *placemark = placemarks.firstObject;
             
             self.headLabel.text = placemark.subLocality;
             
             
            
             
             NSString *str1 = [NSString stringWithFormat:@"%@",placemark.addressDictionary[@"FormattedAddressLines"]];
             
             
             str1 =  [str1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
             str1 =  [str1 stringByReplacingOccurrencesOfString:@"(" withString:@""];
             str1 =  [str1 stringByReplacingOccurrencesOfString:@")" withString:@""];
             str1 =  [str1 stringByReplacingOccurrencesOfString:@"," withString:@""];
             str1 =  [str1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
             str1 =  [str1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             str1 =  [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
             //
             NSLog(@"str2= [ %@ ]",str1);
             
             [self.nameArray addObject:str1];
             
             
             NSString *name111,*thoroughfare111,*subLocality111,*locality111;
             
             name111 = placemark.name;
             thoroughfare111 = placemark.thoroughfare;
             subLocality111 = placemark.subLocality;
             locality111 = placemark.locality;
             
             if (!(name111 == nil)) {
                 [self.nameArray addObject:name111];
             }else{
                 name111 =@"";
             }
             if (!(thoroughfare111 == nil)) {
                 [self.nameArray addObject:thoroughfare111];
             }else{
                 thoroughfare111 =@"";
             }
             if (!(subLocality111==nil)) {
                 [self.nameArray addObject:subLocality111];
             }else{
                 subLocality111 = @"";
             }
             if (!(locality111 == nil)) {
                 [self.nameArray addObject:locality111];
             }else{
                 locality111 =@"";
             }
             
             [self.nameArray addObject:@""];
             
             
             NSLog(@"成功 %@",[placemark class]);
             NSLog(@"地理名称%@",placemark.name);
             NSLog(@"街道名%@",placemark.thoroughfare);
             NSLog(@"国家%@",placemark.country);
             NSLog(@"城市%@",placemark.locality);
             NSLog(@"区: %@",placemark.subLocality);
             NSLog(@"地址%@",placemark.addressDictionary[@"FormattedAddressLines"]);
             
             NSLog(@"地址%@",placemark.addressDictionary);
             NSLog(@"=======\n");
             
             
             
             
             YYAnnotation *annotation=[[YYAnnotation alloc]init];
             annotation.coordinate=loc;
             annotation.title = placemark.name;
             
             
                 
                 [self.mapView addAnnotation:annotation];
                 
                 pointCount +=1;
                 NSDictionary *dict = @{@"pointLocation":location,
                                        @"name":name111,
                                        @"thoroughfare":thoroughfare111,
                                        @"subLocality":subLocality111,
                                        @"locality":locality111,
                                        @"speceTitle":[NSString stringWithFormat:@"%d",pointCount]
                                        };
                 
                 
                 
                 PointModel *model = [[PointModel alloc] initWithDict:dict];
                 
                 
                 [self.pointArray addObject:model];
                          
             self.titleHead.text = str1;
             [self.mapView addSubview:self.titleHead];
             [self.tableView reloadData];
             
             //             [self showTabView];
         }else if (error) {
             
             NSLog(@"error= [ %@ ]",error);
         }
         
         
     }];
    
}
//给出两个地名算出路线
-(void)gprsUser4
{
    [self.mapView removeOverlays:self.mapView.overlays];//移除划的线路
    [self tapPress2:nil];
    [self gprsUser5];
    [self.mapView addSubview:self.button6];
    [self.mapView addSubview:self.button8];
    
    [_geocoder reverseGeocodeLocation:_userLocation.location completionHandler:
     ^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
         
         
         
         
         MKPlacemark *placemark = [[MKPlacemark alloc]initWithPlacemark:placemarks.lastObject];
         //intrItem可以理解为地图上的一个点
         MKMapItem *intrItem = [[MKMapItem alloc]initWithPlacemark:placemark];
         
         //        添加一个小别针到地图上
         YYAnnotation *anno = [[YYAnnotation alloc]init];
         anno.coordinate = intrItem.placemark.location.coordinate;
         [self.mapView addAnnotation:anno];
         
         // 让地图跳转到起点所在的区域
         MKCoordinateRegion region = MKCoordinateRegionMake(intrItem.placemark.location.coordinate, MKCoordinateSpanMake(0.05, 0.05));
         [self.mapView setRegion:region];
         
         //创建终点
         [_geocoder geocodeAddressString:self.TextField2.text completionHandler:
          ^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
              
              //destItem可以理解为地图上的一个点
              MKMapItem *destItem = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithPlacemark:[placemarks lastObject]]];
              
              
              //        添加一个小别针到地图上
              YYAnnotation *anno = [[YYAnnotation alloc]init];
              anno.coordinate = destItem.placemark.location.coordinate;
              [self.mapView addAnnotation:anno];
              
              //调用下面方法发送请求
              [self moveWith:intrItem toDestination:destItem];
          }];
     }];
    
}
//根据location来出两地的路线
-(void)line
{
    if (self.pointArray.count<2) {
        return;
    }
    
    PointModel *model2;
    
    
    model2 = self.pointArray.lastObject;
    
    
    [_geocoder reverseGeocodeLocation:_userLocation.location completionHandler:
     ^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
         
         
         
         MKPlacemark *placemark = [[MKPlacemark alloc]initWithPlacemark:placemarks.lastObject];
         //intrItem可以理解为地图上的一个点
         MKMapItem *intrItem = [[MKMapItem alloc]initWithPlacemark:placemark];
         
         //        添加一个小别针到地图上
         YYAnnotation *anno = [[YYAnnotation alloc]init];
         anno.coordinate = intrItem.placemark.location.coordinate;
         //        [self.mapView addAnnotation:anno];
         
         // 让地图跳转到起点所在的区域
         //         MKCoordinateRegion region = MKCoordinateRegionMake(intrItem.placemark.location.coordinate, MKCoordinateSpanMake(0.05, 0.05));
         //         [self.mapView setRegion:region];
         
         //创建终点
         [_geocoder  reverseGeocodeLocation:model2.pointLocation completionHandler:
          ^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
              
              //destItem可以理解为地图上的一个点
              MKMapItem *destItem = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithPlacemark:[placemarks lastObject]]];
              
              
              //        添加一个小别针到地图上
              YYAnnotation *anno = [[YYAnnotation alloc]init];
              anno.coordinate = destItem.placemark.location.coordinate;
              //            [self.mapView addAnnotation:anno];
              
              //调用下面方法发送请求
              [self moveWith:intrItem toDestination:destItem];
          }];
     }];
    
}

//提供两个点，在地图上进行规划的方法
-(void)moveWith:(MKMapItem *)formPlce toDestination:(MKMapItem *)endPlace{
    
    //    创建请求体
    // 创建请求体 (起点与终点)
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    request.source = formPlce;
    request.destination = endPlace;
    request.requestsAlternateRoutes = MKDirectionsTransportTypeWalking;//步行
    
    self.directs = [[MKDirections alloc]initWithRequest:request];
    
    // 计算路线规划信息 (向服务器发请求)
    [self.directs calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        
        
        [response.routes enumerateObjectsUsingBlock:^(MKRoute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            
            NSLog(@"obj.name= [ %@ ]",obj.name);
            NSLog(@"obj.distance= [ %f ]",obj.distance/1000);
            NSLog(@"obj.expectedTravelTime= [ %f ]",obj.expectedTravelTime/3600);
            NSLog(@"obj.name= [ %@ ]",obj.polyline);
            
            
        }];
        
        //获取到所有路线
        NSArray <MKRoute *> *routesArray = response.routes;
        
        //取出最后一条路线
        MKRoute *rute = routesArray.lastObject;
        
        //路线中的每一步
        NSArray <MKRouteStep *>*stepsArray = rute.steps;
        
        float destence;
        destence = 0;

        //遍历
        for (MKRouteStep *step in stepsArray) {
            destence += step.distance;
            [self.mapView addOverlay:step.polyline];
        }
        NSLog(@"destence= [ %.2fkm ]",destence/1000.0);
        // 收响应结果 MKDirectionsResponse
        // MKRoute 表示的一条完整的路线信息 (从起点到终点) (包含多个步骤)
        
        self.decesentLabel.text = [NSString stringWithFormat:@"J:%.2f km",destence/1000.0];
        
        NSDate  *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"hh";
        NSString *dateStr1 = [formatter stringFromDate:date];
        
        formatter.dateFormat = @"mm";
        NSString *dateStr2 = [formatter stringFromDate:date];
        
        currentWorkTime = [dateStr1 floatValue] + [dateStr2 floatValue]/60.0;
        planWorkTime = [self.TextField3.text floatValue] + [self.TextField4.text  floatValue]/60.0;
        
        
        self.speedAverageLabel.text = [NSString stringWithFormat:@"AIM:%.2f km/h",(destence/1000.0)/(planWorkTime-currentWorkTime)];
        planWorkSpeedFloat = (destence/1000.0)/(planWorkTime-currentWorkTime);
        
        //取出最后一条路线
        MKRoute *rute2 = routesArray.lastObject;
        
        //路线中的每一步
        NSArray <MKRouteStep *>*stepsArray2 = rute2.steps;
        
        //遍历
        for (MKRouteStep *step2 in stepsArray2) {
            
            [self.mapView addOverlay:step2.polyline];
        }
        // 收响应结果 MKDirectionsResponse
        // MKRoute 表示的一条完整的路线信息 (从起点到终点) (包含多个步骤)
        
        
        
        
        
    }];
    
}

// 返回指定的遮盖模型所对应的遮盖视图, renderer-渲染
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    // 判断类型
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        // 针对线段, 系统有提供好的遮盖视图
        MKPolylineRenderer *render = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        // 配置，遮盖线的颜色
        render.lineWidth = 6;
        render.strokeColor =  [UIColor colorWithRed:64/255.0 green:152/255.0 blue:246/255.0 alpha:0.9];
        
        return render;
    }
    // 返回nil, 是没有默认效果
    return nil;
}





#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView.tag == 1) {
        return self.nameArray.count;
    }else if(tableView.tag == 2){
        return self.localationArray.count;
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 1) {
        
        LocalNameTableViewCell *cell = [LocalNameTableViewCell LocalNameTableViewCellWithTableView:tableView];
        
        cell.dresssnName = self.nameArray[self.nameArray.count-1-indexPath.row];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView.tag == 2) {
        SCTableViewCell *cell = [SCTableViewCell SCTableViewCellAndTableView:tableView];
        [cell laction:self.localationArray[indexPath.row]];
        return cell;
    }
    
    return 0;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    NSLog(@"你点击了第行 = %ld",(long)indexPath.row);
    if (tableView.tag == 2) {
        NSDictionary *dict = self.localationArray[indexPath.row];
        self.TextField2.text = dict[@"localation"];
        self.TextField3.text = dict[@"hour"];
        self.TextField4.text = dict[@"mim"];
        
        [self hiddenTableView2];
        [self gprsUser4];
        
    }
    
    
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 25;
    }else if (tableView.tag == 2){
        return 44;
    }
    
    return 0;
}
//获取当前的tableView的offset
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGFloat tabVieHeight = self.nameArray.count*25.0;
    
    [UIView animateWithDuration:0.25 animations:^{
        if (tabVieHeight < kScreenHeight-65-44) {
            self.tableView.frame = CGRectMake(0, 65, kScreenWith,tabVieHeight);
        }else if (tabVieHeight > kScreenHeight-65-44) {
            self.tableView.frame = CGRectMake(0, 65, kScreenWith, kScreenHeight-65-44);
        }
    } completion:^(BOOL finished) {
        
    }];
    
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 2) {
        
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            [self.localationArray removeObjectAtIndex:indexPath.row];
            [self.tableView2 deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.localationArray];
            [data writeToFile:[self pathUSER] atomically:NO];
            
            
            
            NSLog(@"删除");
        }];
        
        
        return @[deleteRowAction];
    }
    
  
    return 0;
    
    

    
    
}








#pragma mark -UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%s",__func__);
    
    
    [UIView animateWithDuration:0.25 animations:^{
        self.wordView.frame = CGRectMake(5,(CGRectGetMaxY(self.button3.frame))-155, kScreenWith-10, kScreenHeight-260);
    }];
    
    
    
}

#pragma mark -CLLocationManagerDelegate
//2. 根据回调参数和数据计算速度
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.myLocation = newLocation;
    
    
    //    self.latitudeText.text = self.latitudeLabel.text;
    //    self.longitudeText.text =self.longitudeLabel.text ;
    
    NSDate  *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm:ss";
    NSString *dateStr = [formatter stringFromDate:date];
    self.timeLabel.text = dateStr;
    
    //    NSLog(@"oldLocation= [ %@ ]",oldLocation);
    //    NSLog(@"newLocation= [ %@ ]",newLocation);
    //    NSLog(@"                       ");
    
    
    
    if (self.lastAccurateLocation){
        
        float  speedChina = 0.0;
        
        if (newLocation.horizontalAccuracy < kCLLocationAccuracyHundredMeters){
            
            //计算和上次的时间差
            NSTimeInterval dTime = [newLocation.timestamp timeIntervalSinceDate:self.lastAccurateLocation.timestamp];
            
            // 获取相比上次，已经移动的距离
            float distance = [newLocation distanceFromLocation:self.lastAccurateLocation];
            //            if (distance < 1.0f) return;
            
            
            //            NSLog(@"   dTime= [ %0.2f ]",dTime);
            //            NSLog(@"distance= [ %0.2f ]",distance);
            //            NSLog(@"                       ");
            
            
            
            
            
            aggregateDistance += distance;
            
            
            
            float  speed = 2.23693629 * distance / dTime;  //计算出速度
            speedChina = speed*1.609344;
            if (speedChina<0) {
                speedChina = 0.0;
            }
            
            
        }else{
            speedChina = 0.0;
        }
        
        NSString *reportString = [NSString stringWithFormat:@"%0.1f km/h",speedChina];
        self.speedLabel.text = reportString;
        
        
        
        [self.speedArray addObject:[NSString stringWithFormat:@"%f",speedChina]];
        
        
        
        
        float speedAverage = 0;
        
        if ( self.speedArray.count > 5) {
            for (NSString *speedStr in self.speedArray) {
                speedAverage = speedAverage + [speedStr floatValue];
            }
            
            speedAverage = speedAverage/(self.speedArray.count);
            
//            self.speedAverageLabel.text =[NSString stringWithFormat:@"%0.1f km/h",speedAverage];
            [self.speedArray removeAllObjects];
        }
        
        float  backGun = (speedChina-planWorkSpeedFloat);

        if (backGun <0.3) {
            backGun = 0.3;
        }
        
      
        
        
        if (planWorkSpeedFloat-speedChina>0) {
            self.tipsSpeed.text = [NSString stringWithFormat:@"-%.2f",(planWorkSpeedFloat-speedChina)];
            self.tipsSpeed.textColor = [UIColor redColor];
        }else  if(speedChina-planWorkSpeedFloat>0){
            self.tipsSpeed.text = [NSString stringWithFormat:@"+%.2f",(speedChina-planWorkSpeedFloat)];
            self.tipsSpeed.textColor = [UIColor greenColor];
        }

        
    }
    
    self.lastAccurateLocation = newLocation;
    
    
    
}
-(void)alarmTimerStar1
{
    [self gprsUser4];
}
























































/**
 *  当我们添加大头针数据模型时, 就会调用这个方法, 查找对应的大头针视图
 *
 *  @param mapView    地图
 *  @param annotation 大头针数据模型
 *
 *  @return 大头针视图
 *  注意: 如果这个方法, 没有实现, 或者, 这个方法返回nil, 那么系统就会调用系统默认的大头针视图
 */
//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    // 如果是系统的大头针数据模型, 那么使用系统默认的大头针视图,
//    if([annotation isKindOfClass:[MKUserLocation class]])
//    {
//        return nil;
//    }
//
//    // 如果想要自定义大头针视图, 必须使用MKAnnotationView 或者 继承 MKAnnotationView 的子类
//
//    // 设置循环利用标识
//    static NSString *pinID = @"pinID";
//
//    // 从缓存池取出大头针数据视图
//    MKAnnotationView *customView = [mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
//
//    // 如果取出的为nil , 那么就手动创建大头针视图
//    if (customView == nil) {
//        customView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinID];
//    }
//
//    // 1. 设置大头针图片
//    customView.image = [UIImage imageNamed:@"push_pin"];
//
//
//    // 2. 设置弹框
//    customView.canShowCallout = YES;
//
//    // 2.1 设置大头针偏移量
//    //    customView.centerOffset = CGPointMake(100, -100);
//    // 2.2 设置弹框的偏移量
//    //    customView.calloutOffset = CGPointMake(100, 100);
//
//
////    // 3. 自定义弹框
////    // 3.1 设置弹框左侧的视图
////    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
////    imageView.image = [UIImage imageNamed:@"2"];
////    customView.leftCalloutAccessoryView = imageView;
////
////    // 3.2 设置弹框右侧视图
////    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
////    imageView2.image = [UIImage imageNamed:@"3"];
////    customView.rightCalloutAccessoryView = imageView2;
////
////    // 3.3 设置弹框的详情视图(一定要注意,对应的版本)
////    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
////        customView.detailCalloutAccessoryView = [UISwitch new];
////    }
//
//    // 设置大头针视图可以被拖拽
//    customView.draggable = YES;
//
//    return customView;
//    return nil;
//}
//



@end
