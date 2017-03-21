import unittest
import flexmock
import os.path
import json

from library import generate_ssh_key


class TestGenerateSshKeyCustomModule(unittest.TestCase):
    def setUp(self):
        self.data = {'home_dir': '/home/test'}
        flexmock(generate_ssh_key)
        generate_ssh_key.should_receive("_generate_public_key").and_return(0)
        generate_ssh_key.should_receive("_generate_private_key").and_return(0)

    def test_home_dir_does_not_exist(self):
        flexmock(os.path)
        os.path.should_receive('exists').with_args(self.data['home_dir']).and_return(False)
        is_error, has_changed, result = generate_ssh_key.generate_ssh_key(self.data)
        self.assertEqual(is_error, True)
        self.assertEqual(has_changed, False)
        self.assertEqual(
            result,
            json.dumps("Home dir {} does not exist".format(self.data['home_dir']))
        )

    def test_ssh_dir_does_not_exist(self):
        flexmock(os.path)
        os.path.should_receive('exists').with_args(self.data['home_dir']).and_return(True)
        os.path.should_receive('exists').with_args(self.data['home_dir'] + "/.ssh/").and_return(False)
        flexmock(os).should_receive('system').with_args(
            'mkdir -p {}'.format(self.data['home_dir'] + "/.ssh/")).and_return(0).once()
        os.path.should_receive('exists').with_args(self.data['home_dir'] + "/.ssh/id_rsa").and_return(False)
        is_error, has_changed, result = generate_ssh_key.generate_ssh_key(self.data)
        self.assertEqual(is_error, False)
        self.assertEqual(has_changed, True)
        self.assertEqual(result, json.dumps("Private key and public key generated successfully."))

    def test_ssh_dir_and_private_key_exist_but_public_key_does_not(self):
        flexmock(os.path)
        os.path.should_receive('exists').with_args(self.data['home_dir']).and_return(True)
        os.path.should_receive('exists').with_args(self.data['home_dir'] + "/.ssh/").and_return(True)
        os.path.should_receive('exists').with_args(self.data['home_dir'] + "/.ssh/id_rsa").and_return(True)
        os.path.should_receive('exists').with_args(self.data['home_dir'] + "/.ssh/id_rsa.pub").and_return(False)
        is_error, has_changed, result = generate_ssh_key.generate_ssh_key(self.data)
        self.assertEqual(is_error, False)
        self.assertEqual(has_changed, True)
        self.assertEqual(result, json.dumps(
            "Private key already exists, but public key does not. Public key generated successfully."))

    def test_ssh_dir_exists_but_private_key_does_not(self):
        flexmock(os.path)
        os.path.should_receive('exists').with_args(self.data['home_dir']).and_return(True)
        os.path.should_receive('exists').with_args(self.data['home_dir'] + "/.ssh/").and_return(True)
        os.path.should_receive('exists').with_args(self.data['home_dir'] + "/.ssh/id_rsa").and_return(False)
        os.path.should_receive('exists').with_args(self.data['home_dir'] + "/.ssh/id_rsa.pub").and_return(True)
        is_error, has_changed, result = generate_ssh_key.generate_ssh_key(self.data)
        self.assertEqual(is_error, False)
        self.assertEqual(has_changed, True)
        self.assertEqual(result, json.dumps("Private key and public key generated successfully."))

    def test_everything_exist(self):
        flexmock(os.path)
        os.path.should_receive('exists').with_args(self.data['home_dir']).and_return(True)
        os.path.should_receive('exists').with_args(self.data['home_dir'] + "/.ssh/").and_return(True)
        os.path.should_receive('exists').with_args(self.data['home_dir'] + "/.ssh/id_rsa").and_return(True)
        os.path.should_receive('exists').with_args(self.data['home_dir'] + "/.ssh/id_rsa.pub").and_return(True)
        is_error, has_changed, result = generate_ssh_key.generate_ssh_key(self.data)
        self.assertEqual(is_error, False)
        self.assertEqual(has_changed, False)
        self.assertEqual(result, json.dumps("Private key and public key already exist."))


if __name__ == '__main__':
    unittest.main()
