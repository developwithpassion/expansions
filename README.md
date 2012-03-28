#developwithpassion_expander

This was one of the first projects I wrote when I was teaching myself ruby. A lot of the codebase definitely shows its age, but it is also what I use to this day to manage my [cross platform script configuration system].

It is really an extremely scaled down rake built to suit one specific purpose (supporting the expansions for the scripts I was managing!!)

#Usage

Create an ExpansionFile and place it in a folder that you want to use the expander in.

Here is the simplest possible ExpansionFile you could write:

```ruby
expand do
  puts "Hello"
end
```

Along with regular ruby, within the context of an expand block you have access to the following methods:

-look_for_templates_in [pattern]
  * This method allows you to specify glob style patterns for template files that will be used during the expansion process. Currently the system only supports Mustache and ERB templates and also expects the template files to end with their appropriate {mustache/erb} extension.
    During the epansion process files that have been registered as templates will get expanded according to configuration information that has been provided to [configatron](https://github.com/markbates/configatron). My recommendation is to load configuration information near the start of your ExpansionFile. Here is an example of loading the configuration:

```ruby
configs = {
  :core => 
  { 
    :home => ENV["HOME"] ,
    :devtools_root => File.expand_path(File.dirname(__FILE__))
  }
}
configatron.configure_from_hash configs
load "#{File.basename(`whoami`.chomp)}.settings"

platform_config_file = "expansions/config_#{platform}"
log "Loading config file #{platform_config_file}"
load "#{platform_config_file}"
```
Notice in the example above I am populating configatron with information from one hash in the main ExpansionFile as well as supplementing that configuration information with configuration information from another file. Here is what is in the platform_config_file:

```ruby
configatron.configure_from_hash :core =>{
    :launcher => '',
    :vim => 'mvim',
    :editor => 'mvim -v -f -c "au VimLeave * !open -a Terminal"',
    :is_windows => false,
    :is_cygwin => false,
    :is_mingw => false,
    :is_osx => true,
    :vi => "'mvim -v'",
  },
  :git => {
    :autocrlf => 'input',
    :merge_tool => 'vimdiff',
    :diff_tool => 'vimdiff',
  },
  :vim => {
    :environment => 'mac'
  }
```
