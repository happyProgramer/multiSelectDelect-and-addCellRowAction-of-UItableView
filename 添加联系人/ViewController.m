//
//  ViewController.m
//  添加联系人
//
//  Created by 宠爱 on 16/8/13.
//  Copyright © 2016年 iscast. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic, strong) NSMutableArray *listArr;
@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *multipleSelectArrs;
@property(nonatomic, assign) UITableViewCellEditingStyle currentEditingStyle;

@property(weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIButton *globleBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  /// MARK: - 准备表格
  [self prepareTableView];
}

/// MARK:- 输入cell内容按钮
- (IBAction)addClick:(id)sender {
  [self.listArr addObject:self.textField.text];
  [self.tableView reloadData];
    
}


/// MARK:- 删除cell按钮
- (IBAction)moreDelete:(id)sender {
  //     NSLog(@"%s",__func__);
  BOOL flag = self.tableView.editing;

  if (flag) {

    // 得到删除商品的索引
    NSMutableArray *indexArr = [NSMutableArray array];
    for (NSString *str in self.multipleSelectArrs) {
      NSInteger num = [self.listArr indexOfObject:str];

      NSIndexPath *path = [NSIndexPath indexPathForRow:num inSection:0];
      [indexArr addObject:path];
    }

    [self.listArr removeObjectsInArray:self.multipleSelectArrs];
    [self.multipleSelectArrs removeAllObjects];

    [self.tableView deleteRowsAtIndexPaths:indexArr
                          withRowAnimation:UITableViewRowAnimationFade];

    self.tableView.editing = NO;
    self.deleteBtn.selected = NO;
  } else {

    [self.multipleSelectArrs removeAllObjects];
    self.tableView.editing = YES;
    self.deleteBtn.selected = YES;
  }
}


- (IBAction)globleBtnClick:(UIButton *)sender {
    //     NSLog(@"%s",__func__);
    sender.selected = !sender.isSelected;
    BOOL flag = self.tableView.editing;
    if (flag) {
        NSArray *allCell = [self.tableView visibleCells];
        for (UITableViewCell *cell in allCell) {
            
            cell.selected = NO;
        }
        
        self.tableView.editing = NO;
    }else{
    
        NSArray *allCell = [self.tableView visibleCells];
        for (UITableViewCell *cell in allCell) {
            
            cell.selected = YES;
        }
        self.tableView.editing = YES;
    }

    
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  //    NSLog(@"%s",__func__);
  [self.listArr removeObjectAtIndex:indexPath.row];

  [self.tableView reloadData];
}

/// MARK:- 设置编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  //     NSLog(@"%s",__func__);
    // 当多选按钮被点击的时候，编辑的格式换成多选
  if (self.deleteBtn.isHighlighted || self.globleBtn.isHighlighted) {
    self.currentEditingStyle =
        UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
  } else {
    self.currentEditingStyle = UITableViewCellEditingStyleDelete;
  }
  return self.currentEditingStyle;
}

/// MARK:- 设置多个功能按钮
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
                  editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
  //  NSLog(@"%s",__func__);

  UITableViewRowAction *noDeleAction = [UITableViewRowAction
      rowActionWithStyle:UITableViewRowActionStyleDefault
                   title:@"删除"
                 handler:^(UITableViewRowAction *_Nonnull action,
                           NSIndexPath *_Nonnull indexPath) {
                   NSLog(@"删除");
                 [self.listArr removeObjectAtIndex:indexPath.row];
                 [self.tableView reloadData];

                 }];

  UITableViewRowAction *noLoveAction = [UITableViewRowAction
      rowActionWithStyle:UITableViewRowActionStyleDefault
                   title:@"收藏"
                 handler:^(UITableViewRowAction *_Nonnull action,
                           NSIndexPath *_Nonnull indexPath) {
                   NSLog(@"收藏");
                 }];

  UITableViewRowAction *noTopAction = [UITableViewRowAction
      rowActionWithStyle:UITableViewRowActionStyleNormal
                   title:@"置顶"
                 handler:^(UITableViewRowAction *_Nonnull action,
                           NSIndexPath *_Nonnull indexPath) {
                   NSLog(@"置顶");
                 }];

  noDeleAction.backgroundColor = [UIColor redColor];
  noLoveAction.backgroundColor = [UIColor orangeColor];
  noTopAction.backgroundColor = [UIColor lightGrayColor];
  return @[ noDeleAction, noLoveAction, noTopAction ];
}

#pragma mark -  代理方法
// 选择cell
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"%s", __func__);
  if (self.currentEditingStyle !=
      (UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert)) {
    return;
  }

  NSString *str = [self.listArr objectAtIndex:indexPath.row];
  if (![self.multipleSelectArrs containsObject:str]) {
    [self.multipleSelectArrs addObject:str];
  }
}
// 取消选择
- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"%s", __func__);
  if (self.currentEditingStyle !=
      (UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert)) {
    return;
  }

  NSString *str = [self.listArr objectAtIndex:indexPath.row];
  if ([self.multipleSelectArrs containsObject:str]) {
    [self.multipleSelectArrs removeObject:str];
  }
}

- (void)prepareTableView {
    UITableView *tableView = [[UITableView alloc]
                              initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width,
                                                       [UIScreen mainScreen].bounds.size.height - 300)
                              style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self.view addSubview:tableView];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

  return self.listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"cell"];
  }
  cell.textLabel.text = self.listArr[indexPath.row];
  return cell;
}

/// MARK:- 懒加载
- (NSMutableArray *)listArr {
    if (_listArr == nil) {
        _listArr = [NSMutableArray array];
        
        [_listArr addObject:@"12"];
        [_listArr addObject:@"abc"];
    }
    return _listArr;
}

- (NSMutableArray *)multipleSelectArrs {
    if (_multipleSelectArrs == nil) {
        _multipleSelectArrs = [NSMutableArray array];
    }
    return _multipleSelectArrs;
}

@end
