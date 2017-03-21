#!/usr/bin/python

DOCUMENTATION = '''
---
module: generate_ssh_key
short_description: Generate ssh private key and public key. If key already exists it won't regenerate.
'''

EXAMPLES = '''
- name: Generate public and private key
  generate_ssh_key:
    home_dir: "/home/tiexin/test"
  register: result
'''

import os.path
import json
from ansible.module_utils.basic import *


def _generate_public_key(private_key, public_key):
    rc = os.system("openssl rsa -in {private_key} -pubout -out {public_key}".format(private_key=private_key,
                                                                                    public_key=public_key))
    return rc


def _generate_private_key(private_key):
    rc = os.system("openssl genrsa -out {private_key} 2048".format(private_key=private_key))
    return rc


def generate_ssh_key(data):
    home_dir = data['home_dir']
    if not os.path.exists(home_dir):
        return True, False, json.dumps("Home dir {} does not exist".format(home_dir))

    ssh_dir = home_dir + "/.ssh/"

    if not os.path.exists(ssh_dir):
        rc = os.system("mkdir -p {}".format(ssh_dir))
        if rc != 0:
            return True, False, json.dumps("Create .ssh dir {} failed!".format(ssh_dir))

    private_key = ssh_dir + "id_rsa"
    public_key = ssh_dir + "id_rsa.pub"

    if os.path.exists(private_key) and os.path.exists(public_key):
        return False, False, json.dumps("Private key and public key already exist.")

    if os.path.exists(private_key) and not os.path.exists(public_key):
        rc = _generate_public_key(private_key=private_key, public_key=public_key)
        if rc == 0:
            return False, True, json.dumps(
                "Private key already exists, but public key does not. Public key generated successfully.")
        else:
            return True, False, json.dumps(
                "Private key already exists, but public key does not. Public key generation failed!")

    if not os.path.exists(private_key):
        rc = _generate_private_key(private_key=private_key)
        if rc != 0:
            return True, False, json.dumps("Private key generation failed!")
        rc = _generate_public_key(private_key=private_key, public_key=public_key)
        if rc == 0:
            return False, True, json.dumps("Private key and public key generated successfully.")
        else:
            return True, False, json.dumps(
                "Private key generated successfully, but public key generation failed!")


def main():
    fields = {
        "home_dir": {"required": True, "type": "str"},
    }

    module = AnsibleModule(argument_spec=fields)
    is_error, has_changed, result = generate_ssh_key(module.params)

    if not is_error:
        module.exit_json(changed=has_changed, meta=result)
    else:
        module.fail_json(msg="Error generating ssh key!", meta=result)


if __name__ == '__main__':
    main()
