# Test-driven infrastructure

with ansible, docker, test-kitchen, and serverspec
 
# Dependencies

Ansible (of course)

Ruby (rvm recommended https://rvm.io/)

Docker/Vagrant (in this example docker is used since docker is faster)

# How to run

```
gem install bundler
bundle
```

which will install every dependencies listed in the `Gemfile`.

If you want to know more about it: http://bundler.io/

```
kitchen create

kitchen converge

kitchen setup

kitchen verify

kitchen destroy
```

Test kitchen will create a docker, converge it to the status described in your ansible playbook, run some serverspec test cases, and destroy it at the end.
