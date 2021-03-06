# Use, modification, and distribution are
# subject to the Boost Software License, Version 1.0. (See accompanying
# file LICENSE.txt)
#
# Copyright René Ferdinand Rivera Morell 2020-2021.

# Configuration for https://cloud.drone.io/.

# For Drone CI we use the Starlark scripting language to reduce duplication.
# As the yaml syntax for Drone CI is rather limited.

def main(ctx):
  return [
    # All the GCC's and Clang's available for our default of Ubuntu Bionic.
    linux_cxx("GCC 10", "g++-10", packages="g++-10"),
    linux_cxx("GCC 9", "g++-9", packages="g++-9"),
    linux_cxx("GCC 8", "g++-8", packages="g++-8"),
    linux_cxx("GCC 7", "g++-7", packages="g++-7"),
    linux_cxx("GCC 6", "g++-6", packages="g++-6"),
    linux_cxx("GCC 5", "g++-5", packages="g++-5"),
    linux_cxx("Clang 10", "clang++-10", packages="clang-10", llvm_os="bionic", llvm_ver="10"),
    linux_cxx("Clang 9", "clang++-9", packages="clang-9", llvm_os="bionic", llvm_ver="9"),
    linux_cxx("Clang 8", "clang++-8", packages="clang-8", llvm_os="bionic", llvm_ver="8"),
    linux_cxx("Clang 7", "clang++-7", packages="clang-7", llvm_os="bionic", llvm_ver="7"),
    linux_cxx("Clang 6.0", "clang++-6.0", packages="clang-6.0", llvm_os="bionic", llvm_ver="6.0"),
    linux_cxx("Clang 5.0", "clang++-5.0", packages="clang-5.0", llvm_os="bionic", llvm_ver="5.0")
  ]

# Generate pipeline for Linux platform compilers.
def linux_cxx(name, cxx, cxxflags="", packages="", llvm_os="", llvm_ver="", arch="amd64", image="ubuntu:18.04"):
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
      "LLVM_OS": llvm_os,
      "LLVM_VER": llvm_ver
    },
    "steps": [
      {
        "name": "Everything",
        "image": image,
        "commands": [
          # Need some extra container setup.
          "echo '==================================> SETUP'",
          "apt-get -o Acquire::Retries=3 update && apt-get -o Acquire::Retries=3 install -y sudo software-properties-common wget apt-transport-https && rm -rf /var/lib/apt/lists/*",
          # The install runs a helper script to do the install and any setup.
          "echo '==================================> INSTALL TOOLSET'",
          "uname -a",
          "./.ci_playground/linux-cxx-install.sh",
          # And the compiler step just calls the compiler.
          "echo '==================================> COMPILE'",
          "$${CXX} --version",
          "$${CXX} $${CXXFLAGS} -v src/main.cpp"
        ]
      }
    ]
  }
