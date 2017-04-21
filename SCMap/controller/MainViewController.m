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

#define kScreenWith ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

typedef enum{
    gprs_YES,
    gprs_NO
}Gprs_Typ;




@interface MainViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
   MKUserLocation *_userLocation;
   CLLocation *_cLocation;
   int pointCount;
    
    
}
@property(nonatomic,assign)Gprs_Typ  gprs_Typ;

//地图
@property(strong,nonatomic)MKMapView *mapView;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;
@property(nonatomic,strong)UIButton *button3;
@property(nonatomic,strong)UIView *navigationHeadView;
@property(nonatomic,strong)CLGeocoder *geocoder;//地理编码工具
@property(nonatomic,strong)UILabel *headLabel;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *nameArray;
@property(nonatomic,strong)NSMutableArray *pointArray;
@property(strong,nonatomic)MKDirections *directs;//用于发送请求给服务器，获取规划好后的路线。
@property(nonatomic,strong)UITextField *titleHead;
@property(nonatomic,strong)UIView *wordView;
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
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        UISwipeGestureRecognizer *swipwe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiweLift:)];
        swipwe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.tableView addGestureRecognizer:swipwe];
        
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
-(NSMutableArray *)pointArray
{
    if (_pointArray == nil) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}
-(UITextField *)titleHead
{
    if (_titleHead == nil) {
        _titleHead = [[UITextField alloc] initWithFrame:CGRectMake(5, 44, kScreenWith-5, 20)];
        _titleHead.font = [UIFont systemFontOfSize:15];
        _titleHead.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        _titleHead.textColor = [UIColor blackColor];
    }
    return _titleHead;
}
-(UIView *)wordView
{
    if (_wordView == nil) {
        _wordView = [[UIView alloc] initWithFrame:CGRectMake(5,(CGRectGetMaxY(self.button3.frame))+10, kScreenWith-10, kScreenHeight-260)];
        _wordView.backgroundColor = [UIColor whiteColor];
        _wordView.layer.cornerRadius = 8;
        _wordView.layer.shadowColor = [UIColor blackColor].CGColor;
        _wordView.layer.shadowOffset = CGSizeMake(0, 0);
        _wordView.layer.shadowOpacity = 0.5;
    }
    return _wordView;
}





-(void)swiweLift:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"UISwipeGestureRecognizerDirectionLeft");
        [self hiddenTabVie];
    }
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
        [self.tableView removeFromSuperview];
    }];
}
-(void)showTabView
{
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:self.button1];
    [self.view bringSubviewToFront:self.button2];
    [self.view bringSubviewToFront:self.button3];
    [self.view bringSubviewToFront:self.navigationHeadView];
    double higeht = self.tableView.bounds.size.height;
    self.tableView.frame = CGRectMake(0,65, kScreenWith, 0);
    [UIView animateWithDuration:0.25 animations:^{
          self.tableView.frame = CGRectMake(0, 65, kScreenWith, higeht);
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
    
    //1.创建动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    //2.设置关键帧动画的values
    NSValue *value0 = [NSValue valueWithCGRect:self.button3.frame];
    NSValue *value1 = [NSValue valueWithCGRect:CGRectMake(5,(CGRectGetMaxY(self.button3.frame))+10, (kScreenWith-10)*0.5, (kScreenHeight-260)*0.5)];
    NSValue *value2 = [NSValue valueWithCGRect:CGRectMake(5,(CGRectGetMaxY(self.button3.frame))+10, (kScreenWith-10)*1.2, (kScreenHeight-260)*1.2)];
    NSValue *value3 = [NSValue valueWithCGRect:CGRectMake(5,(CGRectGetMaxY(self.button3.frame))+10, kScreenWith-10, kScreenHeight-260)];
    animation.values = @[value0,value1,value2,value3];
    //3.添加动画
    [self.wordView.layer addAnimation:animation forKey:nil];
    
    
    
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
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
    
    [self performSelector:@selector(gprsUser) withObject:nil afterDelay:2.0];
    [self.view addSubview:self.navigationHeadView];
    
    [self.navigationHeadView addSubview:self.headLabel];
    
    UILongPressGestureRecognizer *mTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.mapView addGestureRecognizer:mTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTabView)];
    [self.navigationHeadView addGestureRecognizer:tap];
    
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


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获取地图上所有的大头针数据模型
       NSArray *annotations = self.mapView.annotations;
    
    // 移除大头针
//       [self.mapView removeAnnotations:annotations];
    
//    [self addAnnotation];
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










//定位当前的位置
-(void)gprsUser
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
            
             
             [self.nameArray addObject:placemark.name];
             [self.nameArray addObject:placemark.thoroughfare];
             [self.nameArray addObject:placemark.subLocality];
             [self.nameArray addObject:placemark.locality];
             [self.nameArray addObject:@""];
             
             
             NSLog(@"成功 %@",[placemark class]);
             NSLog(@"地理名称%@",placemark.name);
             NSLog(@"街道名%@",placemark.thoroughfare);
             NSLog(@"国家%@",placemark.country);
             NSLog(@"城市%@",placemark.locality);
             NSLog(@"区: %@",placemark.subLocality);
             
             NSLog(@"地址%@",placemark.addressDictionary);
             NSLog(@"=======\n");
             
             
             YYAnnotation *annotation=[[YYAnnotation alloc]init];
             annotation.coordinate=loc;
             annotation.title = placemark.name;
             
             if ([type isEqualToString:@"1"]) {
                 
                 [self.mapView addAnnotation:annotation];
                 
                 pointCount +=1;
                 NSDictionary *dict = @{@"pointLocation":location,
                                        @"name":placemark.name,
                                        @"thoroughfare":placemark.thoroughfare,
                                        @"subLocality":placemark.subLocality,
                                        @"locality":placemark.locality,
                                        @"speceTitle":[NSString stringWithFormat:@"%d",pointCount]
                                        };
                 
                 
                 
                 PointModel *model = [[PointModel alloc] initWithDict:dict];
                 
                 
                 [self.pointArray addObject:model];
             }
             
             

             
             
             
             
             
             
             self.titleHead.text = placemark.name;
             [self.mapView addSubview:self.titleHead];
             [self.tableView reloadData];
             
//             [self showTabView];
         }else if (error) {
             
             NSLog(@"error= [ %@ ]",error);
         }
         
         
     }];

}


-(void)line
{
    
    PointModel *model1,*model2;
    
    model1 = self.pointArray[self.pointArray.count-2];
    model2 = self.pointArray.lastObject;
    
    
    [_geocoder reverseGeocodeLocation:model1.pointLocation completionHandler:
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
        
        //遍历
        for (MKRouteStep *step in stepsArray) {
            
            [self.mapView addOverlay:step.polyline];
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
    
    CGFloat tabVieHeight =  self.nameArray.count*44.0;
    
    if (tabVieHeight < kScreenHeight-65-44) {
        self.tableView.frame = CGRectMake(0, 65, kScreenWith,tabVieHeight);
    }else if (tabVieHeight > kScreenHeight-65-44) {
        self.tableView.frame = CGRectMake(0, 65, kScreenWith, kScreenHeight-65-44);
    }
    
    
    return self.nameArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocalNameTableViewCell *cell = [LocalNameTableViewCell LocalNameTableViewCellWithTableView:tableView];
    
    cell.dresssnName = self.nameArray[self.nameArray.count-1-indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"你点击了第行 = %ld",(long)indexPath.row);
}












@end
