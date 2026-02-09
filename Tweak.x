#import <UIKit/UIKit.h>

// --- 修复关键点：告诉编译器 MMTabBarController 是个控制器 ---
@interface MMTabBarController : UITabBarController
@end
// ----------------------------------------------------

%hook MMTabBarController

- (void)viewDidLoad {
    %orig; // 执行微信原本的逻辑

    // --- 功能 1：启动成功弹窗 ---
    // 延迟 3 秒执行，防止微信还没加载完就弹窗
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🎉 注入成功！" 
                                                                       message:@"恭喜你！这是你亲手编译的第一个插件！\n没有后门，完全纯净！" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"太棒了" style:UIAlertActionStyleDefault handler:nil]];
        
        // 现在编译器知道 self 是个控制器了，就不会报错了！
        [self presentViewController:alert animated:YES completion:nil];
    });

    // --- 功能 2：添加专属水印 ---
    // 获取屏幕窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 兼容 iOS 13+ 的写法，防止 keyWindow 为空
    if (!window) {
        window = [[UIApplication sharedApplication].windows firstObject];
    }

    UILabel *watermark = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 200, 30)];
    watermark.text = @"Pyrite & Master ❤️"; // 这里可以改成你喜欢的字
    watermark.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5]; // 半透明红色
    watermark.font = [UIFont boldSystemFontOfSize:14];
    watermark.userInteractionEnabled = NO; // 让点击穿透，不影响操作
    
    [window addSubview:watermark];
    [window bringSubviewToFront:watermark];
}

%end
