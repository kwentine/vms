# Create disk image from container image using bootc-image-builder.
# https://github.com/osbuild/bootc-image-builder
set -eu

# Some base images to have close at hand
# See https://docs.fedoraproject.org/en-US/bootc/base-images/
declare -A BASE_IMAGES=(
  fedora quay.io/fedora/fedora-bootc:42
  rawhide registry.gitlab.com/fedora/bootc/base-images/fedora-bootc-minimal:rawhide-amd64
  centos quay.io/centos-bootc/centos-bootc:stream9
)

BUILDER_REGISTRY=registry.redhat.io
BUILDER_IMAGE=rhel9/bootc-image-builder
OUTPUT_DIR="${PWD}/output"
CONFIG="${PWD}/config.toml"
REGISTRY=registry.redhat.io
IMAGE=rhel9/rhel-bootc

dry_run=0
rootless=0
login=0
pull=0
type=raw
fstype=ext4

EXIT_SUCCESS=0
EXIT_ERROR=1
err_exit() {
  >&2 echo "ERROR: $*"
  exit ${2:-${EXIT_ERROR}}
}

while getopts nlput:f: opt; do
  case "${opt}" in
    n) dry_run=1 ;;
    l) login=1 ;;
    p) pull=1 ;;
    u) rootless=1 ;;
    t) type="${OPTARG}" ;;
    f) fstype="${OPTARG}" ;;
    \?) err_exit "Invalid option: ${opt}" ;;
  esac
done

shift $((OPTIND - 1))

declare -a cmd
if ((dry_run)); then
  cmd=(echo)
fi

if ! ((rootless)); then
  cmd+=(sudo podman)
else
  cmd+=(podman)
fi

run_cmd() {
  "${cmd[@]}" "$@"
}

if ((login)); then
  run_cmd login registry.redhat.io
fi

if ((pull)); then
  "${cmd[@]}" pull "${BUILDER_IMAGE}"
  sudo podman pull "${BOOTC_IMAGE}"
fi

cmd+=(
  run --rm -it
  --privileged
  --security-opt label=type:unconfined_t
  -v "${OUTPUT_DIR}":/output
  -v "${CONFIG}":/config.toml:ro
  -v /var/lib/containers/storage:/var/lib/containers/storage
  "${BUILDER_REGISTRY}/${BUILDER_IMAGE}"
  --type "${type}"
  --chown 1000:1000
  --use-librepo
  --rootfs "${fstype}"
  "${REGISTRY}/${IMAGE}"
)

run_cmd
