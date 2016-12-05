#!/usr/bin/env ruby
require 'fileutils'

class Bootstrap
  class << self
    def dotfiles
      ['gemrc', 'gitconfig', 'gitignore_global', 'irbrc', 'pryrc', 'zshrc']
    end

    def symlink_dotfiles!
      dotfiles.each do | path |
        repofile = File.basename(path)
        hostfile = "#{Dir.home}/.#{repofile}"

        # remove the current file if it exists
        FileUtils.rm_f hostfile if file_exists? hostfile

        # symlink the file checked in git to the home path
        FileUtils.ln_sf File.absolute_path(path), File.absolute_path(hostfile)
        print_link File.basename(path), File.absolute_path(hostfile)
      end
    end

    def install_fonts!
      Dir.glob 'fonts/*.otf' do | repofile |
        hostfile = "/Library/#{repofile}"
        unless file_exists? hostfile
          FileUtils.cp repofile, hostfile
        end
      end
    end

    def disable_chrome_swiping!
      `defaults write com.google.Chrome.plist AppleEnableSwipeNavigateWithScrolls -bool FALSE`
    end

    def copy_iterm_profile!
      prefs = "com.googlecode.iterm2.plist"
      repofile = "iTerm/#{prefs}"
      hostfile = "#{Dir.home}/Library/Preferences/#{prefs}"

      FileUtils.rm_f hostfile if file_exists? hostfile
      FileUtils.cp repofile, hostfile
      print_link prefs, hostfile
    end

    def symlink_sublime_directory!
      symlink_folder(
        "Sublime/Packages/User",
        "#{Dir.home}/Library/Application\ Support/Sublime\ Text\ 3/Packages/User"
      )

      # Set up /bin/subl
      FileUtils.ln_sf "/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl", "/usr/local/bin/subl"
    end

    def symlink_alfred!
      symlink_folder(
        "Alfred",
        "#{Dir.home}/Library/Application\ Support/Alfred"
      )
    end

    def symlink_oh_my_zsh!
      symlink_folder(
        "oh-my-zsh/custom/plugins",
        "#{Dir.home}/.oh-my-zsh/custom/plugins"
      )
    end

    def symlink_extras!
      symlink_folder("IMDB\ this.workflow", "#{Dir.home}/Library/Services/IMDB\ this.workflow")
      symlink_folder("HexColorPicker.colorPicker", "#{Dir.home}/Library/ColorPickers/HexColorPicker.colorPicker")
    end

    def run!
      symlink_dotfiles!
      disable_chrome_swiping!
      symlink_sublime_directory!
      symlink_alfred!
      symlink_oh_my_zsh!
      symlink_extras!
      copy_iterm_profile!
      install_fonts!
      printf 'Now update ~/.gitconfig to refer to your GitHub username instead of mine :)'
    end

  private

    def print_link(src, dest)
      printf " %15s -> %s\n", src, dest.gsub!("/Users/#{username}", '~')
    end

    def username
      `whoami`
    end

    def file_exists? (file)
      File.exists?(file) || File.symlink?(file)
    end

    def symlink_folder(source, destination)
      FileUtils.rm_f destination if file_exists? destination
      FileUtils.ln_sf File.absolute_path(source), destination
      print_link source, destination
    end
  end
end

Bootstrap.run!
