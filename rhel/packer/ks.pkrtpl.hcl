lang en_US.UTF-8
keyboard se
timezone CET
text

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
emacs-nw
cloud-init
%end
