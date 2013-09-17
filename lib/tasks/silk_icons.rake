require 'silk_icons/info'
require 'silk_icons/engine'
require 'pathname'
require 'tmpdir'

namespace :silk_icons do

  docs_dir = Pathname('doc/silk_icons')
  images_dir = Pathname('vendor/assets/images/silk_icons')
  sprite_image = images_dir + 'sprite.png'
  stylesheets_dir = Pathname('vendor/assets/stylesheets')
  stylesheet = stylesheets_dir + 'silk_icons.css.scss'

  desc 'Display available silk icon names'
  task :names do
    puts (SilkIcons::Engine.config.root + stylesheet).read.scan(/^\.silk_icon-(\S+)/)
  end

  directory "#{docs_dir}"
  directory "#{images_dir}"
  directory "#{stylesheets_dir}"

  task sprite: "#{sprite_image}"
  task stylesheet: "#{stylesheet}"

  task :dev_only do
    unless Pathname('silk_icons.gemspec').exist?
      puts 'This task is for the development of silk_icons gem itself.'
      exit
    end
  end

  task fetch: :dev_only do
    sh 'curl -O %s' % SilkIcons::ARCHIVE_URL
  end

  desc 'Unpack the archive and place files in appropriate locations.'
  task unpack: :dev_only do
    archive_path = Pathname(File.basename(SilkIcons::ARCHIVE_URL.path)).expand_path
    ENV['SILK_ICONS_TMP'] = dir = Dir.mktmpdir
    at_exit { rm_r dir }
    Dir.chdir dir do
     sh 'unzip -q %s' % archive_path
    end
  end

  task docs: [ :unpack, "#{docs_dir}" ] do
    %w(readme.html readme.txt).each do |file|
      mv Pathname(ENV['SILK_ICONS_TMP']) + file, docs_dir
    end
  end

  file "#{sprite_image}" => [ :unpack, "#{images_dir}" ] do
    dst = sprite_image.expand_path

    Dir.chdir ENV['SILK_ICONS_TMP'] do
      pngs = FileList['icons/*.png'].sort

      pnms = pngs.pathmap('%X.pnm')
      pngs.zip(pnms).each {|png, pnm| sh 'pngtopam %s > %s' % [png, pnm] }

      alpha_pnms = pnms.pathmap('%X-alpha.pnm')
      pngs.zip(alpha_pnms).each {|png, pnm| sh 'pngtopam --alpha %s > %s' % [png, pnm] }

      row_pnms = pnms.each_slice(40).with_index.map do |row, i|
        row_pnm = 'row%d.pnm' % i
        sh 'pnmcat --leftright %s > %s' % [ row.join(' '), row_pnm]
        row_pnm
      end

      row_alpha_pnms = alpha_pnms.each_slice(40).with_index.map do |row, i|
        row_alpha_pnm = 'row%d-alpha.pnm' % i
        sh 'pnmcat --leftright %s > %s' % [ row.join(' '), row_alpha_pnm]
        row_alpha_pnm
      end

      sh 'pnmcat --topbottom %s > %s' % [ row_pnms.join(' '), 'sprite.pnm']
      sh 'pnmcat --topbottom %s > %s' % [ row_alpha_pnms.join(' '), 'sprite-alpha.pnm']
      sh 'pnmtopng --compress 9 --alpha %s %s > %s' % [ 'sprite-alpha.pnm', 'sprite.pnm', dst ]
    end
  end

  file "#{stylesheet}" => [ :unpack, "#{stylesheets_dir}" ] do |t|
    content = <<-PREAMBLE.gsub(/^    /, '')
    @mixin silk-icon-sprite-at-index($n) {
      background-image: image-url('silk_icons/sprite.png') !important;
      background-repeat: no-repeat !important;
      background-position: ($n % 40) * (-16px) floor($n / 40) * (-16px) !important;
      width: 16px !important;
      height: 16px !important;
      overflow: hidden !important;
    }
    PREAMBLE
    Dir.chdir ENV['SILK_ICONS_TMP'] do
      pngs = FileList['icons/*.png'].pathmap('%n').sort
      pngs.each_with_index do |png, i|
        content += <<-STYLE.lstrip
        .silk_icon-#{png} { @include silk-icon-sprite-at-index(#{i}); }
        STYLE
      end
    end

    File.write(t.name, content, encoding: 'US-ASCII')
  end
end
