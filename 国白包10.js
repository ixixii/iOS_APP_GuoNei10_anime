CZPickerView

- (void)show {
// 这儿的window拿到为nil
//    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] firstObject];
    
    self.frame = mainWindow.frame;
    [self showInContainer:mainWindow];
}

-------------------------- 
todo list 9: 尾声，上传项目源代码到git 
新建 .gitignore
在里面写上Pods
表示Pods目录不需要git来管理,因为它是pod install自动生成的

git init
git add --all
git commit -m 'iOS 国内区白包10 动漫记录 第1次提交(appstore版)'
git remote add origin https://github.com/ixixii/iOS_APP_GuoNei10_anime.git
git push -u origin master
git push origin master