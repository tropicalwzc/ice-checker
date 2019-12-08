//
//  BIDBlueViewController.m
//  multi_view_test
//
//  Created by 王子诚 on 2018/11/28.
//  Copyright © 2018 王子诚. All rights reserved.
//

#import "Booklist.h"
#import "smallwindow.h"
@interface Booklist ()

@property (weak, nonatomic) IBOutlet UIButton *delallbutton;
@property (strong, nonatomic) IBOutlet UITextField *booklist_price_label;
@property (weak, nonatomic) IBOutlet UINavigationItem *mainbar;

@end

@implementation Booklist

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if(file_controller==nil)
    file_controller=[[filer alloc]init];
    if(window_controller==nil)
    window_controller=[[smallwindow alloc]init_with_fatherwindow:self];

    CGRect Screensize=[UIScreen mainScreen].bounds;
    long ScreenWidth=Screensize.size.width;
    long ScreenHeight=Screensize.size.height;
        long area_all=ScreenHeight*ScreenWidth;
    if(area_all>500000)
        isipad=true;
    else isipad=false;
    
    [self fetch_classmate_names];
    if(book_id!=-1)
    {
        booklist_file_title=[self get_bookedlist_file_title:book_id];
        NSString*str=[file_controller File_read:booklist_file_title];
        //NSLog(@"%@",str);
        if(![self release_book:str to:booked_this])
            for(int i=0;i<200;++i)
                booked_this[i]=0;
        
        [self setTitle:classmate_name[book_id]];
    }
    else{
        [self read_all_from_booklistfiles];
        [self setTitle:@"书目管理"];
    }
   // [self read_current_id_from_file];
    [self load_origin_data_from_files];
    // Do any additional setup after loading the view.
}
-(void)load_origin_data_from_files
{
    total_book_number=0;
    [self fetch_total_booknum];
    [self fetch_booknames];
    [self fetch_price];
    [self calculate_price];
    [self display_price];
   // NSLog(@"now have %d",total_book_number);
}
- (void)viewWillAppear:(BOOL)animated
{
    [self load_origin_data_from_files];
    [self.tableView reloadData];
    if(book_id!=-1)
    {
        [ _delallbutton setTitle:@"" forState:UIControlStateNormal];
    }
    else{
        [ _delallbutton setTitle:@"删除所有书" forState:UIControlStateNormal];
    }
}
-(Booklist*)init_with_father_window:(Namelist*)father_win
{
    father_window=father_win;
    return self;
}
-(int)fetch_total_booknum
{
    NSString* str=[file_controller File_read:@"total_booknum_file"];
   // NSLog(@"read %@",str);
    if(str==nil)
    {
        total_book_number=0;
        return 0;
    }
    else{
        total_book_number=(int)str.integerValue;
        if(total_book_number<0)
            total_book_number=0;
        return total_book_number;
    }
}
- (IBAction)Add_a_book:(UIBarButtonItem *)sender {
                [self Input_name_and_price_Message_for_newbook];
}

