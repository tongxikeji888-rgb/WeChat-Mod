#import <UIKit/UIKit.h>

// 只是简单地 Hook 微信主界面
@interface MMTabBarController : UITabBarController
@end

%hook MMTabBarController

- (void)viewDidLoad {
    %orig; // 执行原始代码，保证微信正常启动

    // 延迟 3 秒弹个窗，证明插件生效了
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Pyrite 提示" 
                                                                       message:@"插件安装成功！这是多巴胺越狱专用版 ❤️" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好哒" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

%end
