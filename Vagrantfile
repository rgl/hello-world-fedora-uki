BUILDER_VM_CPUS         = 4
BUILDER_VM_MEMORY_MB    = 4*1024
BUILDER_VM_DISK_SIZE_GB = 64

Vagrant.configure("2") do |config|
  config.vm.provider "libvirt" do |lv, config|
    lv.cpu_mode = "host-passthrough"
    lv.nested = true
    lv.keymap = "pt"
  end

  config.vm.define :builder do |config|
    config.vm.box = "fedora-44-uefi-amd64"
    config.vm.hostname = "builder"
    config.vm.provider "libvirt" do |lv, config|
      lv.cpus = BUILDER_VM_CPUS
      lv.memory = BUILDER_VM_MEMORY_MB
      lv.machine_virtual_size = BUILDER_VM_DISK_SIZE_GB
      config.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_version: "4.2", nfs_udp: false
    end
    config.vm.provision "shell", path: "provision-base.sh"
    config.vm.provision "shell", path: "provision-build.sh"
    config.vm.provision "shell", path: "build.sh"
  end
end
