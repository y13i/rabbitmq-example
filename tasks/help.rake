desc "print usage"
task :help do
  puts "\n", File.read("README.md")
end

task default: :help
