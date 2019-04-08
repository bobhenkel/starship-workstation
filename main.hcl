task "apt-update" {
  check = "exit 1"
  apply = "apt-get update"
}

package.apt "fish" {
  name  = "fish"
  state = "present"
  depends = ["task.apt-update"]
}

package.apt "flameshot" {
  name  = "flameshot"
  state = "present"
  depends = ["task.apt-update"]
}

package.apt "htop" {
  name  = "htop"
  state = "present"
  depends = ["task.apt-update"]
}

package.apt "krita" {
  name  = "krita"
  state = "present"
  depends = ["task.apt-update"]
}

package.apt "mypaint" {
  name  = "mypaint"
  state = "present"
  depends = ["task.apt-update"]
}

package.apt "tree" {
  name  = "tree"
  state = "present"
  depends = ["task.apt-update"]
}

package.apt "speedtest-cli" {
  name  = "speedtest-cli"
  state = "present"
  depends = ["task.apt-update"]
}

package.apt "jq" {
  name  = "jq"
  state = "present"
  depends = ["task.apt-update"]
}

package.apt "gnome-tweak-tool" {
  name  = "gnome-tweak-tool"
  state = "present"
  depends = ["task.apt-update"]
}

package.apt "httpie" {
  name  = "httpie"
  state = "present"
  depends = ["task.apt-update"]
}

package.apt "i3" {
  name  = "i3"
  state = "present"
  depends = ["task.apt-update"]
}
package.apt "peco" {
  name  = "peco"
  state = "present"
  depends = ["task.apt-update"]
}
task "install-docker" {
  check = "docker run hello-world"
    apply = <<EOF
#!/bin/bash
set -x -v -e
apt-get remove -y docker docker-engine docker.io containerd runc
apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker bhenkel
EOF
}

task "install-bat" {
  check = "which bat"
  apply = <<EOF
#!/bin/bash
set -x -v -e
wget "https://github.com/sharkdp/bat/releases/download/v0.10.0/bat_0.10.0_amd64.deb" -P /tmp/
dpkg -i /tmp/bat_0.10.0_amd64.deb
EOF
  depends = ["task.apt-update"]
}


task "install-google-chrome" {
  check = "which google-chrome"
  apply = <<EOF
#!/bin/bash
set -x -v -e
dpkg -i /tmp/google-chrome-stable_current_amd64.deb
EOF
  depends = ["file.fetch.dl-google-chrome"]
}

file.fetch "dl-google-chrome" {
  source      = "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  destination = "/tmp/google-chrome-stable_current_amd64.deb"
}


task "install-slack-dep" {
  check = "which slack"
  apply = <<EOF
#!/bin/bash
set -x -v -e
sudo apt-get install -y gconf-service gconf-service-backend gconf2 gconf2-common libappindicator1 libdbusmenu-gtk4 libgconf-2-4 libindicator7
EOF
  depends = ["task.apt-update"]
}

task "install-slack" {
  check = "which slack"
  apply = <<EOF
#!/bin/bash
set -x -v -e
dpkg -i /tmp/slack-desktop-3.3.8-amd64.deb
EOF
  depends = ["file.fetch.dl-slack","task.install-slack-dep"]
}

file.fetch "dl-slack" {
  source      = "https://downloads.slack-edge.com/linux_releases/slack-desktop-3.3.8-amd64.deb"
  destination = "/tmp/slack-desktop-3.3.8-amd64.deb"
}

file.fetch "dl-kubectl" {
  source      = "https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl"
  destination = "/home/bhenkel/.local/bin/kubectl"
  depends = ["file.directory.home-local-bin"]
}

file.owner "kubectl" {
  destination = "/home/bhenkel/.local/bin/kubectl"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["file.fetch.dl-kubectl"]
}

file.mode "kubectl" {
  destination = "/home/bhenkel/.local/bin/kubectl"
  mode        = 0755
  depends = ["file.fetch.dl-kubectl"]
}

file.directory "home-local-bin" {
  destination = "/home/bhenkel/.local/bin"
  create_all  = true
}

file.owner "home-local-bin" {
  destination = "/home/bhenkel/.local/bin"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["file.directory.home-local-bin"]
}

task "install-pet" {
  check = "which pet"
  apply = <<EOF
#!/bin/bash
set -x -v -e
dpkg -i /tmp/pet_0.3.4_linux_amd64.deb
EOF
  depends = ["file.fetch.dl-pet"]
}

file.fetch "dl-pet" {
  source      = "https://github.com/knqyf263/pet/releases/download/v0.3.4/pet_0.3.4_linux_amd64.deb"
  destination = "/tmp/pet_0.3.4_linux_amd64.deb"
}

file.fetch "dl-k8s-auth" {
  source      = "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/0.4.0-alpha.1/aws-iam-authenticator_0.4.0-alpha.1_linux_amd64"
  destination = "/home/bhenkel/.local/bin/aws-iam-authenticator_0.4.0-alpha.1_linux_amd64"
  depends = ["file.directory.home-local-bin"]
}

