defmodule Servy.Views.PledgesView do
  require EEx

  @templates_path Path.expand("templates/pledges", File.cwd!)

  EEx.function_from_file :def, :index, Path.join(@templates_path, "index.html.eex"), [:pledges]
  EEx.function_from_file :def, :new,   Path.join(@templates_path, "new.html.eex")
end