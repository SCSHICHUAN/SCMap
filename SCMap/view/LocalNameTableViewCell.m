//
//  LocalNameTableViewCell.m
//  SCMap
//
//  Created by SHICHUAN on 2017/4/20.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import "LocalNameTableViewCell.h"

@interface LocalNameTableViewCell()
{
    int   nameCount;
}
@end


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
-(void)awakeFromNib
{
    [super awakeFromNib];
    nameCount = 0;
}
-(void)setDresssnName:(NSString *)dresssnName
{
    _dresssnName = dresssnName;
    self.localName.text = dresssnName;
    
    if (dresssnName.length == 0) {
        nameCount +=1;
        self.localName.text = @"◉";
        self.localName.font = [UIFont boldSystemFontOfSize:30];
        self.localName.textColor = [UIColor colorWithRed:5.0/255 green:124.0/255 blue:255.0/255 alpha:1.0];
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    }else{
        self.localName.textColor = [UIColor whiteColor];
        self.localName.font = [UIFont systemFontOfSize:17];
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    }
    
}


@end
