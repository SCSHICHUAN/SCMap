//
//  LocalNameTableViewCell.h
//  SCMap
//
//  Created by SHICHUAN on 2017/4/20.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalNameTableViewCell : UITableViewCell
+(LocalNameTableViewCell *)LocalNameTableViewCellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *localName;
@property(nonatomic,strong)NSString *dresssnName;
@end
