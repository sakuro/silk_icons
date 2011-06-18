require 'silk_icons/info'

module SilkIconsHelper

  # Returns an IMG tag of the silk icon which has the given +name+.
  #
  #   silk_icon_tag('tick')
  #   #=> <img alt="" height="16" src="/assets/silk_icons/tick.png" title="" width="16" /> 
  #
  # Note that both width and height attributes are set to 16.
  #   silk_icon_tag(:tick, title: 'OK', width: 20)
  #   #=> <img alt="" height="16" src="/assets/silk_icons/tick.png" title="OK" width="16" />
  def silk_icon_tag(name, options={})
    options = {alt: '', title: ''}.reverse_merge(options)
    options = options.merge(width: 16, height: 16)
    name = name.to_s
    name += '.png' unless name.ends_with?('.png')
    image_tag('silk_icons/%s' % name, options)
  end

  # Renders CC BY 3.0 license tag for Silk icons.
  #
  # TODO: customizable views
  def silk_license_tag
    render 'silk_icons/license'
  end
end