-(void)save_total_booknum
{
    int aim=total_book_number;
    if(total_book_number<=0)
    {
        aim=-1;
    }
    NSString*str=[[NSString alloc]initWithFormat:@"%d",aim];
    //NSLog(@"saving %@",str);
    [file_controller File_Save:str to:@"total_booknum_file"];
}
-(NSString*)get_pricefile_title:(int)ider
{
    NSString*titer=[[NSString alloc]initWithFormat:@"bookprice_of_id_%d",ider];
    return titer;
}
-(NSString*)get_bookedlist_file_title:(int)ider
{
    NSString*titer=[[NSString alloc]initWithFormat:@"booklist_file_%d",ider];
    return titer;
}
-(NSString*)get_book_names_file_title:(int)ider
{
    NSString*titer=[[NSString alloc]initWithFormat:@"bookname_file_%d",ider];
    return titer;
}
-(void)fetch_price
{
    for(int i=0;i<total_book_number;i++)
    {
        prices[i]=[file_controller File_read:[self get_pricefile_title:i]];

        if(prices[i]!=nil)
            pricer[i]=prices[i].floatValue;
        else pricer[i]=0;
    }
}
- (IBAction)deleteall:(UIButton *)sender {
    [window_controller Sure_or_not_window_with_title:@"确定删除该书单？" andMessage:@"⚠️该动作无法撤销" process_func:@selector(delete_all_act) sure_button_title:@"删除" cancle_button_title:@"取消"];
}
-(void)delete_all_act
{
    if(book_id==-1)
    for(int i=total_book_number-1;i>=0;i--)
    {
        [self Delete_book:i];
    }
    [self save_total_booknum];
    [self.tableView reloadData];
}
-(void)fetch_booknames
{
    int i;
    for(i=0;i<200;i++)
    {
        NSString* str=[file_controller File_read:[self get_book_names_file_title:i]];
      //  NSLog(@"%@",str);
        if(str==nil||[str isEqualToString:@"nil"]||[str isEqualToString:@""])
            break;
        booknames_str[i]=str;
    }

}
-(float)calculate_price
{
    total_use=0;
    //NSLog(@"mode %d",book_id);
    if(book_id!=-1)
    for(int i=0;i<total_book_number;++i)
    {
        if(booked_this[i]!=0)
        {
            if(pricer[i]==0)
            {
            NSString*tmp=prices[i];
            pricer[i]=tmp.floatValue;
            }
            total_use+=pricer[i];
        }
    }
    else{
        [self calculate_total_booknumbers];
        for(int i=0;i<total_book_number;++i)
        {
            if(pricer[i]==0)
            {
            NSString*tmp=prices[i];
            pricer[i]=tmp.floatValue;
            }
            total_use+=booked_total_num[i]*pricer[i];
        }
    }
    return total_use;
}
-(void)set_class_mate_names:(NSArray*) str
{
    classmate_name_array=[father_window get_classmate_names];
    classmate_total_number=(int)classmate_name_array.count;
    
    for(int i=0;i<classmate_name_array.count;++i)
        classmate_name[i]=str[i];
    
   // NSLog(@"total classmate %d",classmate_total_number);
}
-(void)read_all_from_booklistfiles
{
    if(file_controller==nil)
    file_controller=[[filer alloc]init];
    
    for(int j=0;j<classmate_total_number;++j)
    {
        booklist_file_title=[self get_bookedlist_file_title:j];
        NSString*str=[file_controller File_read:booklist_file_title];
        [self release_book:str to:users_books[j]];
    }
}
-(void)calculate_total_booknumbers
{
    for(int i=0;i<total_book_number;i++)
    {
        booked_total_num[i]=0;
        for(int j=0;j<classmate_total_number;++j)
        {
            if(users_books[j][i]!=0)
                booked_total_num[i]++;
        }
    }
}
-(void)display_price
{
    _booklist_price_label.text=[[NSString alloc]initWithFormat:@"¥%.2f",total_use];
}
-(NSString*)pack_book:(int[200])aim
{
    NSString* str=[[NSString alloc]initWithFormat:@""];
    for(int i=0;i<total_book_number;++i)
    {
        NSString* tmp=[[NSString alloc]initWithFormat:@"%d",aim[i]];
        str=[str stringByAppendingString:tmp];
    }
    return str;
}
-(int)release_book:(NSString*)data to:(int[200])list;
{
    int len=(int)data.length;
    if(data.length==0)
        return 0;
    if(total_book_number==0)
    {
        total_book_number=len;
    }
    const char*dir=[data UTF8String];
    for(int i=0;i<len;++i)
    {
        list[i]=dir[i]-'0';
    }
    return 1;
}

