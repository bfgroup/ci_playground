# Use, modification, and distribution are
# subject to the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#
# Copyright Rene Rivera 2020.

# Configuration for https://cloud.drone.io/.

def main(ctx):
  return [
    linux_cxx("GCC 9", "/usr/bin/g++9", packages="g++-9"),
    linux_cxx("GCC 8", "/usr/bin/g++8", packages="g++-8"),
  ]

# Generate pipeline for Linux platform compilers.
def linux_cxx(name, cxx, cxxflags="", packages="", llvm_repo="", arch="amd64", image="ubuntu:18.04"):
  return {
    "name": "Linux %s" % name,
    "kind": "pipeline",
    "type": "docker",
    "trigger": { "branch": [ "master" ] },
    "platform": {
      "os": "linux",
      "arch": arch
    },
    # Create env vars per generation arguments.
    "environment": {
      "CXX": cxx,
      "CXXFLAGS": cxxflags,
      "PACKAGES": packages,
      "LLVM_REPO": llvm_repo
    },
    "steps": [
      # Two simple steps.. The install runs a helper script to do the install
      # and any setup.
      # And the compiler step just calls the compiler.
      {
        "name": "Fubar",
        "image": image,
        "commands": [
          "uname -a",
          "id",
          "echo PATH=$${PATH}",
          "apt-get update && apt-get install -y sudo software-properties-common && rm -rf /var/lib/apt/lists/*",
          "./.ci_playground/linux-cxx-install.sh"
          "$${CXX} --version",
          "$${CXX} $${CXXFLAGS} -v src/main.cpp"
        ]
      }
    ]
  }