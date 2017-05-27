

//
//  SCTableViewCell.m
//  SCMap
//
//  Created by SHICHUAN on 2017/5/27.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import "SCTableViewCell.h"

@interface SCTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *localation;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end


@implementation SCTableViewCell
+(SCTableViewCell *)SCTableViewCellAndTableView:(UITableView *)tableView
{
    static NSString *cellIdenitifet = @"idenitifre";
    SCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenitifet];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SCTableViewCell" owner:nil options:nil].firstObject;
    }
    return cell;
}
-(void)laction:(NSDictionary *)dict
{
    NSString *name = dict[@"localation"];
    NSString *time = [NSString stringWithFormat:@"%@:%@",dict[@"hour"],dict[@"mim"]];
    self.localation.text = name;
    self.time.text = time;
}
@end
