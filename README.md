Debug Container for Fedora CoreOS
=================================

Container image with debug tooling.

Building
--------

BCC/eBFP tools still require kernel sources, so the image needs to target a
specific FCOS release:

```
podman build \
	--build-arg stream=testing \
	--build-arg release=34.20210529.2.0 \
	-t localhost/fcos-debug-container:34.20210529.2.0 .
```

Hopefully this can be removed in the future when everything is using BTF and CO-RE.

Run
---

Super privileged container, the volume mounts are required for BCC/BPF tools:

```
sudo podman run -it --rm \
	--privileged \
	--pid host \
	--net host \
	--ipc host \
	--uts host \
	-v /lib/modules/:/lib/modules/:ro \
	-v /sys/kernel/debug:/sys/kernel/debug \
	-v /sys/kernel/btf:/sys/kernel/btf \
	-v /sys/fs/cgroup:/sys/fs/cgroup \
	-v /sys/fs/bpf:/sys/fs/bpf \
		localhost/fcos-debug-container:34.20210529.2.0
```
