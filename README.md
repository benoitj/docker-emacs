# my emacs docker container

see run-linux.sh for an example how to run it.

# configuration

you can configure the container at runtime with docker environment variables (see docker -e option)

Here are the available variables:

    - USER :: User name to use (default: emacs)
    - UID :: user id (default: 1000)
    - GROUP :: primary group name of the user (default: emacs)
    - GID :: group id (default: 1000)

# customization

you can also extend the image to your own liking.

You can look at the [Dockerfile.dotfiles](Dockerfile.dotfiles) as an example.
