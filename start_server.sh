#!/bin/bash

# Let's configure te database access if not already there
if [ ! -e /var/www/bolt/app/config/config.yml ]; then
  echo "Configuration file for bolt not found, creating a new one from template"
  echo "

# Default configuration for Bolt

sitename: My docker-powerd bolt
payoff: Ready to publish
theme: base-2014
locale: en_US
maintenance_mode: false
maintenance_template: maintenance_default.twig
cron_hour: 3
homepage: page/1
homepage_template: index.twig
notfound: page/not-found
record_template: record.twig
listing_template: listing.twig
listing_records: 6
listing_sort: datepublish DESC
taxonomy_sort: DESC
search_results_template: listing.twig
search_results_records: 10
add_jquery: false

# Caching configuration
caching:
    config: false
    templates: true
    request: false
    duration: 10
    authenticated: false

# Disable this if it creates too much overhead at some point
changelog:
    enabled: true

# Thumbnail configuration
thumbnails:
    default_thumbnail: [ 160, 120 ]
    default_image: [ 1000, 750 ]
    quality: 80
    cropping: crop
    notfound_image: view/img/default_notfound.png
    error_image: view/img/default_error.png
    save_files: false
    allow_upscale: false
    exif_orientation: true

# HTML handling (for articles posted via the web interface)
htmlcleaner:
    allowed_tags: [ div, p, br, hr, s, u, strong, em, i, b, li, ul, ol, blockquote, pre, code, tt, h1, h2, h3, h4, h5, h6, dd, dl, dh, table, tbody, thead, tfoot, th, td, tr, a, img ]
    allowed_attributes: [ id, class, style, name, value, href, src ]

# Upload rules
accept_file_types: [ twig, html, js, css, scss, gif, jpg, jpeg, png, ico, zip, tgz, txt, md, doc, docx, pdf, epub, xls, xlsx, ppt, pptx, mp3, ogg, wav, m4a, mp4, m4v, ogv, wmv, avi, webm, svg]

# Debug options (TODO: remove in prod and make this configurable through an environment variable)
debug: true
developer_notices: false
debug_show_loggedoff: false
debug_permission_audit_mode: false
debug_error_level: 6135 # equivalent to E_ALL &~ E_NOTICE &~ E_DEPRECATED &~ E_USER_DEPRECATED
# debug_error_level: 30719 # equivalent to E_ALL
debug_enable_whoops: true # change this to false to use PHP's built-in error handling instead of Whoops

# System debug logging (to enable when debugging)
debuglog:
    enabled: false
    filename: bolt-debug.log
    level: DEBUG

# Use strict variables. This will make Bolt complain if you use {{ foo }},
# when foo doesn't exist.
strict_variables: false

# There are several options for giving editors more options to insert images,
# video, etc in the WYSIWYG areas. But, as you give them more options, that
# means they also have more ways of breaking the preciously designed layout.
#
# By default the most 'dangerous' options are set to 'false'. If you choose to
# enable them for your editors, please instruct them thoroughly on their
# responsibility not to break the layout.
wysiwyg:
    images: false            # Allow users to insert images in the content.
    anchor: false            # Adds a button to create internal anchors to link to.
    tables: false            # Adds a button to insert and modify tables in the content.
    fontcolor: false         # Allow users to mess around with font coloring.
    align: false             # Adds buttons for 'align left', 'align right', etc.
    subsuper: false          # Adds buttons for subscript and superscript, using <sub> and <sup>.
    embed: false             # Allows the user to insert embedded video's from Youtube, Vimeo, etc.
    underline: false         # Adds a button to underline text, using the <u>-tag.
    ruler: false             # Adds a button to add a horizontal ruler, using the <hr>-tag.
    strike: false            # Adds a button to add stikethrough, using the <s>-tag.
    blockquote: false        # Allows the user to insert code snippets using <pre><code>-tags.
    codesnippet: false       # Allows the user to insert blockquotes using the <blockquote>-tag.
    specialchar: false       # Adds a button to insert special chars like '€' or '™'.
    ck:
        allowedContent: true # If set to 'true', any elements and attributes are allowed in Wysiwg Elements
        autoParagraph: true  # If set to 'true', any pasted content is wrapped in <p>-tags for multiple line-breaks
        disableNativeSpellChecker: true # If set to 'true' it will stop browsers from underlining spelling mistakes
        allowNbsp: false     # If set to 'false', the editor will strip out &nbsp; characters. If set to 'true', it will allow them. ¯\\_(ツ)_/¯
        # viewSourceRoles: [ 'admin', 'developer' ] # The roles which are allowed to use the [Source]-button.

liveeditor: true

# Cookie settings
cookies_use_remoteaddr: true
cookies_use_browseragent: false
cookies_use_httphost: true
cookies_lifetime: 1209600
# Leave blank for now
cookies_domain:

session_use_storage_handler: true

hash_strength: 10

# Bolt extensions
extensions:
    site: 'https://extensions.bolt.cm/'
    stability: stable
    enabled: true

# TODO: make this configurable through an environment variable too
# enforce_ssl: true

# Database configuration, generated by the start_server.sh script
# embedded in the docker image of the server. Do not edit by hand.

# This overrides the default bolt settings (SQLLite)

database:
  driver: mysql
  username: $BOLT_DB_ENV_MYSQL_USER
  password: $BOLT_DB_ENV_MYSQL_PASSWORD
  databasename: $BOLT_DB_ENV_MYSQL_DATABASE
  host: $BOLT_DB_PORT_3306_TCP_ADDR
  port: $BOLT_DB_PORT_3306_TCP_PORT
  " > /var/www/bolt/app/config/config.yml
  env
else # Just do a SED on the dabase host
  echo "Sedding the new Database IP in config.yml"
  sed -ri "s/  host: ([0-9]{1,3}.){3}[0-9]{1,3}/  host: $BOLT_DB_PORT_3306_TCP_ADDR/" /var/www/bolt/app/config/config.yml
fi

# Let's allow editing of this config file through the bolt admin interface
chown -R www-data /var/www

# Ok, now let's wait for our DataBase server to respond for a bit
set -e
echo -n "Waiting for TCP connection to $BOLT_DB_PORT_3306_TCP_ADDR:$BOLT_DB_PORT_3306_TCP_PORT..."

while ! nc -w 1 $BOLT_DB_PORT_3306_TCP_ADDR $BOLT_DB_PORT_3306_TCP_PORT 2>/dev/null
do
  echo -n .
  sleep 1
done
set +e

# And finally run the bolt application onto an NGinx/PHP-FPM webserver
service php5-fpm start
echo "\n Starting Bolt server container...\n\n"
echo "    Executing... $@ \n\n"

exec "$@"
