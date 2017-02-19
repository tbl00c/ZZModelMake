//
//  ZZModelConfig.m
//  ModelMakeByJSON
//
//  Created by 李伯坤 on 2017/2/17.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import "ZZModelConfig.h"
#import "NSDate+Extension.h"

@implementation ZZModelConfig

+ (ZZModelConfig *)sharedInstance
{
    static ZZModelConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[ZZModelConfig alloc] init];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstRun"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFirstRun"];
            // 默认设置
            [config setAuthorName:@"ZZModelMake"];
            [config setProductName:@"zhuanzhuan"];
            [config setThirdPartLibType:ZZThirdPartLibTypeMJExtension];
            [config resetToDefaultConfig];
        }
    });
    return config;
}

- (void)resetToDefaultConfig
{
    [self setClassPrefix:@"ZZ"];
    [self setClassSuffix:@"Model"];
    [self setClassPrefixIgnoreWords:@[@"Get", @"get"]];
    [self setClassSuffixIgnoreWords:@[@"Arr", @"arr", @"Model", @"model", @"Info", @"Array", @"Dic", @"Dictronary", @"Data", @"data"]];
    [self setUserOriginClassNamsAsPrefix:YES];
}

- (NSString *)copyrightCodeByFileName:(NSString *)fileName
{
    NSString *authorName = self.authorName;
    NSString *productName = self.productName;
    NSString *dateString = [NSString stringWithFormat:@"%d/%d/%d", (int)[[NSDate date] year], (int)[[NSDate date] month], (int)[[NSDate date] day]];
    NSString *codeString = [NSString stringWithFormat:@"//\n//  %@\n//  %@\n//\n//  Created by %@ on %@.\n//  Copyright © 2017年 %@. All rights reserved.\n//\n\n",
                            fileName,
                            productName,
                            authorName, dateString,
                            authorName];
    return codeString;
}

//MARK: 作者姓名
- (NSString *)authorName
{
    NSString *authorName = [[NSUserDefaults standardUserDefaults] objectForKey:@"authorName"];
    return authorName;
}
- (void)setAuthorName:(NSString *)authorName
{
    [[NSUserDefaults standardUserDefaults] setObject:authorName ? authorName : @"" forKey:@"authorName"];
}

//MARK: 项目名称
- (NSString *)productName
{
    NSString *productName = [[NSUserDefaults standardUserDefaults] objectForKey:@"productName"];
    return productName;
}
- (void)setProductName:(NSString *)productName
{
    [[NSUserDefaults standardUserDefaults] setObject:productName ? productName : @"" forKey:@"productName"];
}

//MARK: 第三方json-model库
- (ZZThirdPartLibType)thirdPartLibType
{
    NSNumber *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"thirdPartLibType"];
    return type.integerValue;
}
- (void)setThirdPartLibType:(ZZThirdPartLibType)thirdPartLibType
{
    [[NSUserDefaults standardUserDefaults] setObject:@(thirdPartLibType) forKey:@"thirdPartLibType"];
}

//MARK: 类前缀
- (NSString *)classPrefix
{
    NSString *classPrefix = [[NSUserDefaults standardUserDefaults] objectForKey:@"classPrefix"];
    return classPrefix;
}
- (void)setClassPrefix:(NSString *)classPrefix
{
    [[NSUserDefaults standardUserDefaults] setObject:classPrefix ? classPrefix : @"" forKey:@"classPrefix"];
}

//MARK: 类后缀
- (NSString *)classSuffix
{
    NSString *classSuffix = [[NSUserDefaults standardUserDefaults] objectForKey:@"classSuffix"];
    return classSuffix;
}
- (void)setClassSuffix:(NSString *)classSuffix
{
    [[NSUserDefaults standardUserDefaults] setObject:classSuffix ? classSuffix : @"" forKey:@"classSuffix"];
}

//MARK: 拼接引用类类名做前缀
- (BOOL)userOriginClassNamsAsPrefix
{
    NSNumber *userOriginClassNamsAsPrefix = [[NSUserDefaults standardUserDefaults] objectForKey:@"userOriginClassNamsAsPrefix"];
    return userOriginClassNamsAsPrefix.boolValue;
}
- (void)setUserOriginClassNamsAsPrefix:(BOOL)userOriginClassNamsAsPrefix
{
    [[NSUserDefaults standardUserDefaults] setObject:@(userOriginClassNamsAsPrefix) forKey:@"userOriginClassNamsAsPrefix"];
}

//MARK: key做类名时，头部忽略词
- (NSArray *)classPrefixIgnoreWords
{
    NSArray *classPrefixIgnoreWords = [[NSUserDefaults standardUserDefaults] objectForKey:@"classPrefixIgnoreWords"];
    return classPrefixIgnoreWords;
}
- (void)setClassPrefixIgnoreWords:(NSArray *)classPrefixIgnoreWords
{
    [[NSUserDefaults standardUserDefaults] setObject:(classPrefixIgnoreWords ? classPrefixIgnoreWords : @[]) forKey:@"classPrefixIgnoreWords"];
}

//MARK: key做类名时，尾部忽略词
- (NSArray *)classSuffixIgnoreWords
{
    NSArray *classIgnordWords = [[NSUserDefaults standardUserDefaults] objectForKey:@"classSuffixIgnoreWords"];
    return classIgnordWords;
}
- (void)setClassSuffixIgnoreWords:(NSArray *)classSuffixIgnoreWords
{
    [[NSUserDefaults standardUserDefaults] setObject:(classSuffixIgnoreWords ? classSuffixIgnoreWords : @[]) forKey:@"classSuffixIgnoreWords"];
}

@end