file.owner "k8s-auth" {
  destination = "/home/bhenkel/.local/bin/aws-iam-authenticator_0.4.0-alpha.1_linux_amd64"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["file.fetch.dl-k8s-auth"]
}

file.mode "k8s-auth" {
  destination = "/home/bhenkel/.local/bin/aws-iam-authenticator_0.4.0-alpha.1_linux_amd64"
  mode        = 0755
  depends = ["file.fetch.dl-k8s-auth"]
}

file.directory "home-aws" {
  destination = "/home/bhenkel/.aws"
  create_all  = true
}

file.owner "home-aws" {
  destination = "/home/bhenkel/.aws"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["file.directory.home-aws"]
}

task "install-spotify" {
  check = "which spotify"
    apply = <<EOF
#!/bin/bash
set -x -v -e
# 1. Add the Spotify repository signing keys to be able to verify downloaded packages
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90

# 2. Add the Spotify repository
echo deb http://repository.spotify.com stable non-free | tee /etc/apt/sources.list.d/spotify.list

# 3. Update list of available packages
apt-get update

# 4. Install Spotify
apt-get install spotify-client
EOF
}

file.directory "home-kube" {
  destination = "/home/bhenkel/.kube"
  create_all  = true
}

file.owner "home-kube" {
  destination = "/home/bhenkel/.kube"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["file.directory.home-kube"]
}

file.directory "home-kube-daffy" {
  destination = "/home/bhenkel/.kube/daffy"
  create_all  = true
}

file.owner "home-kube-daffy" {
  destination = "/home/bhenkel/.kube/daffy"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["file.directory.home-kube-daffy"]
}


task "install-vscode" {
  check = "which code"
  apply = <<EOF
#!/bin/bash
set -x -v -e
dpkg -i /tmp/code_1.32.3-1552606978_amd64.deb
EOF
  depends = ["file.fetch.dl-vscode"]
}

file.fetch "dl-vscode" {
  source      = "https://az764295.vo.msecnd.net/stable/a3db5be9b5c6ba46bb7555ec5d60178ecc2eaae4/code_1.32.3-1552606978_amd64.deb"
  destination = "/tmp/code_1.32.3-1552606978_amd64.deb"
}

file.fetch "dl-stern" {
  source      = "https://github.com/wercker/stern/releases/download/1.10.0/stern_linux_amd64"
  destination = "/home/bhenkel/.local/bin/stern"
  depends = ["file.directory.home-local-bin"]
}

file.owner "stern" {
  destination = "/home/bhenkel/.local/bin/stern"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["file.fetch.dl-stern"]
}

file.mode "stern" {
  destination = "/home/bhenkel/.local/bin/stern"
  mode        = 0755
  depends = ["file.fetch.dl-stern"]
}

file.fetch "dl-etcher" {
  source      = "https://github.com/balena-io/etcher/releases/download/v1.5.17/balenaEtcher-1.5.17.AppImage"
  destination = "/home/bhenkel/.local/bin/balenaEtcher-1.5.17.AppImage"
  depends = ["file.directory.home-local-bin"]
}

file.owner "etcher" {
  destination = "/home/bhenkel/.local/bin/balenaEtcher-1.5.17.AppImage"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["file.fetch.dl-etcher"]
}

file.mode "etcher" {
  destination = "/home/bhenkel/.local/bin/balenaEtcher-1.5.17.AppImage"
  mode        = 0755
  depends = ["file.fetch.dl-etcher"]
}

task "install-brave" {
  check = "which brave-browser"
    apply = <<EOF
#!/bin/bash
set -x -v -e
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ cosmic main" | tee /etc/apt/sources.list.d/brave-browser-release-cosmic.list

apt update

apt install -y brave-keyring brave-browser
EOF
  depends = ["task.apt-update"]
}

task "install-vivaldi" {
  check = "which vivaldi"
  apply = <<EOF
#!/bin/bash
set -x -v -e
dpkg -i /tmp/vivaldi-stable_2.4.1488.35-1_amd64.deb
EOF
  depends = ["file.fetch.dl-vivaldi","task.apt-update"]
}

file.fetch "dl-vivaldi" {
  source      = "https://downloads.vivaldi.com/stable/vivaldi-stable_2.4.1488.35-1_amd64.deb"
  destination = "/tmp/vivaldi-stable_2.4.1488.35-1_amd64.deb"
}

task "install-terraform" {
  check = "which terraform"
  apply = <<EOF
#!/bin/bash
set -x -v -e
unzip -o /tmp/terraform_0.11.13_linux_amd64.zip -d /home/bhenkel/.local/bin
EOF
  depends = ["file.fetch.dl-terraform","file.directory.home-local-bin"]
}
file.fetch "dl-terraform" {
  source      = "https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip"
  destination = "/tmp/terraform_0.11.13_linux_amd64.zip"
}

