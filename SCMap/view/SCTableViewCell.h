//
//  SCTableViewCell.h
//  SCMap
//
//  Created by SHICHUAN on 2017/5/27.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTableViewCell : UITableViewCell
+(SCTableViewCell *)SCTableViewCellAndTableView:(UITableView *)tableView;
-(void)laction:(NSDictionary *)dict;
@end
