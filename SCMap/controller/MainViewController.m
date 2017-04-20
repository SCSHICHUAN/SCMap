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

#define kScreenWith ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

typedef enum{
    gprs_YES,
    gprs_NO
}Gprs_Typ;




@interface MainViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
   MKUserLocation *_userLocation;
    
}
@property(nonatomic,assign)Gprs_Typ  gprs_Typ;

//地图
@property(strong,nonatomic)MKMapView *mapView;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIView *navigationHeadView;
@property(nonatomic,strong)CLGeocoder *geocoder;//地理编码工具
@property(nonatomic,strong)UILabel *headLabel;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *nameArray;
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
        [_button1 addTarget:self action:@selector(gprsUser) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        _tableView.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(NSMutableArray *)nameArray
{
    if (_nameArray == nil) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}






- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
   
    [self typOrinig];
    //设置MapView的委托为自己
    [self.mapView setDelegate:self];
    //标注自身位置
    [self.mapView setShowsUserLocation:YES];
    [self.view addSubview:self.mapView];
    //    [self.view addSubview:self.speedLabel];
    //    [self.view addSubview:self.speedAverageLabel];
    //    [self.view addSubview:self.timeLabel];
 
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
    
    [self performSelector:@selector(gprsUser) withObject:nil afterDelay:2.0];
    [self.view addSubview:self.navigationHeadView];
    [self.navigationHeadView addSubview:self.headLabel];
    
    
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
-(void)gprsUser
{
  
    CLLocationCoordinate2D loc = [_userLocation coordinate];
    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [self.mapView setRegion:region animated:YES];
   
    [self performSelector:@selector(addressesName) withObject:nil afterDelay:2.0];
}
-(void)addressesName
{
    
    
    CLLocationCoordinate2D loc = [_userLocation coordinate];
    
    
    NSLog(@"loc.latitude= [ %f ]",loc.latitude);
    NSLog(@"loc.longitude= [ %f ]",loc.longitude);
    
    
    
    [self.geocoder reverseGeocodeLocation:_userLocation.location completionHandler:
     ^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
         
         if (!error) {
             [self.nameArray removeAllObjects];
             
             CLPlacemark *placemark = placemarks.firstObject;
             
             self.headLabel.text = placemark.subLocality;
             
             [self.nameArray addObject:placemark.locality];
             [self.nameArray addObject:placemark.subLocality];
             [self.nameArray addObject:placemark.thoroughfare];
             [self.nameArray addObject:placemark.name];
           
             
             NSLog(@"成功 %@",[placemark class]);
             NSLog(@"地理名称%@",placemark.name);
             NSLog(@"街道名%@",placemark.thoroughfare);
             NSLog(@"国家%@",placemark.country);
             NSLog(@"城市%@",placemark.locality);
             NSLog(@"区: %@",placemark.subLocality);
             
             NSLog(@"地址%@",placemark.addressDictionary);
             NSLog(@"=======\n");
             
             [self.tableView reloadData];
             [self.view addSubview:self.tableView];
             [self.view bringSubviewToFront:self.button1];
             
         }else if (error) {
             
             NSLog(@"error= [ %@ ]",error);
         }
         
         
     }];

}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    self.tableView.frame = CGRectMake(0, 65, kScreenWith, self.nameArray.count*44);
    return self.nameArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentfer = @"cellIdentfer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentfer];
        cell.textLabel.text = self.nameArray[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        NSLog(@"self.nameArray[indexPath.row]= [ %@ ]",self.nameArray[indexPath.row]);
    }
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"你点击了第行 = %ld",(long)indexPath.row);
}












@end
