# starship-workstation
Provision my Linux workstation using the awesome Converge tool https://github.com/asteris-llc/converge.
A different take on having a Ansible playbook do this. Converge is a singel binary(written in golang). Makes simple things easy when you don't require all the bells and whistles that ansible provides.  And because it's written in golang there's a single binary with no need to install anything else.

This particalur setup is targted at PopOS 18.10, distro based off Ubuntu 18.10. If you don't have apt and apt-get on your distro this probably won't work well.  In the current state this setup will only work on my personal workstation, but maybe be handy for folks as a template.

1. clone this repo
2. cd into starship-workstation
3. sudo converge apply --local main.hcl

# TODO
1. Break into multiple files
2. Parameterize all the hard codings

