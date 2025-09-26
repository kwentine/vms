lang en_US.UTF-8
keyboard se
timezone CET
text

# User credentials
%{ if root_allow_login }
rootpw ${root_password_crypted} --iscrypted --allow-ssh
%{ else }
rootpw --lock
%{ endif }

user --name ${user_name} --password ${user_password_crypted} --iscrypted --groups wheel
sshkey --username ${user_name} "${user_ssh_public_key}"

# Registration
%{ if rhel_register_system }
rhsm --organization=${rhel_org} --activation-key=${rhel_activation_key}
syspurpose --role="Red Hat Enterprise Linux Workstation" --sla="Self-Support" --usage="Development/Test"

%post
subscription-manager unregister
%end
%{ endif }

# Disk partitioning: keep it simple
zerombr
clearpart --all --initlabel
autopart --type=plain

skipx
firstboot --disable
selinux --enforcing
poweroff

%packages
@^server-product-environment
@emacs
emacs-nw
%end

%post
echo "guest ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${user_name}
subscription-manager unregister
%end
