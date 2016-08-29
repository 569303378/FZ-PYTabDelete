//
//  ViewController.m
//  PYduoxuanTableView
//
//  Created by Apple on 16/7/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *myTableView;
@property(nonatomic, strong) NSMutableArray *myArray;
@property(nonatomic, strong) UIBarButtonItem *rightItem;
@property(nonatomic, strong) UIBarButtonItem *leftItem;
@property(nonatomic, assign) BOOL isEditing;
@property(nonatomic, strong) NSString *str;
@property(nonatomic, assign) BOOL is_1;
@end

@implementation ViewController

- (UIBarButtonItem *)rightItem {
    if (_rightItem == nil) {
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightItem:)];
    }
    return _rightItem;
}

- (NSMutableArray *)myArray {
    if (_myArray == nil) {
        _myArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [_myArray addObject:[NSString stringWithFormat:@"第%d个", i]];
        }
    }
    return _myArray;
}

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.str = @"分类";
    [self.view addSubview:self.myTableView];
//    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
}

#pragma mark ====== rightItem:
- (void)rightItem:(UIBarButtonItem *)item {
    
    if (!self.isEditing) {
        
        // 允许多个编辑
        self.myTableView.allowsMultipleSelectionDuringEditing = YES;
        // 允许编辑
        self.myTableView.editing = YES;
        [item setTitle:@"完成"];
        _leftItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftItem:)];
        self.navigationItem.leftBarButtonItem = self.leftItem;
    }else {
        
        [item setTitle:@"编辑"];
        self.navigationItem.leftBarButtonItem = nil;
        // 放置要删除的对象
        NSMutableArray *deleteArray = [NSMutableArray array];
        // 要删除的row
        NSArray *selectedArray = [self.myTableView indexPathsForSelectedRows];
        
        for (NSIndexPath *indexPath in selectedArray) {
            
            [deleteArray addObject:self.myArray[indexPath.row]];
        }
        // 先删除数据源
        [self.myArray removeObjectsInArray:deleteArray];
        // 在删除UI
        [self.myTableView deleteRowsAtIndexPaths:selectedArray withRowAnimation:UITableViewRowAnimationNone];
        // 关掉编辑
        self.myTableView.editing = NO;
    }
    self.isEditing = !self.isEditing;
}

#pragma mark ===== leftItem:
- (void)leftItem:(UIBarButtonItem *)item {
    if ((!_is_1)) {
        
        //全选
        for (int i = 0; i < self.myArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.myTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionTop)];
        }
        _is_1 = YES;

    } else  {

        for (int i = 0; i < self.myArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        _is_1 = NO;
    }

}

#pragma mark ===== tableView代理
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

//页眉
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.str;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierCell = @"identifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifierCell];
    }
    cell.textLabel.text =self.myArray[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
