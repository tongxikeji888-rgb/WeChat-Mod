#import <UIKit/UIKit.h>

// 声明微信的主控制器类
@interface MMTabBarController : UITabBarController
@end

%hook MMTabBarController

- (void)viewDidLoad {
    %orig; // 执行微信原本的启动代码

    // 1. 启动时弹个窗，证明插件生效了 (你可以随时删掉这行)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Pyrite 提示" 
                                                                       message:@"插件加载成功！长按屏幕右下角试试截图？" 
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"好哒" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });

    // 2. 添加一个隐形的触发按钮 (在屏幕右下角)
    UIButton *triggerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    triggerBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, [UIScreen mainScreen].bounds.size.height - 150, 60, 60);
    triggerBtn.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.3]; // 半透明红色，调试用，你可以改成 clearColor 隐藏
    triggerBtn.layer.cornerRadius = 30;
    [triggerBtn setTitle:@"📸" forState:UIControlStateNormal];
    
    // 添加长按手势触发截图
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePyriteScreenshot:)];
    [triggerBtn addGestureRecognizer:longPress];
    
    [[UIApplication sharedApplication].keyWindow addSubview:triggerBtn];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:triggerBtn];
}

%new
- (void)handlePyriteScreenshot:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateBegan) return;

    // 震动反馈
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator impactOccurred];

    // 获取屏幕截图
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContextWithOptions(keyWindow.bounds.size, NO, 0);
    [keyWindow drawViewHierarchyInRect:keyWindow.bounds afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // 开始合成 (加壳和水印)
    // 这里为了简单，我们直接画一个红色的边框当作“壳”
    CGSize canvasSize = CGSizeMake(keyWindow.bounds.size.width + 40, keyWindow.bounds.size.height + 60);
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0);
    
    // 1. 画背景 (黑色)
    [[UIColor blackColor] setFill];
    UIRectFill(CGRectMake(0, 0, canvasSize.width, canvasSize.height));
    
    // 2. 画截图 (居中)
    [screenshot drawInRect:CGRectMake(20, 30, keyWindow.bounds.size.width, keyWindow.bounds.size.height)];
    
    // 3. 画水印
    NSString *watermark = @"WeChat Mod by Pyrite ❤️";
    NSDictionary *attrs = @{ 
        NSForegroundColorAttributeName : [UIColor whiteColor], 
        NSFontAttributeName : [UIFont boldSystemFontOfSize:16] 
    };
    [watermark drawAtPoint:CGPointMake(40, canvasSize.height - 40) withAttributes:attrs];

    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // 保存到相册
    UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil);
    
    // 提示保存成功
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"搞定" message:@"带壳截图已保存到相册！" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

%end
