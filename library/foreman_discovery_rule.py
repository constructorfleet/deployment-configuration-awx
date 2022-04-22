#!/usr/bin/python
# -*- coding: utf-8 -*-
# (c) 20022, Teagan Glenn <that@teagantotally.rocks>

from __future__ import absolute_import, division, print_function
__metaclass__ = type


DOCUMENTATION = '''
---
module: foreman_discovery_rule
version_added: 1.0.0
short_description: Create, update, remove discovery rules from Foreman server
description:
  - Manage Foreman Discovery Rules
author:
  - "Teagan Glenn (@Teagan42)"
options:
  name:
    description:
      - Name of the discovery rule
    required: true
    type: str
  updated_name:
    description:
      - Name to set when modifying existing discovery rule
    type: str
  search:
    description:
      - Query to match discovered hosts for this rule
    required: true
    type: str
  hostgroup:
    description:
      - The hostgroup to assign to discovered hosts
    type: str
    required: true
  priority:
    description:
      - Puts rules in order
      - Lower values go first
    type: int
  enabled:
    description:
      - Flag whether this rule is enabled
    type: bool
    default: true
  hostname:
    description:
      - Defines a pattern to assign human-readable hostnames to the matching hosts
    type: str
  max_count:
    description:
      - Enables to limit maximum amount of provisioned hosts per rule
    type: int
extends_documentation_fragment:
  - theforeman.foreman.foreman
  - theforeman.foreman.foreman.entity_state
  - theforeman.foreman.foreman.taxonomy
'''

EXAMPLES = '''
- name: "Assign Hypervisor Group Rule"
  foreman_discovery_rule:
    username: "admin"
    password: "changeme"
    server_url: "https://foreman.example.com"
    name: Hypervisors
    hostgroup: hypervisor
    search: facts.ansible_virtualization_role = host

- name: "Update Old Rule Name"
  foreman_discovery_rule:
    username: "admin"
    password: "changeme"
    server_url: "https://foreman.example.com"
    name: Defunct
    updated_name: My Rule
    hostgroup: group1
    search: facts.ansible_virtualization_role = host
    
- name: "Delete Obsolete Rule"
  foreman_discovery_rule:
    username: "admin"
    password: "changeme"
    server_url: "https://foreman.example.com"
    name: RemoveMe
    state: absent
    hostgroup: group1
    search: facts.ansible_virtualization_role = host
'''

RETURN = '''
entity:
  description: Discovery rule entity
  returned: success
  type: dict
'''

from ansible_collections.theforeman.foreman.plugins.module_utils.foreman_helper import ForemanTaxonomicEntityAnsibleModule


LOOKUP_RESOURCES = [
    {
        'param': 'organizations',
        'resource': 'organizations',
        'result': 'organization_ids',
    },
    {
        'param': 'locations',
        'resource': 'locations',
        'result': 'location_ids',
    },
    {
        'param': 'hostgroup',
        'resource': 'hostgroups',
        'result': 'hostgroup_id',
    }
]


class ForemanDiscoveryRuleModule(ForemanTaxonomicEntityAnsibleModule):
    pass


def main():
    module = ForemanDiscoveryRuleModule(
        argument_spec=dict(
            updated_name=dict(),
        ),
        foreman_spec=dict(
            name=dict(required=True),
            search=dict(required=True),
            hostgroup=dict(type='entity', required=True, ensure=True),
            locations=dict(type='entity_list', required=True, ensure=True),
            organizations=dict(type='entity_list', required=True, ensure=True),
            priority=dict(),
            enabled=dict(type=bool, required=False, default=True),
            hostname=dict(),
            max_count=dict(),
        ),
        required_plugins=[('discovery', ['discovery_rules'])],
    )

    module_params = module.foreman_params

    with module.api_connection():
        for resource in LOOKUP_RESOURCES:
            if resource['param'] not in module_params:
                msg = "Missing required argument '{0}'".format(resource['param'])
                module.fail_json(msg=msg)

            if resource['resource'] not in module.foremanapi.resources:
                msg = "Resource '{0}' does not exist in the API. Existing resources: {1}".format(
                    resource['resource'],
                    ', '.join(sorted(module.foremanapi.resources))
                )
                module.fail_json(msg=msg)
            resource_name = module_params.pop(resource['param'])
            if isinstance(resource_name, list):
                module_params[resource['result']] = [
                    item['id']
                    for item
                    in module.find_resources_by_name(
                        resource['resource'],
                        resource_name,
                        thin=True
                    )
                ]
            else:
                module_params[resource['result']] = module.find_resource_by_name(
                    resource['resource'],
                    resource_name,
                    thin=True
                )['id']

        entity = module.run()

        module.exit_json(entity=entity)


if __name__ == '__main__':
    main()
