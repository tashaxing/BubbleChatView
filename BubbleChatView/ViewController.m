//
//  ViewController.m
//  BubbleChatView
//
//  Created by yxhe on 16/11/4.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

// ---- 气泡式聊天界面 ---- //

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *chatTableView;  // 消息列表
@property (nonatomic, strong) UITextField *textField;      // 文字编辑框
@property (nonatomic, strong) UIButton *sendBtn;           // 发送按钮

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
    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 40 - 50) style:UITableViewStylePlain];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.allowsSelection = NO;
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    [self.view addSubview:_chatTableView];

    // 编辑框
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width - 50, 40)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.delegate = self;
    [self.view addSubview:_textField];
    
    // 发送按钮
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn.frame = CGRectMake(self.view.frame.size.width - 50, self.view.frame.size.height - 40, 50, 40);
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.sendBtn addTarget:self
                     action:@selector(sendBtn:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendBtn];
    
    
    // 注册键盘通知
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification object:nil];

}

#pragma 点击发送文字
- (void)sendBtn:(id)sender
{
    // 发送文字
    int x = arc4random() % 100; // 随机出现模拟发送或接收
    NSDictionary *msgDict = [NSDictionary dictionaryWithObjectsAndKeys:x % 2 ? @"me" : @"she", @"name", _textField.text, @"content", nil];
    [_msgArray addObject:msgDict];
    
    // 刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatTableView reloadData];
        // 根据新增行的高度重新定位到最底下
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [[msgDict objectForKey:@"content"] sizeWithFont:font
                                                 constrainedToSize:CGSizeMake(180.0f, 20000.0f)
                                                     lineBreakMode:NSLineBreakByWordWrapping];
        self.chatTableView.contentSize = CGSizeMake(_chatTableView.contentSize.width, _chatTableView.contentSize.height + size.height + 40);
        
        [self.chatTableView setContentOffset:CGPointMake(0, _chatTableView.contentSize.height - _chatTableView.frame.size.height) animated:YES];
    });
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
    
    return size.height + 40;
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
    // 添加每条消息
    for (UIView *view in cell.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSDictionary *dict = [_msgArray objectAtIndex:indexPath.row];
    NSString *text = [dict objectForKey:@"content"];
    UIFont *textFont = [UIFont systemFontOfSize:14];
    // 根据字符长度去限制size
    CGSize textSize = [text sizeWithFont:textFont
                       constrainedToSize:CGSizeMake(180.0f, 20000.0f)
                           lineBreakMode:NSLineBreakByWordWrapping];

    
    if ([[dict objectForKey:@"name"] isEqualToString:@"she"])
    {
        // 创建头像
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 50, 50)];
        avatar.image = [UIImage imageNamed:@"photo"];
        [cell addSubview:avatar];
        
        // 文字信息
        UIImage *bubbleImg = [UIImage imageNamed:@"ReceiverTextNodeBkg.png"];
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubbleImg stretchableImageWithLeftCapWidth:floorf(bubbleImg.size.width / 2) topCapHeight:floorf(bubbleImg.size.height / 2)]];
        
        UILabel *bubbleTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, textSize.width + 10, textSize.height + 10)];
        bubbleTextLabel.backgroundColor = [UIColor clearColor];
        bubbleTextLabel.font = textFont;
        bubbleTextLabel.numberOfLines = 0; // 这句很关键
        bubbleTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        bubbleTextLabel.text = text;

        bubbleImageView.frame = CGRectMake(10 + 50, 0, bubbleTextLabel.frame.size.width + 40.0f, bubbleTextLabel.frame.size.height + 30.0f);
        [bubbleImageView addSubview:bubbleTextLabel];
        
        [cell addSubview:bubbleImageView];
        

    }
    else
    {
        UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width - 10 - 50, 0, 50, 50)];
        avatar.image = [UIImage imageNamed:@"photo1"];
        [cell addSubview:avatar];
        
        UIImage *bubbleImg = [UIImage imageNamed:@"SenderTextNodeBkg.png"];
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubbleImg stretchableImageWithLeftCapWidth:floorf(bubbleImg.size.width / 2) topCapHeight:floorf(bubbleImg.size.height / 2)]];
        
        UILabel *bubbleTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, textSize.width + 10, textSize.height + 10)];
        bubbleTextLabel.backgroundColor = [UIColor clearColor];
        bubbleTextLabel.font = textFont;
        bubbleTextLabel.numberOfLines = 0; // 这句很关键
        bubbleTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        bubbleTextLabel.text = text;
        
        bubbleImageView.frame = CGRectMake(tableView.frame.size.width - 10 - 50 - bubbleTextLabel.frame.size.width - 40.0f, 0, bubbleTextLabel.frame.size.width + 40.0f, bubbleTextLabel.frame.size.height + 30.0f);
        [bubbleImageView addSubview:bubbleTextLabel];
        
        [cell addSubview:bubbleImageView];

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

#pragma mark - 键盘通知
-(void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    
    self.view.transform = CGAffineTransformMakeTranslation(0, keyboardY - self.view.frame.size.height);
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    
    self.view.transform = CGAffineTransformMakeTranslation(0, keyboardY - self.view.frame.size.height);
}

#pragma mark - 触摸响应
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
