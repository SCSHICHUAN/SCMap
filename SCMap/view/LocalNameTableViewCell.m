//
//  LocalNameTableViewCell.m
//  SCMap
//
//  Created by SHICHUAN on 2017/4/20.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import "LocalNameTableViewCell.h"

@implementation LocalNameTableViewCell

+(LocalNameTableViewCell *)LocalNameTableViewCellWithTableView:(UITableView *)tableView
{
    static   NSString *cellIdentfer = @"cellIdentfer";
    LocalNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfer];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LocalNameTableViewCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

-(void)setDresssnName:(NSString *)dresssnName
{
    _dresssnName = dresssnName;
    self.localName.text = dresssnName;
}


@end
