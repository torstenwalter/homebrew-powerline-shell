class PowerlineShell < Formula
  desc "A Powerline like prompt for bash, zsh and fish"
  homepage "https://github.com/banga/powerline-shell"
  head "https://github.com/banga/powerline-shell.git"
  
  depends_on "python" if MacOS.version < :lion
  
  def install
    #cp buildpath/"config.py.dist", buildpath/"config.py"
    cat buildpath/config.py.dist \
      |sed "s/    'username',/#   'username',/" \
      |sed "s/    'hostname',/#   'hostname',/" \
      |sed "s/#    'exit_code',/     'exit_code',/" \
      > buildpath/config.py2
    system "python", "install.py"
    prefix.install "powerline-shell.py", "lib"
  end
  
  test do
    system bin/"powerline-shell.py"
  end
  
  def caveats; <<-EOS.undent
    Bash:
      Add the following lines to your .bashrc or .profile:
        function _update_ps1() {
          PS1="$($(brew --prefix powerline-shell)/powerline-shell.py $? 2> /dev/null)"
        }
        
        if [ "$TERM" != "linux" ]; then
          PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
        fi
    
    ZSH:
      Add the following to your .zshrc:
        function powerline_precmd() {
          PS1="$($(brew --prefix powerline-shell)/powerline-shell.py $? --shell zsh 2> /dev/null)"
        }
        
        function install_powerline_precmd() {
          for s in "${precmd_functions[@]}"; do
            if [ "$s" = "powerline_precmd" ]; then
              return
            fi
          done
          precmd_functions+=(powerline_precmd)
        }
        
        if [ "$TERM" != "linux" ]; then
          install_powerline_precmd
        fi
    
    Fish:
      Redefine fish_prompt in ~/.config/fish/config.fish:
        function fish_prompt
          set -l POWELINE_PATH (brew --prefix powerline-shell)
          eval $POWELINE_PATH/powerline-shell.py $status --shell bare ^/dev/null
        end
    EOS
  end
end
