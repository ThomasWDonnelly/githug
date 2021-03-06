require 'thor'
require 'githug'
module Githug
  class CLI < Thor


    default_task :play

    desc :play, "Initialize the game"

    def play
      UI.word_box("Githug")
      make_directory
      game = Game.new
      game.play_level
    end

    desc :test, "Test a level from a file path"
    method_option :errors, :type => :boolean, :default => false

    def test(path)
      UI.word_box("Githug")
      make_directory
      level = Level.load_from_file(path)
      game = Game.new
      game.test_level(level, options[:errors])
    end

    desc :hint, "Get a hint for the current level"

    def hint
      if level = load_level
        level.show_hint
      end
    end

    desc :reset, "Reset the current level"

    def reset(path = nil)
      level = load_level(path)
      UI.word_box("Githug")
      if level
        UI.puts("resetting level")
        level.setup_level
        level.full_description
      else
        UI.error("Level does not exist")
      end
    end

    desc :levels, "List all of the levels"

    def levels
      list_with_numbers = Level.list.each_with_index.map do |name, index|
        "##{index + 1}: #{name}"
      end
      UI.puts(list_with_numbers)
    end

    no_tasks do

      def load_level(path = nil)
        return load_level_from_profile unless path
        return Level.load(path) if Level.list.include?(path)
        Level.load_from_file(path)
      end

      def load_level_from_profile
        profile = Profile.load
        Level.load(profile.level)
      end


      def make_directory
        if File.exists?("./git_hug")
          UI.puts "Please change into the git_hug directory"
          exit
        end

        unless File.basename(Dir.pwd) == "git_hug"
          if UI.ask("No githug directory found, do you wish to create one?")
            Dir.mkdir("./git_hug")
            Dir.chdir("git_hug")
          else
            UI.puts("Exiting")
            exit
          end
        end
      end

    end

  end
end
