defmodule Servy.Views.SensorsView do
  require EEx

  @templates_path Path.expand("templates/sensors", File.cwd!)

  EEx.function_from_file :def, :index, Path.join(@templates_path, "index.html.eex"), [:snapshots, :location]
end