Pod::Spec.new do |spec|

  spec.name         = "BBPlayerView"
  spec.version      = "1.2.0"
  spec.license      = "MIT"
  spec.summary      = "基于 AVPlayer、AVPlayerLayer、AVPlayerItem 封装的视频播放器。"
  spec.author       = { "ebamboo" => "1453810050@qq.com" }
  
  spec.homepage     = "https://github.com/ebamboo/BBPlayerView"
  spec.source       = { :git => "https://github.com/ebamboo/BBPlayerView.git", :tag => spec.version }

  spec.source_files = "BBPlayerView/Source Files/*.{h,m}"
  
  spec.platform     = :ios, "11.0"
  spec.requires_arc = true
  spec.frameworks   = "UIKit", "AVFoundation"
  
end
