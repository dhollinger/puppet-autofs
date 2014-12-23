# = Class: autofs::config
#
# Creates /automount directory and, if used, the automount directory and links
# for automount home directories
#
# Requires the use of environments and hieradata.
# Requires Hiera YAML backend.
#
class autofs::config {

  create_resources( 'autofs::mount', hiera('mapOptions'))

}
