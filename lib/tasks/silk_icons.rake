require 'silk_icons/info'
require 'pathname'
require 'tmpdir'

namespace :silk_icons do
  DOCS_DIR = Pathname('doc/silk_icons').expand_path
  IMAGES_DIR = Pathname('app/assets/images/silk_icons').expand_path
  STYLESHEETS_DIR = Pathname('app/assets/stylesheets')

  directory "#{DOCS_DIR}"
  directory "#{IMAGES_DIR}"
  directory "#{STYLESHEETS_DIR}"

  desc 'Unpack the archive and place files in appropriate locations'
  task :unpack => [ "#{DOCS_DIR}", "#{IMAGES_DIR}" ] do
    unless Pathname('silk_icons.gemspec').exist?
      puts 'This task is for the development of silk_icons gem itself.'
      next
    end

    basename = File.basename(SilkIcons::ARCHIVE_URL.path)
    Dir.mktmpdir do |dir|
      Dir.chdir dir do
       sh 'curl -O %s' % SilkIcons::ARCHIVE_URL
       sh 'unzip -q %s' % basename
       %w(readme.html readme.txt).each do |file|
         file = Pathname(file)
         mv file, DOCS_DIR + file.basename
       end
       Dir['icons/*'].each do |icon|
         icon = Pathname(icon)
         mv icon, IMAGES_DIR + icon.basename
       end
      end
    end
  end

  file "#{STYLESHEETS_DIR + 'silk_icons.css.scss'}" => "#{STYLESHEETS_DIR}" do |t|
    icons = FileList["#{IMAGES_DIR}/*.png"].pathmap('%n')
    content = icons.map do |icon|
      ".silk_icon-#{icon} { background: image-url('silk_icons/#{icon}.png') no-repeat; }"
    end.join("\n")
    File.write(t.name, content, encoding: 'US-ASCII')
  end
end
