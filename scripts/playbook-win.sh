#!/bin/bash
# Source: https://github.com/geerlingguy/JJG-Ansible-Windows/blob/master/windows.sh

# Windows shell provisioner for Ansible playbooks, based on KSid's
# windows-vagrant-ansible: https://github.com/KSid/windows-vagrant-ansible
#
# @todo - Allow proxy configuration to be passed in via Vagrantfile config.
#
# @see README.md
# @author Jeff Geerling, 2014
# @version 1.0
#

playbook=/vagrant/ansible/site.yml
inventory=/vagrant/scripts/inventory.py

if [ ! -f ${playbook} ]; then
  echo "Cannot find Ansible playbook."
  exit 1
fi

if [ ! -f ${inventory} ]; then
  echo "Cannot find inventory file."
  exit 2
fi

# Install Ansible and its dependencies if it's not installed already.
if [ ! -f /usr/bin/ansible ]; then
  echo "Installing Ansible dependencies and build tools."
  yum install -y gcc git python-devel libffi-devel openssl-devel
  echo "Installing pip via easy_install."
  easy_install pip
  # Make sure setuptools are installed crrectly.
  pip install setuptools --no-binary :all: --upgrade
  echo "Installing Ansible."
  pip install ansible
  echo "Ansible installed:"
  ansible --version
fi

ansible-playbook "${playbook}" \
  --inventory-file="${inventory}" \
  --limit="${HOSTNAME}" \
  --extra-vars "is_windows=true" \
  --connection=local \
  "$@"
