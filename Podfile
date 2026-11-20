platform :ios, '15.0'

ENV['SWIFT_VERSION'] = '5'

project 'SNSCodeTimerDemo.xcodeproj'

# [EN] The countdown button is CYLAnimatedItemView (style: countdown) of the CYLAnimatedItem pod: Core only, static
#      images, no animation engine. Always the latest commit of CYLTabBarController on any branch, found by
#      commit time with scripts/latest-cyl-commit.sh before every build (AGENTS.md, "Depending on CYLAnimatedItem").
# [CN] 倒计时按钮就是 CYLAnimatedItem pod 的 CYLAnimatedItemView（倒计时样式）：只用 Core，静态图片，不含动画引擎。
#      始终依赖 CYLTabBarController 任意分支上的最新 commit，每次构建前用 scripts/latest-cyl-commit.sh 按提交时间查找
#      （AGENTS.md「Depending on CYLAnimatedItem」）。
target 'SNSCodeTimerDemo' do
  use_frameworks!

  pod 'CYLAnimatedItem', :git => 'https://github.com/ChenYilong/CYLTabBarController.git', :commit => 'e7053169775900b7251da07d88e8c1b2bea5f9e7'

  target 'SNSCodeTimerDemoTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "15.0"
    end
  end
end
