class AndroidNdkToolchainAT13b < Formula
  desc "Android native-code language toolset"
  homepage "https://developer.android.com/ndk/index.html"
  url "https://gist.github.com/atsushi-ageet/738831f070e7134de843e46af3f572ed/archive/78227fc68eab3c1366604a45ae1e69059ed6b242.zip"
  version "r13b"
  sha256 "c8270673b416d4ebec625e5041b3ace07a3d4f88c4bb44919c3ba9b5c3d0ecd9"
  version_scheme 1

  bottle :unneeded

  depends_on 'python' => :build
  depends_on 'android-ndk@13b' => :build

  def install
    bin.mkpath
    ENV['ANDROID_NDK_DIR'] = Formula['android-ndk@13b'].prefix
    ENV['ANDROID_NDK_TOOLCHAIN'] = prefix
    ENV['API'] = ENV['HOMEBREW_NDK_API'] || '14'
    ENV['STL_VERSION'] = ENV['HOMEBREW_NDK_STL_VERSION'] || 'libc++'
    ENV['ARCHS'] = ENV['HOMEBREW_NDK_ARCHS'] || 'arm arm64 x86 x86_64'
    chmod 0755, "android-ndk-make-toolchain.sh"
    system (buildpath/"android-ndk-make-toolchain.sh")
  end
end
