require "active_record"
require "sqlite3"
require "faker"
require "colorize"

Dir.glob("lib/*.rb").each do |path|
  require_relative path
end

Dir.glob("tasks/*.rake").each do |path|
  import path
end
