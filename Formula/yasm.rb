require 'formula'

class Yasm < Formula
  homepage 'http://yasm.tortall.net/'
  url "http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
  sha256 "3dce6601b495f5b3d45b59f7d2492a340ee7e84b5beca17e48f862502bd5603f"

  bottle do
  end

  head do
    url 'https://github.com/yasm/yasm.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext"
  end

  resource "cython" do
    url "http://cython.org/release/Cython-0.20.2.tar.gz"
    sha1 "e3fd4c32bdfa4a388cce9538417237172c656d55"
  end

  depends_on :python => :optional

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
    ]

    if build.with? "python"
      ENV.prepend_create_path "PYTHONPATH", buildpath+"lib/python2.7/site-packages"
      resource("cython").stage do
        system "python", "setup.py", "build", "install", "--prefix=#{buildpath}"
      end

      args << '--enable-python'
      args << '--enable-python-bindings'
    end

    # https://github.com/Homebrew/homebrew/pull/19593
    ENV.deparallelize

    system './autogen.sh' if build.head?
    system './configure', *args
    system 'make install'
  end
end
