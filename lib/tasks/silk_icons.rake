require 'silk_icons/info'
require 'pathname'
require 'tmpdir'

namespace :silk_icons do
  docs_dir = Pathname('doc/silk_icons').expand_path
  images_dir = Pathname('app/assets/images/silk_icons').expand_path
  stylesheets_dir = Pathname('app/assets/stylesheets')

  directory "#{docs_dir}"
  directory "#{images_dir}"
  directory "#{stylesheets_dir}"

  task :dev_only do
    unless Pathname('silk_icons.gemspec').exist?
      puts 'This task is for the development of silk_icons gem itself.'
      exit
    end
  end
  desc 'Unpack the archive and place files in appropriate locations'
  task unpack: [ :dev_only, "#{docs_dir}", "#{images_dir}" ] do

    basename = File.basename(SilkIcons::ARCHIVE_URL.path)
    Dir.mktmpdir do |dir|
      Dir.chdir dir do
       sh 'curl -O %s' % SilkIcons::ARCHIVE_URL
       sh 'unzip -q %s' % basename
       %w(readme.html readme.txt).each do |file|
         file = Pathname(file)
         mv file, docs_dir + file.basename
       end
       Dir['icons/*'].each do |icon|
         icon = Pathname(icon)
         mv icon, images_dir + icon.basename
       end
      end
    end
  end

  file "#{stylesheets_dir + 'silk_icons.css.scss'}" => [ :dev_only, "#{stylesheets_dir}" ] do |t|
    icons = FileList["#{images_dir}/*.png"].pathmap('%n')
    content = icons.map do |icon|
      ".silk_icon-#{icon} { background: image-url('silk_icons/#{icon}.png') no-repeat; }"
    end.join("\n")
    File.write(t.name, content, encoding: 'US-ASCII')
  end
end
