# SAP HANA Cockpit installation and configuration using Terraform and Ansible

Terraform module and ansible roles to deploy the SAP HANA Cockpit stack. This stack deploys a standalone HANA Cockpit instance in a seperate VM. HANA Cockpit config is performed by a higher ansible role `ansible/roles/sap-hana-cockpit` that in turn calls lower ansible roles to do a specific task.

# Deployment Architecture

### <img src="images/scaleup.png" width="500px">

# Requirements

* Terraform version `>=0.12`
* Ansible version `>= 2.9.2`

# Usage

1. Terraform code for deploying the infrastructure required for installing and configuring SAP HANA Cockpit is stored under `tf/`.

2. Ansible roles for configuring HANA Cockpit on the GCE instances is stored in the repository under `ansible/roles`.

3. Ansible playbook to deploy the HANA cockpit is `playbook.yml`.

# Variables

* All the ansible SAP HANA scaleup configuration default values are defined in the higher level ansible role under `ansible/roles/sap-hana-cockpit/defaults/main.yml`.

* All the variables required for deploying stack are defined in the `vars/deploy-vars.yml` file.

`sap_zone` (required): GCP zone to deploy the sap instances 

`sap_project_id` (required): GCP project-id to deploy the resources

`sap_source_image_family` (required): GCE instances image family

`sap_source_image_project` (required): GCE instances image family project

`sap_subnetwork_project_id` (required): GCP project-id hosting the subnetwork. When using `shared_vpc` provide the host project-id of the subnetwork.

`sap_hana_subnetwork` (required): GCP subnetwork name

`sap_tf_state_bucket` (required): Terraform state bucket name storing the tf state file

`sap_tf_state_bucket_prefix` (required): Terraform state bucket prefix for storing tf state file

`sap_hana_instance_name` (required): GCE instance name

`sap_hana_service_account_name` (required): GCP service account name

`sap_hana_instance_type`: GCE instance type (choose from the below)
```hcl
n1-highmem-32
n1-highmem-64
n1-highmem-96
n2-highmem-32
n2-highmem-48
n2-highmem-64
n2-highmem-80
m1-megamem-96
m1-ultramem-40
m1-ultramem-80
m1-ultramem-160
m2-ultramem-208
m2-ultramem-416
```
`sap_hana_autodelete_boot_disk`: Delete boot disk along with the instance

`sap_hana_boot_disk_size`: GCE instance boto disk size

`sap_hana_boot_disk_type`: GCE instance boot disk type

`sap_hana_additional_disk_type`: GCE additional data disks type

`sap_hana_network_tags`: List of network tags to add to the instances

`sap_hana_pd_kms_key`: Customer managed encryption key to use in persistent disks 

`sap_hana_create_backup_volume`: Provision HANA DB backup disk and attach to instance

`sap_hana_backint_install`: Install SAP HANA backint on the HANA nodes

`sap_hana_fast_restart`: Configure SAP HANA fast restart (Note: Only set this variable to `true` when installing HANA 2.0 and above)

`sap_hana_password`: Common password to use for all HANA user and system authentication

`sap_hana_preinstall_tasks`: Path to an Ansible task file that will run before HANA is installed. This can be an absolute path, or a relative path which is relative to the playbook directory.

`sap_hana_postinstall_tasks`: Path to an Ansible task file that will run after HANA is installed. This can be an absolute path, or a relative path which is relative to the playbook directory.

# Example playbook to deploy SAP HANA Cockpit stack

Below is the example playbook to deploy the HANA cockpit stack. Replace the variable values to fit your need

```yaml
- name: SAP HANA deploy
  hosts: 127.0.0.1
  connection: local
  roles:
  - role: forminator
    vars:
      sap_tf_project_path: ./tf
      sap_state: "present"
      sap_hana_backint_install: true
      sap_hana_backint_bucket_name: "sap-hana-backint-backup"
      sap_tf_variables:
        instance_name: hanaslbg
        project_id: gcp-project-id
        source_image_family: source-image-family
        source_image_project: source-image-project
        subnetwork: subnetwork-name
        service_account_email: "sap-common-sa"
        subnetwork_project: '{{ sap_project_id }}'
        zone: "us-central1-a"
        instance_type: "n1-highmem-32"
        autodelete_disk: true
        boot_disk_size: 30
        boot_disk_type: "pd-ssd"
        network_tags: ["sap-allow-all"]
        pd_kms_key: None
        create_backup_volume: true

- name: SAP HANA Cockpit
  hosts: hana
  become: yes
  vars:
    sap_hana_backint_install: true
    sap_hana_backint_bucket_name: "sap-hana-backint-backup"
    sap_hana_shared_size: '{{ terraform.outputs.hana_shared_size.value }}G'
    sap_hana_data_size: '{{ terraform.outputs.hana_data_size.value }}G'
    sap_hana_log_size: '{{ terraform.outputs.hana_log_size.value }}G'
    sap_hana_usr_size: '{{ terraform.outputs.hana_usr_size.value }}G'
    sap_hana_backup_size: '{{ terraform.outputs.hana_backup_size.value - 1 }}G'
  roles:
  - role: sap-hana-cockpit
```

# Deploy standalone HANA cockpit 

* Use the `ansible-wrapper` script at the root of the repository to deploy the stack. The ansible wrapper script will setup the environment along with installing the correct ansible version and dependencies required for running the code.

`./ansible-wrapper ./stacks/HANA-Cockpit/playbook.yml --extra-vars '@./stacks/HANA-Cockpit/vars/deploy-vars.yml'`

# Destroy standalone HANA Cockpit

* Use the `ansible-wrapper` script at the root of the repository to destroy the stack.

`./ansible-wrapper ./stacks/HANA-Cockpit/playbook.yml -e state=absent --extra-vars '@./stacks/HANA-Cockpit/vars/deploy-vars.yml'`

# Author Information

Vasudevan E.R vasudevaner@google.com
