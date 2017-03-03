//
//  WZZSelectManVC.m
//  WZZ8BitMusicGame
//
//  Created by 舞蹈圈 on 17/3/2.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZSelectManVC.h"
#import "WZZManModel.h"

@interface WZZSelectManVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * dataArr;
    void(^_selectImageBlock)(NSString *);
    WZZManModel * model;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation WZZSelectManVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    dataArr = [NSMutableArray arrayWithArray:[WZZManModel dataArr]];
}

- (void)selectAImage:(void (^)(NSString *))aBlock {
    if (_selectImageBlock != aBlock) {
        _selectImageBlock = aBlock;
    }
}

#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.imageView.image = [UIImage imageNamed:dataArr[indexPath.row][@"image"]];
    cell.textLabel.text = dataArr[indexPath.row][@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectImageBlock) {
        _selectImageBlock(dataArr[indexPath.row][@"image"]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
