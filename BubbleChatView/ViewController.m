//
//  ViewController.m
//  BubbleChatView
//
//  Created by yxhe on 16/11/4.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

// ---- 气泡式聊天界面 ---- //

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;  // 消息列表
@property (weak, nonatomic) IBOutlet UITextField *textField;      // 文字编辑框

@property (strong, nonatomic) NSMutableArray *msgArray; // 消息数组

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 初始化数据
    NSDictionary *dict0 = [NSDictionary dictionaryWithObjectsAndKeys:@"she",@"name",@"你要学会权衡利弊，学会放弃一些什么，然后才可能得到些什么。",@"content", nil];
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"me",@"name",@"你娉婷婉约的风姿，娇艳俏丽的容貌，妩媚得体的举止，优雅大方的谈吐，一开始就令我刮目相看。",@"content", nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"me",@"name",@"曾经的回忆的画面已如烟；忘不掉思念，则抹不去孤独。",@"content", nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"she",@"name",@"很多时候，你永远永远都不会明白，我有多在乎你给我的不在乎。",@"content", nil];
    NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"me",@"name",@"所谓最难忘的，就是从来都不曾想起，却永远无法忘记。",@"content", nil];
    NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"she",@"name",@"苟富贵，勿相忘",@"content", nil];
    NSDictionary *dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"me",@"name",@"成熟的第一个标志，就是学会减少幻想却保留希望，善待眼下仍憧憬未来。",@"content", nil];
    NSDictionary *dict7 = [NSDictionary dictionaryWithObjectsAndKeys:@"she",@"name",@"大江东去，浪淘尽，千古风流人物。故垒西边，人道是，三国周郎赤壁。乱石穿空，惊涛拍岸，卷起千堆雪。江山如画，一时多少豪杰。遥想公瑾当年，小乔初嫁了，雄姿英发。羽扇纶巾，谈笑间，樯橹灰飞烟灭。故国神游，多情应笑我，早生华发。人生如梦，一樽还酹江月。",@"content", nil];
    NSDictionary *dict8 = [NSDictionary dictionaryWithObjectsAndKeys:@"she",@"name",@"时光锁住了匆匆，记忆快乐着凄迷的温婉，把爱情的缱绻已写成了心的旋律。",@"content", nil];
    NSDictionary *dict9 = [NSDictionary dictionaryWithObjectsAndKeys:@"me",@"name",@"人生就像蒲公英，看似自由，却身不由己。有些事，不是不在意，而是在意了又能怎样，自己尽力了就好。",@"content", nil];
    
    // 添加数据
    _msgArray = [NSMutableArray arrayWithObjects:dict0, dict1, dict2, dict3, dict4, dict5, dict6, dict7, dict8, dict9, nil];
    
    // 初始化列表
    _chatTableView.backgroundColor = [UIColor greenColor];
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    
    // 编辑框
    _textField.delegate = self;
}

#pragma 点击发送文字
- (IBAction)sendBtn:(id)sender
{
    // 发送文字
    NSDictionary *msgDict = [NSDictionary dictionaryWithObjectsAndKeys:@"me", @"name", _textField.text, @"content", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 列表代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 根据内容调整cell高度
    NSDictionary *dict = [_msgArray objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [[dict objectForKey:@"content"] sizeWithFont:font
                                             constrainedToSize:CGSizeMake(180.0f, 20000.0f)
                                                 lineBreakMode:NSLineBreakByWordWrapping];
    
//    return size.height + 44;
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _msgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // 添加一些东西
    for (UIView *view in cell.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (indexPath.row % 2)
    {
        cell.backgroundColor = [UIColor yellowColor];
    }
    else
    {
        cell.backgroundColor = [UIColor redColor];
    }
    
    //创建头像
    NSDictionary *dict = [_msgArray objectAtIndex:indexPath.row];
    if ([[dict objectForKey:@"name"] isEqualToString:@"she"])
    {
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        avatar.image = [UIImage imageNamed:@"photo"];
        [cell addSubview:avatar];
        
        
    }
    else
    {
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 10 - 50, 10, 50, 50)];
        avatar.image = [UIImage imageNamed:@"photo1"];
        [cell addSubview:avatar];
        
    }
    
    
    return cell;
}

#pragma mark - 编辑框代理
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // 开始输文字，就把列表上移
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // 收起键盘，列表下移
    
}

@end
