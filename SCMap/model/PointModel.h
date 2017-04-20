//
//  PointModel.h
//  DYSport2
//
//  Created by SHICHUAN on 2017/4/19.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointModel : NSObject
@property (nonatomic,strong)NSString *logitude;
@property (nonatomic,strong)NSString *latitude;
-(PointModel *)initWithDict:(NSDictionary *)dict;
@end
