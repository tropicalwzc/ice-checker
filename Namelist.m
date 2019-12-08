//
//  BIDSwitchViewController.m
//  multi_view_test
//
//  Created by 王子诚 on 2018/11/28.
//  Copyright © 2018 王子诚. All rights reserved.
//

#import "Namelist.h"
#import "Booklist.h"
#import "Sendview.h"
#import "Fileview.h"
#import "importname.h"
@interface Namelist ()

@property (copy,nonatomic) NSMutableArray* dwarves;
@property (strong,nonatomic)Booklist* blueviewer;
@property (strong,nonatomic)importname* importviewer;
@property (strong,nonatomic)Sendview* sendviewer;
@property (strong,nonatomic)Fileview* fileviewer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *choicer;

@end

@implementation Namelist

- (void)viewDidLoad {
    
    [super viewDidLoad];

   // self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
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
    
    self.dwarves=  [file_controller File_read_Mutable_Array:@"classnametotal"];
    if(_importviewer==nil)
    {
        self.importviewer=[self.storyboard instantiateViewControllerWithIdentifier:@"importer"];
        [self.importviewer set_father_win:self];
    }
    if(_dwarves.count<1)
    {
        [self.navigationController pushViewController:_importviewer animated:YES];
    }
    NSString* home_work_mode_str=[file_controller File_read:@"homeworkmode"];
    _choicer.selectedSegmentIndex=home_work_mode_str.intValue;
    home_work_mode=(int)_choicer.selectedSegmentIndex;
    
    homework_file_title=[[NSString alloc]initWithFormat:@"homeworklist_file"];
    paid_file_title=[[NSString alloc]initWithFormat:@"paidlist_file"];
    
    if(_dwarves.count>0)
    {
            NSString* homeworkstater=[file_controller File_read:homework_file_title];
            if(![self release_book:homeworkstater aim:has_homework])
                for(int i=0;i<200;i++)
                    has_homework[i]=0;
        
        NSString* paidliststater=[file_controller File_read:paid_file_title];
        if(![self release_book:paidliststater aim:has_paid])
            for(int i=0;i<200;i++)
                has_paid[i]=0;
    }
    

    
    if(self.blueviewer==nil)
    {
        self.blueviewer=[self.storyboard instantiateViewControllerWithIdentifier:@"blue"];
        [_blueviewer set_father_window:self];
    }
    
    if(self.sendviewer==nil)
    {
        self.sendviewer=[self.storyboard instantiateViewControllerWithIdentifier:@"send"];
    }
    if(_fileviewer==nil)
    {
        self.fileviewer=[self.storyboard instantiateViewControllerWithIdentifier:@"fileview"];
        [_fileviewer set_name_and_booklist:self booklist:self.blueviewer];
    }

    
    //[self.view insertSubview:self.blueviewer.view atIndex:0];
    if(_dwarves.count>0)
    {
        [self reload_names];
        [self load_origin_data_from_files];
    }

    current_booknumber=total_book_number;
    // Do any additional setup after loading the view.
}
-(void)reload_names
{
    self.dwarves=  [file_controller File_read_Mutable_Array:@"classnametotal"];
    [_blueviewer set_class_mate_names:_dwarves];
}
-(void)load_origin_data_from_files
{
    [self reload_names];
    [self fetch_total_booknum];
    [self fetch_booknames];
    [self fetch_price];
    [self read_all_from_booklistfiles];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self load_origin_data_from_files];
    [self.tableView reloadData];
}
-(void)set_total_booknumber:(int)booknum
{
    total_book_number=booknum;
}
-(void)set_user_books_data:(int[200][200])data
{
    for(int i=0;i<_dwarves.count;++i)
    {
        for(int j=0;j<total_book_number;j++)
            users_books[i][j]=data[i][j];
    }
}
-(void)set_user_books_bit_at:(int)x y:(int)y val:(int)val
{
    if(x<0||y<0||x>199||y>199)
        return;
    users_books[x][y]=val;
}
-(int)fetch_total_booknum
{
    NSString* str=[file_controller File_read:@"total_booknum_file"];
    if(str==nil)
    {
        total_book_number=0;
        return 0;
    }
    else{
        total_book_number=(int)str.integerValue;
        return total_book_number;
    }
}
-(void)set_current_id_tofile:(int)ider
{
    NSString* id_poser_str=[[NSString alloc]initWithFormat:@"%d",ider];
    [file_controller File_Save:id_poser_str to:@"current_ider"];
}
- (IBAction)show_save_and_read_view:(UIBarButtonItem *)sender {
    [self.navigationController pushViewController:self.fileviewer animated:YES];
}
- (IBAction)change_view:(UIBarButtonItem *)sender {

    [_blueviewer set_bookid:-1];
    [_blueviewer flush_view];

    [self.navigationController pushViewController:self.blueviewer animated:YES];
 //   [self presentViewController:self.blueviewer animated: YES completion:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dwarves count];
}
-(NSString*)pack_book:(int[200])aim
{
    NSString* str=[[NSString alloc]initWithFormat:@""];
    int length=(int)_dwarves.count;
    for(int i=0;i<length;++i)
    {
        NSString* tmp=[[NSString alloc]initWithFormat:@"%d",aim[i]];
        str=[str stringByAppendingString:tmp];
    }
    return str;
}
- (IBAction)clear_homework_list:(UIBarButtonItem *)sender {
    [self sure_or_not_window];
}
- (IBAction)Generate_final:(UIBarButtonItem *)sender {
    [self Publish_choice_window:@"选择导出的书单类型" andMessage:@"姓名优先: 显示哪位同学订了哪些书\n价格优先: 显示每位同学应该交多少钱\n书名优先: 显示每本书有哪些同学订购"];
}
-(NSString*)generate_final_name_book_list
{
    NSString*fstr=[[NSString alloc]init];
    
    for(int i=0;i<_dwarves.count;++i)
    {
        BOOL booked=false;
        fstr=[fstr stringByAppendingString:@"==============================\n"];
        fstr=[fstr stringByAppendingFormat:@"%@\n\n",_dwarves[i]];
        for(int j=0;j<total_book_number;++j)
        {
            if(users_books[i][j]!=0)
            {
                fstr=[fstr stringByAppendingFormat:@"%@\n",booknames_str[j]];
                booked=true;
            }
        }
        if(booked)
        fstr=[fstr stringByAppendingString:@"\n"];
        else fstr=[fstr stringByAppendingString:@"未订书\n"];
    }
    fstr=[fstr stringByAppendingString:@"==============================\n"];
    fstr=[fstr stringByAppendingString:[self current_time_str]];
        fstr=[fstr stringByAppendingFormat:@"\nCopyright © 2019 Tropical fish. All rights reserved."];
    return fstr;
}
-(NSString*)generate_final_book_count_list
{
    NSString*fstr=[[NSString alloc]init];
    
    for(int i=0;i<total_book_number;++i)
    {
        fstr=[fstr stringByAppendingString:@"==============================\n"];
        fstr=[fstr stringByAppendingFormat:@"%@",booknames_str[i]];
        NSString* str=[[NSString alloc]init];
        int total_booked=0;
        for(int j=0;j<_dwarves.count;++j)
        {
            if(users_books[j][i]!=0)
            {
                str=[str stringByAppendingFormat:@"%@\n",_dwarves[j]];
                total_booked++;
            }
        }
        if(total_booked>0)
        {
            fstr=[fstr stringByAppendingFormat:@"\n订购数量:%d\n\n",total_booked];
            fstr=[fstr stringByAppendingString:str];
        }
        else fstr=[fstr stringByAppendingString:@"\n\n无人订\n"];
    }
    
    fstr=[fstr stringByAppendingString:@"==============================\n"];
    fstr=[fstr stringByAppendingString:[self current_time_str]];
    fstr=[fstr stringByAppendingFormat:@"\nCopyright © 2019 Tropical fish. All rights reserved."];
    return fstr;
}
-(NSString*)current_time_str
{
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * newDateOne = [dateformat stringFromDate:newDate];
    [dateformat setFormatterBehavior:NSDateIntervalFormatterFullStyle];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    return newDateOne;
}
-(void)set_books_name:(NSString*)booknames at:(int)ider
{
    booknames_str[ider]=booknames;
}
-(NSString*)generate_final_name_book_list_with_price
{
    NSString*fstr=[[NSString alloc]init];
    float books_total_val=0;
    for(int i=0;i<_dwarves.count;++i)
    {
        fstr=[fstr stringByAppendingString:@"==============================\n"];
        fstr=[fstr stringByAppendingFormat:@"%@\n",_dwarves[i]];
        NSString*str=[[NSString alloc]init];
        float total_val=0;
        for(int j=0;j<total_book_number;++j)
        {
            if(users_books[i][j]!=0)
            {
                total_val+=pricer[j];
                str=[str stringByAppendingFormat:@"%@ --¥%.2f\n",booknames_str[j],pricer[j]];
            }
        }
        books_total_val+=total_val;
        if(total_val>0)
        {
            fstr=[fstr stringByAppendingFormat:@"订书总价：¥%.2f\n\n",total_val];
            fstr=[fstr stringByAppendingString:str];
        }
        else{
            fstr=[fstr stringByAppendingString:@"\n未订书\n"];
        }
        fstr=[fstr stringByAppendingString:@"\n"];
    }
    fstr=[fstr stringByAppendingString:@"==============================\n"];
    fstr=[fstr stringByAppendingFormat:@"合计:¥%.2f\n",books_total_val];
    fstr=[fstr stringByAppendingString:@"==============================\n"];
    fstr=[fstr stringByAppendingString:[self current_time_str]];
    fstr=[fstr stringByAppendingFormat:@"\nCopyright © 2019 Tropical fish. All rights reserved."];
    return fstr;
}
-(int)release_book:(NSString*)data aim:(int[200])aim
{
    long length=data.length;
    if(data.length==0)
        return 0;
    const char*dir=[data UTF8String];
    for(int i=0;i<length;++i)
    {
        aim[i]=dir[i]-'0';
    }
    return 1;
}

