//
//  ZZProperty.m
//  ModelMakeByJSON
//
//  Created by 李伯坤 on 2017/2/16.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "ZZProperty.h"
#import "NSString+MMBJ.h"
#import "ZZClass.h"
#import "ZZModelConfig.h"

@implementation ZZProperty

+ (NSString *)classNameByKey:(NSString *)key
{
    key = [self keyFromClassName:key];
    return [NSString stringWithFormat:@"%@%@%@", [ZZModelConfig sharedInstance].classPrefix, [key uppercaseFirstCharacter], [ZZModelConfig sharedInstance].classSuffix];
}

+ (NSString *)keyFromClassName:(NSString *)className
{
    if ([className hasPrefix:[ZZModelConfig sharedInstance].classPrefix]) {
        className = [className substringFromIndex:[ZZModelConfig sharedInstance].classPrefix.length];
    }
    if ([className hasSuffix:[ZZModelConfig sharedInstance].classSuffix]) {
        className = [className substringToIndex:className.length - [ZZModelConfig sharedInstance].classSuffix.length];
    }
    
    for (NSString *str in [ZZModelConfig sharedInstance].classPrefixIgnoreWords) {
        if ([className hasPrefix:str]) {
            className = [className substringFromIndex:str.length];
            return [ZZProperty keyFromClassName:className];     // 递归剔除
        }
    }
    
    for (NSString *str in [ZZModelConfig sharedInstance].classSuffixIgnoreWords) {
        if ([className hasSuffix:str]) {
            className = [className substringToIndex:className.length - str.length];
            return [ZZProperty keyFromClassName:className];     // 递归剔除
        }
    }
    
    return className;
}

- (id)initWithKey:(NSString *)key value:(id)value andFatherClassName:(NSString *)fatherClassName
{
    if (self = [super init]) {
        self.key = key;
        Class valueClass = [value class];
        
        if ([valueClass isSubclassOfClass:[NSString class]]) {              // 字符串
            self.valueClass = [NSString class];
            self.valueClassName = NSStringFromClass([NSString class]);
            self.remarks = value;
        }
        else if ([valueClass isSubclassOfClass:[NSArray class]]) {          // 数组
            self.valueClass = [NSArray class];
            NSString *className = [self p_getNewClassNameByKey:key fatherClassName:fatherClassName];
            self.childClass = [[ZZClass alloc] initWithClassName:className andJson:[(NSArray *)value objectAtIndex:0]];
            self.valueClassName = [NSString stringWithFormat:@"%@<%@>", NSStringFromClass([NSArray class]), className];
        }
        else if ([valueClass isSubclassOfClass:[NSDictionary class]]) {     // 字典
            self.valueClass = [NSDictionary class];
            NSString *className = [self p_getNewClassNameByKey:key fatherClassName:fatherClassName];
            self.valueClassName = className;
            self.childClass = [[ZZClass alloc] initWithClassName:className andJson:value];
        }
    }
    return self;
}

- (NSString *)propertyCode
{
    NSString *str = @"";
    if (self.remarks.length > 0) {
        str = [NSString stringWithFormat:@"/// %@\n", self.remarks];
    }
    str = [str stringByAppendingFormat:@"@property (nonatomic, strong) %@ *%@;\n", self.valueClassName, self.key];
    return str;
}

#pragma mark - # Private Methods
- (NSString *)p_getNewClassNameByKey:(NSString *)key fatherClassName:(NSString *)fatherClassName
{
    NSString *name = [key uppercaseFirstCharacter];
    if ([ZZModelConfig sharedInstance].userOriginClassNamsAsPrefix) {
        NSString *fatherKey = [ZZProperty keyFromClassName:fatherClassName];
        name = [fatherKey stringByAppendingString:name];
    }
    NSString *className = [ZZProperty classNameByKey:name];
    return className;
}

@end
