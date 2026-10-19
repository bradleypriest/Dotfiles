#!/usr/bin/env ruby
# Retain the old entry point while applying only the files declared in mise.toml.
Dir.chdir(__dir__) do
  exec 'mise', 'dot', 'apply', *ARGV
end
