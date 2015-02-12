class Twister < Formula
  homepage "http://twister.net.co"

  devel do
    url "https://github.com/miguelfreitas/twister-core/archive/v0.9.28.tar.gz"
    sha1 "53b03636ae4d7539002fe9c3cf2dd58e9657ac1e"
  end

  head do
    url "https://github.com/miguelfreitas/twister-core.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db4"
  depends_on "boost"
  depends_on "libtool" => :build
  depends_on "miniupnpc" => :build
  depends_on "openssl"

  def install
    ENV["GIT_DIR"] = cached_download/".git" if build.head?

    system "./autotool.sh"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-libdb=#{Formula["berkeley-db4"].opt_prefix}
      --with-boost=#{Formula["boost"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/twisterd</string>
          <string>-daemon</string>
          <string>-rpcuser=user</string>
          <string>-rpcpassword=pwd</string>
          <string>-rpcallowip=127.0.0.1</string>
        </array>
      </dict>
    </plist>
    EOS
  end
  
  def caveats; <<-EOS.undent
    To use Web UI, you need to clone twister-webui project to your Library directory:

      git clone https://github.com/miguelfreitas/twister-html.git ${HOME}/Library/Application\\ Support/Twister/html
    EOS
  end

  test do
    true
    #require "socket"
    #system "#{bin}/twisterd", "-datadir=/tmp/twister1", "-port=30001", "-daemon", "-rpcuser=user", "-rpcpassword=pwd", "-rpcallowip=127.0.0.1", "-rpcport=40001"
    #system "#{bin}/twisterd", "-datadir=/tmp/twister2", "-port=30002", "-daemon", "-rpcuser=user", "-rpcpassword=pwd", "-rpcallowip=127.0.0.1", "-rpcport=40002"
    #system "#{bin}/twisterd", "-rpcuser=user", "-rpcpassword=pwd", "-rpcallowip=127.0.0.1", "-rpcport=40001", "addnode", "#{Socket.ip_address_list.find { |ai| ai.ipv4? && !ai.ipv4_loopback? }.ip_address}:30002", "onetry"
  end
end
