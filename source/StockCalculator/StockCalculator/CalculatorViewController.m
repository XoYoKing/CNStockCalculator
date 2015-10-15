//
//  CalculatorViewController.m
//  cnstockcalculator
//
//  Created by zuohaitao on 15/10/13.
//  Copyright © 2015年 zuohaitao. All rights reserved.
//

#import "CalculatorViewController.h"
#import "InputCell.h"

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.kindOfTrade = YES;
    // Do any additional setup after loading the view, typically from a nib.
    self.keyBoardBackground = [[UIButton alloc]initWithFrame:self.layout.frame];
    self.keyBoardBackground.backgroundColor = [UIColor clearColor];
    [self.keyBoardBackground addTarget:self action:@selector(hideKeyBoard:) forControlEvents:UIControlEventTouchDown];
    self.keyBoardBackground.hidden = YES;
    
    UINib* nib =[UINib nibWithNibName:@"InputCell" bundle:nil];
    [self.layout registerNib:nib forCellReuseIdentifier:@"InputCell"];
    
    self.all = @[
                    @[
                        @{
                            @"title":@"股票代码"
                            ,@"placeholder":@"代码／名称"
                        },@{
                            @"title":@"股票类型"
                        },@{
                            @"title":@"买入价格"
                            ,@"placeholder":@"0.00"
                        },@{
                            @"title":@"买入数量"
                            ,@"placeholder":@"0"
                            
                        },@{
                            @"title":@"卖出价格"
                            ,@"placeholder":@"0.00"
                        },@{
                            @"title":@"卖出数量"
                            ,@"placeholder":@"0"
                        },@{
                            @"title":@"券商佣金比率"
                            ,@"placeholder":@"0"
                        },@{
                            @"title":@"印花税税率"
                            ,@"placeholder":@"0"
                        },@{
                            @"title":@"过户费费率"
                            ,@"placeholder":@"0"
                        }
                    ],
                   [NSArray arrayWithObjects:
                    @"过户费",
                    @"印花税",
                    @"券商佣金",
                    @"税费合计",
                    @"投资损益",
                    nil],
                ];
    self.cur = [NSMutableArray array];

    for (id a in self.all) {
        [self.cur addObject:[NSMutableArray arrayWithArray:a]];
        
    }
    
}

-(void)hideKeyBoard:(id)sender {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
#pragma clang diagnostic pop
    [firstResponder resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

-(void) keyboardWillShow:(NSNotification *)note
{
    if (self.keyBoardBackground.hidden == NO) {
        return;
    }
    [self.view addSubview:self.keyBoardBackground];
    self.keyBoardBackground.hidden = NO;

    CGRect keyboardRect = [self.view convertRect:[[[note userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    if (CGRectIsEmpty(keyboardRect)) {
        return;
    }
    
    self.layoutOriginContentOffset = self.layout.contentOffset;
    CGRect frame = self.layout.frame;
    frame.size.height = keyboardRect.origin.y - self.layout.frame.origin.y - 10;
    NSValue* duration = [[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval interval;
    [duration getValue:&interval];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:interval];
    self.layout.frame = frame;
}

- (void)keyboardWillHide:(NSNotification*)note {
    if (self.keyBoardBackground.hidden == YES) {
        return;
    }
    self.keyBoardBackground.hidden = YES;
    [self.keyBoardBackground removeFromSuperview];


    NSValue* duration = [[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval interval;
    [duration getValue:&interval];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:interval];
    self.layout.contentOffset = self.layoutOriginContentOffset;
}
/*
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *) [self.tableView viewWithTag:self.currentTextField.tag]];
    UITableViewCell *cell = (UITableViewCell *) [textField superview];
    indexPath = [self.tableView indexPathForCell:cell];
    //[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //int currentIndex = textField.tag;
    CGRect frame = textField.frame;
    CGFloat rowHeight = self.tableView.rowHeight;
    //下面的代码只是为了判断是哪一个textField,可以根据自己的情况进行修改，我为了测试加了7个
    if (indexPath.row == 0) {
        frame.origin.y += rowHeight * 0;
    } else if (indexPath.row==1) {
        frame.origin.y += rowHeight * 1;
    } else if (indexPath.row == 2) {
        frame.origin.y += rowHeight * 2;
    } else if (indexPath.row ==3){
        frame.origin.y += rowHeight * 3;
    }else if(indexPath.row==4)
    {
        frame.origin.y +=rowHeight *4;
    } else if(indexPath.row==5)
    {
        frame.origin.y +=rowHeight *5;
    } else if(indexPath.row==6)
    {
        frame.origin.y +=rowHeight *6;
    }
    CGFloat viewHeight = self.tableView.frame.size.height;
    CGFloat halfHeight = viewHeight / 2;
    CGFloat halfh= frame.origin.y +(textField.frame.size.height / 2);
    if(halfh<halfHeight){
        frame.origin.y = 0;
        frame.size.height =halfh;
    }else{
        frame.origin.y =halfh;
        frame.size.height =halfh;
    }
    [self.tableView scrollRectToVisible:frame animated:YES ];
}
*/

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cur.count;
}

- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView
          titleForHeaderInSection:(NSInteger)section {
    return nil;//[NSString stringWithFormat:@"%ld", section];
}

- (NSInteger)tableView:(UITableView * _Nonnull)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.cur[section] count];
}

- (NSArray<NSString *>*)sectionIndexcurForTableView:(UITableView * _Nonnull)tableView {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString * id = @"id";
    
    
    InputCell* c = [tableView dequeueReusableCellWithIdentifier:@"InputCell"];
    c.input.delegate = self;
    
    if (indexPath.section == 1) {
        c.input.placeholder = @"...";
        c.title.text = self.cur[indexPath.section][indexPath.row];
    }
    else {
        NSDictionary* item = self.cur[indexPath.section][indexPath.row];
        if ([item objectForKey:@"placeholder"] != nil) {
            c.input.placeholder = item[@"placeholder"];
        }
        else {
            
        }
        c.title.text = self.cur[indexPath.section][indexPath.row][@"title"];

    }
    return c;
}

#pragma mark -
#pragma mark Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSIndexPath* path = [self.layout indexPathForCell:(UITableViewCell*)textField.superview.superview];
    if (self.cur[path.section][path.row][@"placeholder"] == nil) {
        return NO;
    }
    
    return YES;
    
}

#pragma mark -
#pragma mark Table View Delegate


- (IBAction)changeTradeType:(id)sender {
    self.kindOfTrade = !self.kindOfTrade;
    if (!self.kindOfTrade) {
        [self.cur[0] removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4,2)]];
    }
    else {
        [self.cur[0] insertObject:self.all[0][3] atIndex:4];
        [self.cur[0] insertObject:self.all[0][3] atIndex:5];
    }
    [self.layout reloadData];

}
@end
