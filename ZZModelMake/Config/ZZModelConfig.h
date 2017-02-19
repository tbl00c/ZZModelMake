//
//  ZZModelConfig.h
//  ModelMakeByJSON
//
//  Created by 李伯坤 on 2017/2/17.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZZThirdPartLibType) {
    ZZThirdPartLibTypeNone,
    ZZThirdPartLibTypeMJExtension,
};

@interface ZZModelConfig : NSObject

/// 作者姓名
@property (nonatomic, strong) NSString *authorName;

/// 项目名称
@property (nonatomic, strong) NSString *productName;

/// 是否使用第三方库（将自动为其增加支持代码）
@property (nonatomic, assign) ZZThirdPartLibType thirdPartLibType;

/// 类前缀
@property (nonatomic, strong) NSString *classPrefix;

/// 类后缀
@property (nonatomic, strong) NSString *classSuffix;

/// 类头过滤词
@property (nonatomic, strong) NSArray *classSuffixIgnoreWords;

/// 类尾过滤词
@property (nonatomic, strong) NSArray *classPrefixIgnoreWords;

/// 是否使用引用的它的类的类名做前缀
@property (nonatomic, assign) BOOL userOriginClassNamsAsPrefix;

+ (ZZModelConfig *)sharedInstance;

- (void)resetToDefaultConfig;

/// 版权信息生成
- (NSString *)copyrightCodeByFileName:(NSString *)fileName;

@end
