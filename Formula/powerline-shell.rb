class PowerlineShell < Formula
  desc "A Powerline like prompt for bash, zsh and fish"
  homepage "https://github.com/milkbikis/powerline-shell"
  head "https://github.com/milkbikis/powerline-shell.git"
  
  depends_on "python" if MacOS.version < :lion
  
  def install
    cp buildpath/"config.py.dist", buildpath/"config.py"
    system "python", "install.py"
    bin.install "powerline-shell.py"
  end
  
  test do
    system bin/"powerline-shell.py"
  end
end