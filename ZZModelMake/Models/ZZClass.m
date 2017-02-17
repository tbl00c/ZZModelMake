//
//  ZZClass.m
//  ModelMakeByJSON
//
//  Created by 李伯坤 on 2017/2/16.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "ZZClass.h"
#import "NSDate+Extension.h"
#import "ZZModelConfig.h"

@implementation ZZClass

- (id)initWithClassName:(NSString *)className andJson:(NSDictionary *)json
{
    if (self = [super init]) {
        _className = className;
        
        NSMutableArray *properties = [[NSMutableArray alloc] init];
        for (NSString *key in json) {
            NSLog(@"Key: %@", key);
            id value = [json objectForKey:key];
            ZZProperty *property = [[ZZProperty alloc] initWithKey:key value:value andFatherClassName:className];
            [properties addObject:property];
        }
        _properties = properties;
    }
    return self;
}

- (BOOL)createFilesAtPath:(NSString *)path
{
    // 创建.h文件
    NSString *fileName = [self.className stringByAppendingPathExtension:@"h"];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    if (![self p_writeCode:self.interfaceCode toFileAtPath:filePath]) {
        return NO;
    }
    
    // 创建.m文件
    fileName = [self.className stringByAppendingPathExtension:@"m"];
    filePath = [path stringByAppendingPathComponent:fileName];
    if (![self p_writeCode:self.implementationCode toFileAtPath:filePath]) {
        return NO;
    }
    
    // 为child Class生成文件
    for (ZZProperty *property in self.properties) {
        if (property.childClass) {
            [property.childClass createFilesAtPath:path];
        }
    }

    return YES;
}

- (NSString *)interfaceCode
{
    NSString *code = @"";
    code = [code stringByAppendingFormat:@"\n@interface %@ : NSObject\n\n", self.className];
    for (ZZProperty *property in self.properties) {
        code = [code stringByAppendingFormat:@"%@\n", property.propertyCode];
        if (property.childClass) {
            code = [NSString stringWithFormat:@"#import \"%@.h\"\n%@", property.childClass.className, code];
        }
    }
    code = [code stringByAppendingFormat:@"@end\n\n"];
    
    // 头部
    code = [@"#import <Foundation/Foundation.h>\n" stringByAppendingString:code];
    return code;
}

- (NSString *)implementationCode
{
    NSString *code = @"";
    code = [code stringByAppendingFormat:@"#import \"%@.h\"\n\n@implementation %@\n\n", self.className, self.className];
    
    if ([ZZModelConfig sharedInstance].thirdPartLibType == ZZThirdPartLibTypeMJExtension) {
        NSMutableDictionary *arrValues = [[NSMutableDictionary alloc] init];
        for (ZZProperty *property in self.properties) {
            if (property.valueClass == [NSArray class]) {
                [arrValues setObject:property.childClass.className forKey:property.key];
            }
        }
        if (arrValues.count > 0) {
            code = [code stringByAppendingString:@"+ (NSDictionary *)mj_objectClassInArray\n{\n\treturn @{\n"];
            for (NSString *key in arrValues) {
                code = [code stringByAppendingFormat:@"\t\t@\"%@\" : @\"%@\",\n", key, arrValues[key]];
            }
            code = [code stringByAppendingString:@"\t};\n}\n\n"];
        }
    }
    
    code = [code stringByAppendingString:@"@end\n"];
    return code;
}

#pragma mark - # Private Methods
/// 将代码写入文件
- (BOOL)p_writeCode:(NSString *)code toFileAtPath:(NSString *)filePath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"删除已存在的%@文件失败", [filePath lastPathComponent]);
            return NO;
        }
    }

    NSString *authorName = [ZZModelConfig sharedInstance].authorName;
    NSString *dateString = [NSString stringWithFormat:@"%d/%d/%d", (int)[[NSDate date] year], (int)[[NSDate date] month], (int)[[NSDate date] day]];
    NSString *header = [NSString stringWithFormat:@"//\n//  %@\n//  zhuanzhuan\n//\n//  Created by %@ on %@.\n//  Copyright © 2017年 %@. All rights reserved.\n//\n\n", [filePath lastPathComponent], authorName, dateString, authorName];
    code = [header stringByAppendingString:code];
    BOOL ok = [[NSFileManager defaultManager] createFileAtPath:filePath contents:[code dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    if (!ok) {
        NSLog(@"%@文件写入失败", [filePath lastPathComponent]);
    }
    return ok;
}

@end
