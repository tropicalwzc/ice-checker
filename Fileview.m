//
//  Fileview.m
//  ice_checker
//
//  Created by 王子诚 on 2019/2/27.
//  Copyright © 2019 王子诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Fileview.h"
@interface Fileview()

@end

@implementation Fileview
- (void)viewDidLoad {
    [super viewDidLoad];
    file_controller=[[filer alloc]init];
    window_controller=[[smallwindow alloc]init_with_fatherwindow:self];
    [self fetch_saver_file_names];
}
-(Fileview*)init_with_father_window:(Namelist*)father_win
{
    father_window=father_win;
    return self;
}
-(void)set_name_and_booklist:(Namelist*)father_win booklist:(Booklist*)father_booklist;
{
    father_window=father_win;
    father_booklist_window=father_booklist;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return savers.count+1;
}
-(void)Read_func
{
    [self Read_All_file_from:savers[focus_id]];
   // NSLog(@"Reading %d",focus_id);
    [father_window viewDidLoad];
    [father_booklist_window viewDidLoad];
}
-(void)Write_func
{
    [self Save_Current_All_file_to:savers[focus_id]];
}
-(void)Delete_func
{
    [self Delete_All_file_from:savers[focus_id]];
    [savers removeObjectAtIndex:focus_id];
    [self save_current_to_saver_file];
    [self.tableView reloadData];
}
-(void)Delete_All_file_from:(NSString*)prefix
{
    [file_controller Delete_File:[self paid_file_name:prefix]];
    NSString*str=[file_controller File_read:[self booknumber_file_name:prefix]];
    long total_book_number=str.integerValue;
    [file_controller Delete_File:[self booknumber_file_name:prefix]];
    
    NSMutableArray* arrayer=[file_controller File_read_Mutable_Array:[self namelist_file_name:prefix]];
    long total_name_number=arrayer.count;
    [file_controller Delete_File:[self namelist_file_name:prefix]];
    
    for(int i=0;i<total_name_number;++i)
    {
        [file_controller Delete_File:[self booklist_file_name:prefix id:i]];
    }
    for(int i=0;i<total_book_number;++i)
    {
        [file_controller Delete_File:[self booknames_file_name:prefix id:i]];
        [file_controller Delete_File:[self bookprices_file_name:prefix id:i]];
    }
    [file_controller Delete_File:[self saver_time_file_name:prefix]];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* SimpleTableIdentifier=@"SimpleTableIdentifier";
    UITableViewCell* Cell=[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(Cell==nil)
    {
        Cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    Cellstore[indexPath.row]=Cell;
    if(indexPath.row<savers.count)
    {
        Cell.textLabel.text=savers[indexPath.row];
        
       if (@available(iOS 13.0, *)) {
           Cell.imageView.image=[[UIImage imageNamed:@"icons8-save"] imageWithTintColor:[UIColor lightGrayColor]];
       } else {
           Cell.imageView.image=[UIImage imageNamed:@"icons8-save"];
           // Fallback on earlier versions
       }
      //  Cellstore[indexPath.row].backgroundColor=[UIColor colorNamed:@"Slightgrey"];
    }
    else{
        Cell.textLabel.text=@"➕";
    }
    return Cell;
}
-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    focus_id=indexPath.row;
    if(focus_id<savers.count)
    {
        NSString* time_str=[self Read_saver_time_file:savers[focus_id]];
        NSArray*button_names=@[@"读取",@"保存",@"删除"];
        NSString* Books_number_str=[file_controller File_read:[self booknumber_file_name:savers[focus_id]]];
        time_str=[time_str stringByAppendingFormat:@"\n____________________________\nTotal booknumber %@\n",Books_number_str];
        for(int i=0;i<Books_number_str.integerValue;++i)
        {
            time_str=[time_str stringByAppendingFormat:@"\n%@ --¥%.2f",[file_controller File_read:[self booknames_file_name:savers[focus_id] id:i]],[file_controller File_read:[self bookprices_file_name:savers[focus_id] id:i]].floatValue];
        }
        [window_controller Rich_NewsMessage_with_three_button:savers[focus_id] message:time_str button_nameset:button_names funct1:@selector(Read_func) funct2:@selector(Write_func) funct3:@selector(Delete_func)];
    }
    else{
        [window_controller Input_one_line_window_with_title:@"建立新存档" andMessage:@"请输入新存档的名字" placeholder:@"" process_NSString_func:@selector(Build_a_new_saver:)];
    }
}
-(void)Build_a_new_saver:(NSString*)prefix
{
    [savers addObject:prefix];
    [self save_current_to_saver_file];
   // NSLog(@"%@ is input total %ld",prefix,savers.count);
    
    [self.tableView reloadData];
}
-(NSMutableArray*)fetch_saver_file_names
{
    savers=[file_controller File_read_Mutable_Array:@"Saver_Sets_names"];
    if(savers==nil)
    {
        savers=[[NSMutableArray alloc]initWithObjects:@"autosave", nil];
        [self Save_Current_All_file_to:@"autosave"];
    }
    saver_total_number=savers.count;
    
    return savers;
}
-(void)save_current_to_saver_file
{
    [file_controller File_Save_Mutable_Array :savers to:@"Saver_Sets_names"];
}
-(void)Save_Current_All_file_to:(NSString*)prefix
{
    [self Move_All_file_from:@"" to:prefix];
    [file_controller File_Save:[self current_time_str] to:[self saver_time_file_name:prefix]];
}
-(void)Read_All_file_from:(NSString*)prefix
{
    [self Move_All_file_from:prefix to:@""];
}
-(NSString*)Read_saver_time_file:(NSString*)prefix
{
    NSString* str=[file_controller File_read:[self saver_time_file_name:prefix]];
    return str;
}
-(void)Move_All_file_from:(NSString*)origin to:(NSString*)aim
{
    NSString*str=[file_controller File_read:[self paid_file_name:origin]];
    [file_controller File_Save:str to:[self paid_file_name:aim]];
    
    str=[file_controller File_read:[self booknumber_file_name:origin]];
    [file_controller File_Save:str to:[self booknumber_file_name:aim]];
    long total_book_number=str.integerValue;
    
    NSMutableArray* arrayer=[file_controller File_read_Mutable_Array:[self namelist_file_name:origin]];
    [file_controller File_Save_Array:arrayer to:[self namelist_file_name:aim]];
    long total_name_number=arrayer.count;
    
   // NSLog(@"name %ld books %ld",total_name_number,total_book_number);
    for(int i=0;i<total_name_number;++i)
    {
        str=[file_controller File_read:[self booklist_file_name:origin id:i]];
        [file_controller File_Save:str to:[self booklist_file_name:aim id:i]];
    }
    for(int i=0;i<total_book_number;++i)
    {
        str=[file_controller File_read:[self booknames_file_name:origin id:i]];
        [file_controller File_Save:str to:[self booknames_file_name:aim id:i]];
        str=[file_controller File_read:[self bookprices_file_name:origin id:i]];
        [file_controller File_Save:str to:[self bookprices_file_name:aim id:i]];
    }
    NSString* time_str=[self Read_saver_time_file:origin];
    [file_controller File_Save:time_str to:[self saver_time_file_name:aim]];
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
-(NSString*)saver_time_file_name:(NSString*)prefix
{
    NSString* str=[[NSString alloc]initWithFormat:@"%@saver_time_file",prefix];
    return str;
}
-(NSString*)paid_file_name:(NSString*)prefix
{
    NSString* str=[[NSString alloc]initWithFormat:@"%@paidlist_file",prefix];
    return str;
}
-(NSString*)namelist_file_name:(NSString*)prefix
{
    NSString* str=[[NSString alloc]initWithFormat:@"%@classnametotal",prefix];
    return str;
}
-(NSString*)booknumber_file_name:(NSString*)prefix
{
    NSString* str=[[NSString alloc]initWithFormat:@"%@total_booknum_file",prefix];
    return str;
}
-(NSString*)booknames_file_name:(NSString*)prefix id:(int)ider
{
    NSString*titer=[[NSString alloc]initWithFormat:@"%@bookname_file_%d",prefix,ider];
    return titer;
}
-(NSString*)bookprices_file_name:(NSString*)prefix id:(int)ider
{
    NSString*titer=[[NSString alloc]initWithFormat:@"%@bookprice_of_id_%d",prefix,ider];
    return titer;
}
-(NSString*)booklist_file_name:(NSString*)prefix id:(int)ider
{
    NSString*titer=[[NSString alloc]initWithFormat:@"%@booklist_file_%d",prefix,ider];
    return titer;
}
@end
