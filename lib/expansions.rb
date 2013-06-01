require 'configatron'
require 'fileutils'
require 'erb'
require 'singleton'
require 'mustache'
require 'arrayfu'

require 'expansions/array'
require 'expansions/cli_interface'
require 'expansions/copy'
require 'expansions/copy_to_target'
require 'expansions/enumerable_extensions'
require 'expansions/erb_template_file'
require 'expansions/shell_action_against_file'
require 'expansions/expansion'
require 'expansions/file'
require 'expansions/file_merge'
require 'expansions/log'
require 'expansions/mustache_template_file'
require 'expansions/shell'
require 'expansions/startup'
require 'expansions/string'
require 'expansions/template_processors'
require 'expansions/template_visitor'
require 'expansions/expansions'

include Expansions
