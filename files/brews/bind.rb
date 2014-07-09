require 'formula'

class Bind < Formula
  homepage 'http://www.isc.org/software/bind/'
  url 'http://ftp.isc.org/isc/bind9/9.10.0-P2/bind-9.10.0-P2.tar.gz'
  sha1 'c57b5825e36933119e9fd6f43e3f52262e7ff4ed'
  version '9.10.0-P2-boxen1'

  bottle do
    revision 1
    sha1 "068156f5b18530fe37e19b9fa17644925e9e4708" => :mavericks
    sha1 "62e59a79007bed3daa873951fcd3bef5e221596f" => :mountain_lion
    sha1 "114293393260de545393e4ed66ca252e881aa21f" => :lion
  end

  depends_on "openssl"

  def install
    ENV.libxml2
    # libxml2 appends one inc dir to CPPFLAGS but bind ignores CPPFLAGS
    ENV.append 'CFLAGS', ENV.cppflags

    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-ipv6",
                          "--with-ssl-dir=#{Formula['openssl'].opt_prefix}"

    # From the bind9 README: "Do not use a parallel 'make'."
    ENV.deparallelize
    system "make"
    system "make install"
  end
end
