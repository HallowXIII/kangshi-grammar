SOURCE_FILES = Rake::FileList.new("**/*.md", "**/*.markdown") do |fl|
  fl.exclude("~*")
  fl.exclude("README*")
end

PANDOC_DIR = if (env_dir = ENV['pandoc_dir']) == nil then
               File.expand_path("~/.pandoc/")
             else
               File.expand_path(env_dir)
             end

task :default => :html
task :html => SOURCE_FILES.pathmap("%{^src/,out/html/}X.html")
task :bbcode => SOURCE_FILES.pathmap("%{^src/,out/bbcode/}X.bbcode")
task :epub do |t|
  mkdir_p "out"
  sh <<~SHCOMMAND
    pandoc \
    --lua-filter #{PANDOC_DIR}/pandoc-ling.lua -t epub3 -o out/kangshi.epub \
    src/meta.yml \
    #{SOURCE_FILES}
  SHCOMMAND
end

directory "out"

rule ".html" => [->(f){source_for_format(f, "html")}, "out"] do |t|
  mkdir_p t.name.pathmap("%d")
  sh "pandoc --lua-filter #{PANDOC_DIR}/pandoc-ling.lua -o #{t.name} #{t.source}"
end

rule ".bbcode" => [->(f){source_for_format(f, "bbcode")}, "out"] do |t|
  mkdir_p t.name.pathmap("%d")
  sh "pandoc --lua-filter #{PANDOC_DIR}/pandoc-ling.lua -t bbcode.lua -o #{t.name} #{t.source}"
end

def source_for_format(format_file, format_dir)
  SOURCE_FILES.detect { |f|
    f.ext('') == format_file.pathmap("%{^out/#{format_dir}/,src/}X")
  }
end
