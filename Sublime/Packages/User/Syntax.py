import sublime, sublime_plugin
import os

class DetectFileTypeCommand(sublime_plugin.EventListener):
  def on_load(self, view):
    filename = view.file_name()
    if not filename: # buffer has never been saved
      return

    name = os.path.basename(filename.lower())
    if name[-8:] == "_spec.rb":
      set_syntax(view, "RSpec", "RSpec")
    elif name == "factories.rb":
      set_syntax(view, "RSpec", "RSpec")
    elif name[-4:] == "file":
      set_syntax(view, "Ruby on Rails", "Rails")
    elif name[-2:] == "rc":
      set_syntax(view, "Shell-Unix-Generic", "ShellScript")

def set_syntax(view, syntax, path=None):
  if path is None:
    path = syntax
  view.settings().set('syntax', 'Packages/'+ path + '/' + syntax + '.tmLanguage')
  print("Switched syntax to: " + syntax)
