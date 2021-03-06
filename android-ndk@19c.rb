class AndroidNdkAT19c < Formula
  desc "Android native-code language toolset"
  homepage "https://developer.android.com/ndk/index.html"
  url "https://dl.google.com/android/repository/android-ndk-r19c-darwin-x86_64.zip"
  version "1"
  sha256 "4eeaddcb4bb58b2a10a9712f9b8e84ea83889786a88923879e973058f59281cf"

  bottle :unneeded

  # As of r10e, only a 64-bit version is provided
  depends_on :arch => :x86_64

  def install
    bin.mkpath

    # Now we can install both 64-bit and 32-bit targeting toolchains
    prefix.install Dir["*"]

    # Create a dummy script to launch the ndk apps
    ndk_exec = prefix+"ndk-exec.sh"
    ndk_exec.write <<~EOS
      #!/bin/sh
      BASENAME=`basename $0`
      EXEC="#{prefix}/$BASENAME"
      test -f "$EXEC" && exec "$EXEC" "$@"
    EOS
    ndk_exec.chmod 0755
    %w[ndk-build ndk-depends ndk-gdb ndk-stack ndk-which].each { |app| bin.install_symlink ndk_exec => app }
    share.install_symlink prefix => "android-ndk"
  end

  def caveats; <<~EOS
    We agreed to the Android NDK License Agreement for you by downloading the NDK.
    If this is unacceptable you should uninstall.

    License information at:
    https://developer.android.com/sdk/terms.html

    Software and System requirements at:
    https://developer.android.com/sdk/ndk/index.html#requirements

    For more documentation on Android NDK, please check:
      #{prefix}/docs
    EOS
  end

  test do
    (testpath/"test.c").write("int main() { return 0; }")
    cc = Utils.popen_read("#{bin}/ndk-which gcc").strip
    system cc, "-c", "test.c", "-o", "test"
  end
end