-(void)set_bookid:(int)ider
{
    book_id=ider;
    
    if(classmate_total_number==0){
        [self fetch_classmate_names];
    }
    if(book_id!=-1)
    {
        booklist_file_title=[self get_bookedlist_file_title:book_id];
        NSString*str=[file_controller File_read:booklist_file_title];
        [self setTitle:classmate_name[book_id]];
        
        if(![self release_book:str to:booked_this])
            for(int i=0;i<200;++i)
                booked_this[i]=0;
    }
    else{
        [self setTitle:@"书目管理"];
        [self read_all_from_booklistfiles];
        
            for(int i=0;i<total_book_number;++i)
                booked_this[i]=0;
    }
}
-(void)fetch_classmate_names
{
    NSArray* dwarves=[father_window get_classmate_names];
    for(int j=0;j<dwarves.count;++j)
    {
        classmate_name[j]=dwarves[j];
    }
    classmate_total_number=(int)dwarves.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(book_id==-1&&total_book_number<199)
    return total_book_number+1;
    else return total_book_number;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* SimpleTableIdentifier=@"SimpleTableIdentifier";
    UITableViewCell* Cell=[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(Cell==nil)
    {
        Cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    if(book_id!=-1)
    Cell.textLabel.text=booknames_str[indexPath.row];
    else{
        if(indexPath.row<total_book_number)
        Cell.textLabel.text=[[NSString alloc]initWithFormat: @"(%d) %@ [¥%.2f]",booked_total_num[indexPath.row],booknames_str[indexPath.row],pricer[indexPath.row]];
        else Cell.textLabel.text=@"➕";
    }
    Cell.textLabel.font=[UIFont systemFontOfSize:13];

    
    Cellstore[indexPath.row]=Cell;
    
    if(booked_this[indexPath.row]==0)
    {
        Cell.imageView.image=NULL;
        //Cellstore[indexPath.row].textLabel.textColor=UIColor.blackColor;
    }
    else{
        Cell.imageView.image=[UIImage imageNamed:@"right"];
        //Cellstore[indexPath.row].textLabel.textColor=[UIColor colorNamed:@"Dimgreen"];
    }
    return Cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(book_id==-1)
        return YES;
    
    return NO;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        [self Delete_book:(int)indexPath.row];
    }
}
-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(book_id!=-1)
    {
        if(booked_this[indexPath.row]==0)
        {
            booked_this[indexPath.row]=1;
            Cellstore[indexPath.row].imageView.image=[UIImage imageNamed:@"right"];
          //  Cellstore[indexPath.row].textLabel.textColor=[UIColor colorNamed:@"Dimgreen"];
            total_use+=pricer[indexPath.row];
        }
        else{
            booked_this[indexPath.row]=0;
            Cellstore[indexPath.row].imageView.image=NULL;
         //   Cellstore[indexPath.row].textLabel.textColor=UIColor.blackColor;
            total_use-=pricer[indexPath.row];
        }
        [father_window set_user_books_bit_at:book_id y:(int)indexPath.row val:booked_this[indexPath.row]];
        
        [self display_price];
        [file_controller File_Save:[self pack_book:booked_this] to:booklist_file_title];
    }
    else{
        if(indexPath.row<total_book_number)
        {
        NSString*str=[[NSString alloc]initWithFormat:@""];
        focus_id=(int)indexPath.row;
        for(int i=0;i<classmate_total_number;++i)
        {
            if(users_books[i][indexPath.row]!=0)
            {
                str=[str stringByAppendingFormat:@"%@\n",classmate_name[i]];
            }
        }
        NSString*tit=[[NSString alloc]initWithFormat:@"共计 : %d",booked_total_num[focus_id]];
        [self NewsMessageWithTitle: tit andMessage:str];
        }
        else{
            [self Input_name_and_price_Message_for_newbook];
        }
    }
}
-(BOOL)Delete_book:(int)ider
{
    if(ider<0)
        return false;
   // NSLog(@"del %d",ider);
    for(int p=0;p<classmate_total_number;++p)
        users_books[p][ider]=0;
    
        for(int j=ider;j<total_book_number;j++)
        {
            [file_controller File_Save:[file_controller File_read:[self get_pricefile_title:j+1]] to:[self get_pricefile_title:j]];
            [file_controller File_Save:[file_controller File_read:[self get_book_names_file_title:j+1]] to:[self get_book_names_file_title:j]];
            
            pricer[j]=pricer[j+1];
            booknames_str[j]=booknames_str[j+1];
            [father_window set_books_name:booknames_str[j] at:j];
            
            booked_total_num[j]=booked_total_num[j+1];
            
            for(int p=0;p<classmate_total_number;++p)
            {
                users_books[p][j]=users_books[p][j+1];
            }
        }
    booknames_str[total_book_number-1]=@"nil";
    total_book_number--;
    [father_window set_user_books_data:users_books];
    [father_window set_total_booknumber:total_book_number];
    
    for(int i=0;i<classmate_total_number;++i)
    {
        [file_controller File_Save:[self pack_book:users_books[i]]to:[self get_bookedlist_file_title:i]];
    }
    [self save_total_booknum];
    [self flush_view];

    return YES;
}
-(void)set_father_window:(Namelist*)aim
{
    father_window=aim;
}
-(void)flush_view
{
    [self calculate_price];
    [self calculate_total_booknumbers];
    _booklist_price_label.text=[[NSString alloc]initWithFormat:@"¥%.2f",total_use];
    [self.tableView reloadData];
}
-(void)Booked_all_member_to_focus_id
{
    for(int i=0;i<classmate_total_number;++i)
    {
        users_books[i][focus_id]=1;
        [father_window set_user_books_bit_at:i y:focus_id val:1];
    }
    
    for(int i=0;i<classmate_total_number;++i)
        [file_controller File_Save:[self pack_book:users_books[i]] to:[self get_bookedlist_file_title:i]];
    [self flush_view];
}

