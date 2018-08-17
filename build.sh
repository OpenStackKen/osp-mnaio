#!/usr/bin/env bash
# Copyright [2016] [Kevin Carter]
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euvo

source bootstrap.sh

source ansible-env.rc

ansible mnaio_hosts \
        -i ${MNAIO_INVENTORY:-"playbooks/inventory"} \
        -m pip \
        -a "name=netaddr" \
        -a "name=ara"

export MNAIO_ANSIBLE_PARAMETERS=${MNAIO_ANSIBLE_PARAMETERS:-""}

ansible-playbook -vv \
                 -i ${MNAIO_INVENTORY:-"playbooks/inventory"} \
                 -e setup_host=${SETUP_HOST:-"true"} \
                 -e setup_pxeboot=${SETUP_PXEBOOT:-"true"} \
                 -e setup_dhcpd=${SETUP_DHCPD:-"true"} \
                 -e deploy_vms=${DEPLOY_VMS:-"true"} \
                 -e default_network=${DEFAULT_NETWORK:-"eth0"} \
                 -e default_image=${DEFAULT_IMAGE:-"rhel-7.5-amd64"} \
                 -e vm_disk_size=${VM_DISK_SIZE:-92160} \
                 -e http_proxy=${http_proxy:-''} \
                 -e pre_config_osa=${PRE_CONFIG_OSA:-"true"} \
                 -e configure_openstack=${CONFIGURE_OPENSTACK:-"true"} \
                 -e config_prerouting=${CONFIG_PREROUTING:-"true"} \
                 -e default_ubuntu_kernel=${DEFAULT_KERNEL:-"linux-image-generic"} \
                 -e cinder_vm_server_ram=${CINDER_VM_SERVER_RAM:-"2048"} \
                 -e compute_vm_server_ram=${COMPUTE_VM_SERVER_RAM:-"8196"} \
                 -e infra_vm_server_ram=${INFRA_VM_SERVER_RAM:-"8196"} \
                 -e loadbalancer_vm_server_ram=${LOADBALANCER_VM_SERVER_RAM:-"2048"} \
                 -e logging_vm_server_ram=${LOGGING_VM_SERVER_RAM:-"2048"} \
                 -e swift_vm_server_ram=${SWIFT_VM_SERVER_RAM:-"2048"} \
                 -e container_tech=${CONTAINER_TECH:-"lxc"} \
                 -e ipxe_kernel_url=${IPXE_KERNEL_URL:-"http://boot.ipxe.org/ipxe.lkrn"} \
                 -e redhat_iso_url=${REDHAT_ISO_URL:-""} \
                 -e redhat_base_url=${REDHAT_BASE_URL:-"http://192.168.24.254/distros/redhat/7.5/"} \
                 -e redhat_username=${REDHAT_USERNAME:-""} \
		 -e redhat_password=${REDHAT_PASSWORD:-""} \
		 -e redhat_consumer_name=${REDHAT_CONSUMER_NAME:-""} \
		 -e redhat_pool_id=${REDHAT_POOL_ID:-""} \
		 -e redhat_osp_version=${REDHAT_OSP_VERSION:-"13"} \
                 -e ipxe_path_url=${IPXE_PATH_URL:-""} ${MNAIO_ANSIBLE_PARAMETERS} \
                 --force-handlers \
                 --flush-cache \
                 playbooks/site.yml
