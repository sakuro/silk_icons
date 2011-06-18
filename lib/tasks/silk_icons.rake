require 'silk_icons/info'
require 'pathname'
require 'tmpdir'

namespace :silk_icons do
  desc 'Unpack the archive and place files in appropriate locations'
  task :unpack do
    unless Pathname('silk_icons.gemspec').exist?
      puts 'This task is for the development of silk_icons gem itself.'
      next
    end

    doc_dir = Pathname('doc/silk_icons').expand_path
    doc_dir.mkpath

    assets_dir = Pathname('app/assets/images/silk_icons').expand_path
    assets_dir.mkpath

    basename = File.basename(SilkIcons::ARCHIVE_URL.path)
    Dir.mktmpdir do |dir|
      Dir.chdir dir do
       sh 'curl -O %s' % SilkIcons::ARCHIVE_URL
       sh 'unzip -q %s' % basename
       %w(readme.html readme.txt).each do |file|
         file = Pathname(file)
         file.rename(doc_dir + file.basename)
       end
       Dir['icons/*'].each do |icon|
         icon = Pathname(icon)
         icon.rename(assets_dir + icon.basename)
       end
      end
    end
  end
end
