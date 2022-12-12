#!/bin/sh
os_v=9
branch=$1
os=centos-stream
basearch=x86_64

echo "================== START PREPARATIONS ================================================================"

yum clean metadata
arcnightly=$(curl -s http://builds.nordugrid.org/nightlies/nordugrid-arc/${branch}/ | sed -n 's/^.*<a.*>\(.*\)\/<\/a>.*$/\1/p' | sort  | tail -1)
echo $arcnightly

cat > /etc/yum.repos.d/nordugrid-nightly.repo <<EOF
[nordugrid-nightly]
name=Nordugrid ARC ${branch} (ARC 7) Nightly Builds - $basearch
baseurl=http://builds.nordugrid.org/nightlies/nordugrid-arc/${branch}/$arcnightly/${os}/${os_v}/$basearch
enabled=1
gpgcheck=0
EOF


yum makecache

dnf update "*nordugrid*" -y

printf "cat /etc/yum.repos.d/nordugrid-hackathon.repo\n"
cat /etc/yum.repos.d/nordugrid-hackathon.repo

printf '\n\n======== START Install and start ARC  ==========\n'

printf "\nInstalling client packages"
printf "yum update -y --allowerasing nordugrid-arc-client\n"
yum update -y nordugrid-arc-client

printf "\nInstalling server packages"
printf "yum update -y--allowerasing  nordugrid-arc-arex\n"
yum update -y nordugrid-arc-arex 



printf "arcctl reservice start -a\n"
arcctl service restart -a
printf "arcctl service list\n"
arcctl service list
printf "\n\n======== END Install and start ARC  =========="

echo "================== END PREPARATIONS ===================="
