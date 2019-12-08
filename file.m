//
//  file.m
//  ice_sudoku
//
//  Created by 王子诚 on 2019/1/24.
//  Copyright © 2019 王子诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "file.h"

@implementation filer
-(NSString *)GetFilePath:(NSString*)filename
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:filename];
}
-(void)File_Save:(NSString*)data to:(NSString*)filename
{
    NSError * error;
    [data writeToFile:[self GetFilePath:filename] atomically:YES encoding:NSUTF8StringEncoding error:&error];
       // NSLog(@"save %@ to %@",data,filename);
}
-(NSString *)File_read:(NSString*)filename
{
    NSError * error;
    NSString* res=[[NSString alloc]initWithContentsOfFile:[self GetFilePath:filename] encoding:NSUTF8StringEncoding error:&error];
    //NSLog(@"read %@ from %@",res,filename);
    return res;
}
-(void)File_Save_Array:(NSArray*)data to:(NSString*)filename
{
    [data writeToFile:[self GetFilePath:filename] atomically:true];
}
-(NSArray *)File_read_Array:(NSString*)filename
{
    NSArray*data=[[NSArray alloc]initWithContentsOfFile:[self GetFilePath:filename]];
    return data;
}
-(void)File_Save_Mutable_Array:(NSMutableArray*)data to:(NSString*)filename
{
    [data writeToFile:[self GetFilePath:filename] atomically:true];
}
-(NSMutableArray*)File_read_Mutable_Array:(NSString*)filename
{
    NSMutableArray*data=[[NSMutableArray alloc]initWithContentsOfFile:[self GetFilePath:filename]];
    return data;
}
-(BOOL)Delete_File:(NSString*)filename
{
    if(FileManager==nil)
    FileManager=[[NSFileManager alloc]init];

    if([FileManager removeItemAtPath:[self GetFilePath:filename] error:NULL]==NO)
    {
       // NSLog(@"Delete %@ failed",filename);
        return NO;
    }

    return true;
}
@end
