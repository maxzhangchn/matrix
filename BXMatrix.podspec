#pod lib lint matrix-wechat.podspec --use-libraries
#pod lib lint --verbose --skip-import-validation --allow-warnings matrix-wechat.podspec
#pod spec lint matrix-wechat.podspec --allow-warnings
#pod trunk me 
#pod trunk push matrix-wechat.podspec --allow-warnings
#pod trunk info matrix-wechat

Pod::Spec.new do |s|
  s.name             = 'BXMatrix'
  s.version          = '1.0.1'
  s.summary          = 'Matrix for iOS/macOS is a performance probe tool developed and used by WeChat.'
  s.description      = <<-DESC
                            Matrix for iOS/macOS is a performance probe tool developed and used by WeChat. 
                            It is currently integrated into the APM (Application Performance Manage) platform inside WeChat. 
                            The monitoring scope of the current tool includes: crash, lag, and out-of-memory, which includes the following two plugins:
                            1.WCCrashBlockMonitorPlugin: Based on [KSCrash](https://github.com/kstenerud/KSCrash) framework, it features cutting-edge lag stack capture capabilities with crash cpature.
                            2.WCMemoryStatPlugin: A performance-optimized out-of-memory monitoring tool that captures memory allocation and the callstack of an application's out-of-memory event.
                            DESC
  s.homepage         = 'https://github.com/Tencent/matrix'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'johnzjchen' => 'johnzjchen@tencent.com' }
  s.source           = { :git => 'https://github.com/Tencent/matrix.git', :branch => "feature/ios-matrix-cocopods-1.0.1" }
  s.module_name      = "BXMatrix"

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = "10.10"
  s.libraries        = "z", "c++"
  s.frameworks       = "CoreFoundation", "Foundation"
  s.ios.frameworks   = "UIKit"
  s.osx.frameworks   = "AppKit"

  s.pod_target_xcconfig = {
    "CLANG_CXX_LANGUAGE_STANDARD" => "gnu++1y",
    "CLANG_CXX_LIBRARY" => "libc++"
  }

  non_arc_files_1           = "BXMatrix/Matrix/Util/MatrixBaseModel.{h,mm}"
  non_arc_files_2           = "BXMatrix/WCMemoryStat/MemoryLogger/ObjectEvent/nsobject_hook.{h,mm}"

  s.subspec 'matrixNonARC1' do |non_arc1|
    non_arc1.requires_arc = false
    non_arc1.source_files = non_arc_files_1
    non_arc1.public_header_files = ["BXMatrix/Matrix/Matrix/Util/MatrixBaseModel.h"]
  end

  s.subspec 'matrixARC' do |arc|
    arc.requires_arc     = true
    arc.source_files     = "BXMatrix/**/*.{h,m,mm,c,cpp}"
    arc.exclude_files    = [non_arc_files_1,non_arc_files_2]
    arc.public_header_files = ["BXMatrix/Matrix/matrix.h", 
      "BXMatrix/Matrix/AppReboot/MatrixAppRebootType.h",
      "BXMatrix/Matrix/Issue/MatrixIssue.h",
      "BXMatrix/Matrix/Plugin/*.{h}",
      "BXMatrix/Matrix/Log/MatrixAdapter.h",
      "BXMatrix/WCMemoryStat/MemoryStatPlugin/WCMemoryStatConfig.h",
      "BXMatrix/WCMemoryStat/MemoryStatPlugin/WCMemoryStatPlugin.h", 
      "BXMatrix/WCMemoryStat/MemoryStatPlugin/Record/WCMemoryStatModel.h",
      "BXMatrix/WCMemoryStat/MemoryLogger/memory_stat_err_code.h",
      "BXMatrix/Matrix/MatrixHandler.h",
      "BXMatrix/MatrixFramework.h"]
    arc.dependency  'BXMatrix/matrixNonARC1'
  end

  s.subspec 'matrixNonARC2' do |non_arc2|
    non_arc2.requires_arc = false
    non_arc2.source_files = non_arc_files_2
    non_arc2.dependency 'BXMatrix/matrixARC'
  end

end