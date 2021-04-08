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
task :html => SOURCE_FILES.pathmap("%{^src/,out/}X.html")
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

rule ".html" => [->(f){source_for_html(f)}, "out"] do |t|
  mkdir_p t.name.pathmap("%d")
  sh "pandoc --lua-filter #{PANDOC_DIR}/pandoc-ling.lua -o #{t.name} #{t.source}"
end

def source_for_html(html_file)
  SOURCE_FILES.detect { |f|
    f.ext('') == html_file.pathmap("%{^out/,src/}X")
  }
end
