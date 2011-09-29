# Silk Icons

This is a collection of Mark James's Silk icons tailored to use as Rails assets.

## Installation

In your project's Gemfile, add the following line and rerun Bundler.

    gem 'silk_icons'

## Hot to Use

In views, the `silk_icon_tag` helper inserts an image tag corresponding to the
icon with the given name.  For example, to display `tick.png`, use

    <%= silk_icon_tag 'tick' %>

Each icon also has CSS class which can be used to specify that icon as
background image.  To use them, add

    /* =require silk_icons */

to your `app/assets/stylesheets/application.css`.  The rule these class
names follow is `silk_icon-`<var>name</var>.

## Terms of Use

The Silk icon set iself is created by Mark James and can be distributed under
[CC BY 2.5 or 3.0][1].

## Contact

Drop me a message at [GitHub][2] or [Twitter][3].

[1]: http://www.famfamfam.com/lab/icons/silk/
[2]: https://github.com/sakuro
[3]: http://twitter.com/sakuro