file.owner "terraform" {
  destination = "/home/bhenkel/.local/bin/terraform"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["task.install-terraform"]
}
file.mode "terraform" {
  destination = "/home/bhenkel/.local/bin/terraform"
  mode        = 0755
  depends = ["task.install-terraform"]
}

task "install-packer" {
  check = "which packer"
  apply = <<EOF
#!/bin/bash
set -x -v -e
unzip -o /tmp/packer_1.3.5_linux_amd64.zip -d /home/bhenkel/.local/bin
EOF
  depends = ["file.fetch.dl-packer","file.directory.home-local-bin"]
}
file.fetch "dl-packer" {
  source      = "https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_linux_amd64.zip"
  destination = "/tmp/packer_1.3.5_linux_amd64.zip"
}

file.owner "packer" {
  destination = "/home/bhenkel/.local/bin/packer"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["task.install-packer"]
}
file.mode "packer" {
  destination = "/home/bhenkel/.local/bin/packer"
  mode        = 0755
  depends = ["task.install-packer"]
}
task "install-vagrant" {
  check = "which vagrant"
  apply = <<EOF
#!/bin/bash
set -x -v -e
unzip -o /tmp/vagrant_2.2.4_linux_amd64.zip -d /home/bhenkel/.local/bin
EOF
  depends = ["file.fetch.dl-vagrant","file.directory.home-local-bin"]
}
file.fetch "dl-vagrant" {
  source      = "https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_linux_amd64.zip"
  destination = "/tmp/vagrant_2.2.4_linux_amd64.zip"
}

file.owner "vagrant" {
  destination = "/home/bhenkel/.local/bin/vagrant"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["task.install-vagrant"]
}
file.mode "vagrant" {
  destination = "/home/bhenkel/.local/bin/vagrant"
  mode        = 0755
  depends = ["task.install-vagrant"]
}

####
task "install-kubectx-kubens" {
  check = "which kubectx && which kubens"
  apply = <<EOF
#!/bin/bash
set -x -v -e
if [ -d "/tmp/kubectx" ]; then rm -Rf /tmp/kubectx; fi
git clone https://github.com/ahmetb/kubectx /tmp/kubectx
cp /tmp/kubectx/kubectx /home/bhenkel/.local/bin
cp /tmp/kubectx/kubens /home/bhenkel/.local/bin
EOF
  depends = ["file.directory.home-local-bin"]
}

file.owner "kubens" {
  destination = "/home/bhenkel/.local/bin/kubens"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["task.install-kubectx-kubens"]
}
file.mode "kubens" {
  destination = "/home/bhenkel/.local/bin/kubens"
  mode        = 0755
  depends = ["task.install-kubectx-kubens"]
}
package.apt "gpick" {
  name  = "gpick"
  state = "present"
  depends = ["task.apt-update"]
}

####
task "install-helm" {
  check = "which helm"
  apply = <<EOF
#!/bin/bash
set -x -v -e
wget "https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz" -P /tmp/
tar -zxvf /tmp/helm-v2.13.1-linux-amd64.tar.gz --directory /tmp
mv /tmp/linux-amd64/helm /home/bhenkel/.local/bin/helm
EOF
  depends = ["file.directory.home-local-bin"]
}

file.owner "helm" {
  destination = "/home/bhenkel/.local/bin/helm"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["task.install-helm"]
}
file.mode "helm" {
  destination = "/home/bhenkel/.local/bin/helm"
  mode        = 0755
  depends = ["task.install-helm"]
}

####
task "install-task" {
  check = "which task"
  apply = <<EOF
#!/bin/bash
set -x -v -e
wget "https://github.com/go-task/task/releases/download/v2.5.0/task_linux_amd64.tar.gz" -P /tmp/
tar -zxvf /tmp/task_linux_amd64.tar.gz --directory /tmp
mv /tmp/task /home/bhenkel/.local/bin/task
EOF
  depends = ["file.directory.home-local-bin"]
}
file.owner "task" {
  destination = "/home/bhenkel/.local/bin/task"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["task.install-task"]
}
file.mode "task" {
  destination = "/home/bhenkel/.local/bin/task"
  mode        = 0755
  depends = ["task.install-task"]
}

####
task "install-pulumi" {
  check = "which pulumi"
  apply = <<EOF
#!/bin/bash
set -x -v -e
wget "https://get.pulumi.com/releases/sdk/pulumi-v0.17.5-linux-x64.tar.gz" -P /tmp/
tar -zxvf /tmp/pulumi-v0.17.5-linux-x64.tar.gz --directory /tmp
cp -a /tmp/pulumi/. /home/bhenkel/.local/bin/
EOF
  depends = ["file.directory.home-local-bin"]
}
file.owner "pulumi" {
  destination = "/home/bhenkel/.local/bin/pulumi"
  user        = "bhenkel"
  group       = "bhenkel"
  depends = ["task.install-pulumi"]
}
file.mode "pulumi" {
  destination = "/home/bhenkel/.local/bin/pulumi"
  mode        = 0755
  depends = ["task.install-pulumi"]
}

