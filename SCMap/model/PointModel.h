//
//  PointModel.h
//  DYSport2
//
//  Created by SHICHUAN on 2017/4/19.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;
@interface PointModel : NSObject
@property (nonatomic,strong)CLLocation *pointLocation;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *thoroughfare;
@property (nonatomic,strong)NSString *subLocality;
@property (nonatomic,strong)NSString *locality;
@property (nonatomic,strong)NSString *speceTitle;

-(PointModel *)initWithDict:(NSDictionary *)dict;
@end