- (IBAction)mode_change:(UISegmentedControl *)sender {

   // home_work_mode=(int)sender.selectedSegmentIndex;
    if(home_work_mode==0)
        home_work_mode=1;
    else home_work_mode=0;
    
    _choicer.selectedSegmentIndex=home_work_mode;
    NSString* str=[[NSString alloc]initWithFormat:@"%d",home_work_mode];
    [file_controller File_Save:str to:@"homeworkmode"];
    [self flush_view];
    [self.tableView reloadData];
}

-(void) flush_view
{
    for(int j=0;j<_dwarves.count;++j)
    {
            if((has_homework[j]==0&&home_work_mode==0)||(has_paid[j]==0&&home_work_mode==1))
            {
                Cellstore[j].imageView.image=[UIImage imageNamed:@"false"];
              //  Cellstore[j].textLabel.textColor=UIColor.blackColor;
               // Cellstore[j].backgroundColor=UIColor.whiteColor;
            }
            else{
                Cellstore[j].imageView.image=[UIImage imageNamed:@"right"];
               // Cellstore[j].textLabel.textColor=[UIColor colorNamed:@"Dimgreen"];
               // Cellstore[j].backgroundColor=[UIColor colorNamed:@"Slightgrey"];
            }
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* SimpleTableIdentifier=@"SimpleTableIdentifier";
    UITableViewCell* Cell=[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(Cell==nil)
    {
        Cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    Cell.textLabel.text=self.dwarves[indexPath.row];
    Cellstore[indexPath.row]=Cell;

    if((has_homework[indexPath.row]==0&&home_work_mode==0)||(has_paid[indexPath.row]==0&&home_work_mode==1))
    {
        Cellstore[indexPath.row].imageView.image=[UIImage imageNamed:@"false"];
     //   Cellstore[indexPath.row].textLabel.textColor=UIColor.blackColor;
      //  Cellstore[indexPath.row].backgroundColor=UIColor.whiteColor;
    }
    else{
        Cellstore[indexPath.row].imageView.image=[UIImage imageNamed:@"right"];
      //  Cellstore[indexPath.row].textLabel.textColor=[UIColor colorNamed:@"Dimgreen"];
      //  Cellstore[indexPath.row].backgroundColor=[UIColor colorNamed:@"Slightgrey"];
    }
    return Cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(home_work_mode==1)
    return true;
    else return false;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        [self toggle_paid_condition:(int)indexPath.row];
    }
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 return indexPath;
}
-(void)set_home_work_mode:(int)mode
{
    home_work_mode=mode;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    focus_id=(int)indexPath.row;
    if(home_work_mode==0)
    {
        if(has_homework[indexPath.row]==0)
        {
            has_homework[indexPath.row]=1;
            Cellstore[indexPath.row].imageView.image=[UIImage imageNamed:@"right"];
        //    Cellstore[indexPath.row].textLabel.textColor=[UIColor colorNamed:@"Dimgreen"];
         //   Cellstore[indexPath.row].backgroundColor=[UIColor colorNamed:@"Slightgrey"];
        }
        else{
            has_homework[indexPath.row]=0;
            Cellstore[indexPath.row].imageView.image=[UIImage imageNamed:@"false"];
        //    Cellstore[indexPath.row].textLabel.textColor=UIColor.blackColor;
       //     Cellstore[indexPath.row].backgroundColor=UIColor.whiteColor;
        }
        [file_controller File_Save:[self pack_book:has_homework] to:homework_file_title];
    }
    else{
        currentname=[[NSString alloc]initWithFormat:@"%@ 预览",_dwarves[indexPath.row]];
        [self PreviewWindow:currentname andMessage:[self generate_simple_list:focus_id]];
    }
}
- (IBAction)Who_did_not_have_homework:(UIBarButtonItem *)sender {
    NSString*str=[[NSString alloc]initWithFormat:@""];
    for(int i=0;i<_dwarves.count;++i)
    {
        if((has_homework[i]==0&&home_work_mode==0)||(has_paid[i]==0&&home_work_mode==1))
        {
            str=[str stringByAppendingFormat:@"%@\n",_dwarves[i]];
        }
    }
    [self NewsMessageWithTitle:@"剩余名单" andMessage:str];
}
-(void)reset_current_list
{
    [self clear_homework_list];
    if(self->home_work_mode==0)
        [self->file_controller File_Save:[self pack_book:self->has_homework] to:self->homework_file_title];
    else [self->file_controller File_Save:[self pack_book:self->has_paid] to:self->paid_file_title];
}
-(void) sure_or_not_window{
    // 初始化对话框
    [window_controller Sure_or_not_window_with_title:@"⚠️重置该表" andMessage:@"该操作不可撤销" process_func:@selector(reset_current_list) sure_button_title:@"Reset" cancle_button_title:@"Cancle"];
}
-(void)NewsMessageWithTitle:(NSString*)title andMessage:(NSString*)message{
    UIAlertController * alert;
    if(!isipad)
    alert= [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleActionSheet];
    else{
            alert= [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleAlert];
    }
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController: alert animated: YES completion:nil];
}
- (IBAction)importnamesnow:(UIBarButtonItem *)sender {
            [self.navigationController pushViewController:self.importviewer animated:YES];
}
-(void)Publish_choice_window:(NSString*)title andMessage:(NSString*)message{
    UIAlertController * alert;
    if(!isipad)
    alert= [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleActionSheet];
    else{
            alert= [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleAlert];
    }
    UIAlertAction* publish_without_price = [UIAlertAction actionWithTitle:@"姓名优先" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {

        [self->_sendviewer set_contents:[self generate_final_name_book_list]];
        [self->_sendviewer setTitle:@"姓名优先"];
        [self.navigationController pushViewController:self.sendviewer animated:YES];
    }];
    UIAlertAction* publish_with_price = [UIAlertAction actionWithTitle:@"价格优先" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {

        [self->_sendviewer set_contents:[self generate_final_name_book_list_with_price]];
        [self->_sendviewer setTitle:@"价格优先"];
        [self.navigationController pushViewController:self.sendviewer animated:YES];
    }];
    UIAlertAction* publish_in_book = [UIAlertAction actionWithTitle:@"书目优先" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {

        [self->_sendviewer set_contents:[self generate_final_book_count_list]];
        [self->_sendviewer setTitle:@"书目优先"];
        [self.navigationController pushViewController:self.sendviewer animated:YES];
    }];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:publish_without_price];
    [alert addAction:publish_with_price];
    [alert addAction:publish_in_book];
    [self presentViewController: alert animated: YES completion:nil];
}
-(void)PreviewWindow:(NSString*)title andMessage:(NSString*)message{
    
    UIAlertController * alert;
    if(!isipad)
    alert= [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleActionSheet];
    else{
            alert= [UIAlertController alertControllerWithTitle:title message: message preferredStyle:UIAlertControllerStyleAlert];
    }
    
    UIAlertAction * action_cancle = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action_cancle];
    
        NSString* pstr=@"修改这位同学的订书单";
        UIAlertAction* change_price_action = [UIAlertAction actionWithTitle:pstr style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
         //   NSString* currentname=[[NSString alloc]initWithFormat:@"%@",self->_dwarves[self->focus_id]];
          //  [self set_current_id_tofile:self->focus_id];
            [self->_blueviewer set_bookid:self->focus_id];
            [self->_blueviewer flush_view];
            [self.navigationController pushViewController:self->_blueviewer animated:YES];
           // [self presentViewController:self.blueviewer animated: YES completion:nil];
            
        }];
    NSString* paid_condition=has_paid[focus_id]==0?@"已支付":@"取消支付";
    NSString* paid_str=[[NSString alloc]initWithFormat:@"%@ ¥%.2f",paid_condition,[self User_total_price:focus_id]];
    UIAlertAction* paid_action = [UIAlertAction actionWithTitle:paid_str style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        [self toggle_paid_condition:self->focus_id];
    }];
    [alert addAction:paid_action];
    [alert addAction:change_price_action];
    [self presentViewController: alert animated: YES completion:nil];
}
-(NSMutableArray*)get_classmate_names
{
    NSMutableArray* res=self.dwarves;
    return res;
}
-(void)toggle_paid_condition:(int)user_id
{
    if(has_paid[user_id]==0)
    {
        has_paid[user_id]=1;
        Cellstore[user_id].imageView.image=[UIImage imageNamed:@"right"];
      //  Cellstore[user_id].textLabel.textColor=[UIColor colorNamed:@"Dimgreen"];
      //  Cellstore[user_id].backgroundColor=[UIColor colorNamed:@"Slightgrey"];
    }
    else{
        has_paid[user_id]=0;
        Cellstore[user_id].imageView.image=[UIImage imageNamed:@"false"];
     //   Cellstore[user_id].textLabel.textColor=UIColor.blackColor;
     //   Cellstore[user_id].backgroundColor=UIColor.whiteColor;
    }
    [file_controller File_Save:[self pack_book:has_paid] to:paid_file_title];
}
-(void) clear_homework_list
{
    if(home_work_mode==0)
        for(int i=0;i<self.dwarves.count;i++)
            has_homework[i]=0;
    else
        for(int i=0;i<self.dwarves.count;i++)
            has_paid[i]=0;
    [self flush_view];
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
-(float)User_total_price:(int)user_id
{
    float total=0;
    for(int j=0;j<_dwarves.count;++j)
    {
        if(pricer[j]==0)
            break;
        
        total+=users_books[user_id][j]*pricer[j];
    }
    return total;
}
-(void)fetch_price
{
    for(int i=0;i<_dwarves.count;i++)
    {
        prices[i]=[file_controller File_read:[self get_pricefile_title:i]];
        
        if(prices[i]!=nil)
            pricer[i]=prices[i].floatValue;
        else pricer[i]=0;
    }
}
-(void)fetch_booknames
{
    int i;
    for(i=0;i<200;i++)
    {
        NSString* str=[file_controller File_read:[self get_book_names_file_title:i]];
        if(str==nil)
            break;
        booknames_str[i]=str;
    }
    if(total_book_number==0)
    {
        total_book_number=i;
        [self save_total_booknum:i];
    }
}
-(void)save_total_booknum:(int)booknumber
{
    NSString*str=[[NSString alloc]initWithFormat:@"%d",booknumber ];
    [file_controller File_Save:str to:@"total_booknum_file"];
}
-(void)read_all_from_booklistfiles
{
    if(file_controller==nil)
        file_controller=[[filer alloc]init];
    
    for(int j=0;j<_dwarves.count;++j)
    {
        NSString*str=[file_controller File_read:[self get_bookedlist_file_title:j]];
        [self release_book:str aim:users_books[j]];
    }
}
-(NSString*)generate_simple_list:(int)ider
{
    NSString* str=[[NSString alloc]initWithFormat:@""];
    for(int i=0;i<total_book_number;++i)
    {
        if(users_books[ider][i]!=0)
        {
            str=[str stringByAppendingString:booknames_str[i]];
            str=[str stringByAppendingFormat:@" -- ¥%.2f\n",pricer[i]];
        }
    }
    return str;
}
@end