-(void)NewsMessageWithTitle:(NSString*)title andMessage:(NSString*)message{
    UIAlertController * alert;
    if(!isipad)
    alert= [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleActionSheet];
    else{
            alert= [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleAlert];
    }
    
    NSString*price_str=[[NSString alloc]initWithFormat:@"%.2f",pricer[focus_id]];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    if(book_id==-1)
    {
        NSString* pstr=[[NSString alloc]initWithFormat:@" ¥%.2f",pricer[focus_id]];
        UIAlertAction* change_price_action = [UIAlertAction actionWithTitle:pstr style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [self Input_a_new_price:self->booknames_str[self->focus_id] price:price_str];
    }];

        NSString* nstr=booknames_str[focus_id];
        UIAlertAction* change_name_action = [UIAlertAction actionWithTitle:nstr style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [self Input_a_new_name:nstr];
        }];
        
        UIAlertAction* select_all_action = [UIAlertAction actionWithTitle:@"为所有同学订这本书" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action) {
            [self->window_controller Sure_or_not_window_with_title:self->booknames_str[self->focus_id]
            andMessage:@"确定为所有同学订购这本书?" process_func:@selector(Booked_all_member_to_focus_id) sure_button_title:@"是" cancle_button_title:@"否"];
        }];

        [alert addAction:change_name_action];
        [alert addAction:change_price_action];
        [alert addAction:select_all_action];
    }
    [self presentViewController: alert animated: YES completion:nil];
}

-(void)name_input:(NSString*)texter
{
    [self->file_controller File_Save:texter to:[self get_book_names_file_title:self->focus_id]];
    self->booknames_str[self->focus_id]=texter;
    [self.tableView reloadData];
}
-(void)price_input:(NSString*)texter
{
    NSMutableArray* pricers=(NSMutableArray *)[texter componentsSeparatedByString:@"/"];
    double final_single=0;
    if(pricers.count==1)
    {
        final_single=[pricers[0] doubleValue];
    }
    else{
        final_single=[pricers[0] doubleValue];
        double cker=[pricers[1] doubleValue];
        final_single/=cker;
    }
    NSString* price_final_str=[[NSString alloc]initWithFormat:@"%lf",final_single];
    
    [self->file_controller File_Save:price_final_str to:[self get_pricefile_title:self->focus_id]];
    self->pricer[self->focus_id]=final_single;
    [self calculate_price];
    [self display_price];
    [self.tableView reloadData];
}
-(void)Input_a_new_name:(NSString*)origin_name{
    
    [window_controller Input_one_line_window_with_title:@"输入书的新名字" andMessage:origin_name placeholder:origin_name process_NSString_func:@selector(name_input:)];
}
-(void)Input_a_new_price:(NSString*)origin_name price:(NSString*)origin_price_str{

    NSString* tit=[[NSString alloc]initWithFormat:@"更改%@单价",origin_name];
    [window_controller Input_one_line_window_with_title:tit andMessage:@"输入单价\n或者可以输入X/Y格式\n其中X为总价，Y为订书总数" placeholder:origin_price_str process_NSString_func:@selector(price_input:)];
}
-(void)Input_name_and_price_Message_for_newbook
{
    
UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"添加一本新书"
                                                                          message: @"输入书名和单价\n如果没算出来单价\n可以输入X/Y格式\n其中X为总价，Y为订书总数"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.placeholder = @"新书的名字";
   // textField.textColor = [UIColor darkGrayColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleRoundedRect;
}];
[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.placeholder = @"新书的单价";
   // textField.textColor = [UIColor lightGrayColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    //textField.secureTextEntry = YES;
}];
[alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    NSArray * textfields = alertController.textFields;
    UITextField * namefield = textfields[0];
    UITextField * pricefiled = textfields[1];
    NSString* pr_str=pricefiled.text;
    NSMutableArray* pricers=(NSMutableArray *)[pr_str componentsSeparatedByString:@"/"];
    double final_single=0;
    if(pricers.count==1)
    {
        final_single=[pricers[0] doubleValue];
    }
    else{
        final_single=[pricers[0] doubleValue];
        double cker=[pricers[1] doubleValue];
        final_single/=cker;
    }
    NSString* price_final_str=[[NSString alloc]initWithFormat:@"%lf",final_single];
    [self->file_controller File_Save:namefield.text to:[self get_book_names_file_title:self->total_book_number]];
    [self->file_controller File_Save:price_final_str to:[self get_pricefile_title:self->total_book_number]];
    self->booknames_str[self->total_book_number]=namefield.text;
    self->pricer[self->total_book_number]=final_single;
    
    for(int i=0;i<self->classmate_total_number;++i)
        self->users_books[i][self->total_book_number]=0;
    [self->father_window set_books_name:self->booknames_str[self->total_book_number] at:self->total_book_number];
    
    self->total_book_number++;
    [self->father_window set_total_booknumber:self->total_book_number];
    [self->father_window set_user_books_data:self->users_books];
    [self save_total_booknum];
    [self flush_view];
    //NSLog(@"%@:%@",namefield.text,passwordfiled.text);
    
}]];
    UIAlertAction * action_cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action_cancle];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)set_newly_recev_books:(NSMutableArray*)newbooks
{
    newly_recev_books=newbooks;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
