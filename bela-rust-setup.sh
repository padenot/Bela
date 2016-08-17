#!/bin/sh

if [ $DEBUG ]
then
  set -x
fi

set -e

# Colors
RESET='\033[0m'
RED='\033[1;31m'
GREEN='\033[1;32m'

remote() {
  ssh root@$BELA $1
}

copyhome() {
  scp $1 root@$BELA:~
  if [ $? -ne 0 ]
  then
    abort "Could not copy $1 to the bela board."
  fi
  success "Copied $1 to the bela board, at ~/$1."
}

abort() {
  echo "$RED$1$RESET"
  exit 1
}

success() {
  echo "$GREEN$1$RESET"
}

BELA=192.168.7.2
RUST=rust-nightly-arm-unknown-linux-gnueabihf.tar.gz

if [ ! -f $RUST ]
then
  echo "Downloading Rust nightly..."
  wget https://static.rust-lang.org/dist/"$RUST".tar.gz
  if [ $? -ne 0 ]
  then
    abort "Error downloading rust nightly, aborting"
  fi
  success "Done."
else
  success "Rust nightly already here, skipping download. Remove $RUST to update."
fi

echo "Checking if bela plugged in and reachable"

ping -c 1 127.0.0.1 > /dev/null
if [ $? -ne 0 ]
then
  abort "Plug in a bela board and retry."
fi

success "Bela up and reachable"

echo "Checking if there is already a rust tarball on the bela board."
local_rust=`sha1sum $RUST | tr -s ' ' | cut -d ' ' -f1`
remote_rust=`ssh root@bela  "sha1sum ~/rust*.tar.gz | tr -s ' ' | cut -d ' ' -f1"`

if [ $local_rust = $remote_rust ]
then
  success "Up to date rust version on the bela board, skipping copying."
else
  echo "Copying rust tarball to the bela board..."
  copyhome $RUST.tar.gz
fi

echo "Checking if the rust tarball has been extracted..."
remote "ls ~/$RUST"
if [ $? -ne 0 ]
then
  echo "Extracting the rust tarball..."
  remote "tar -xf '$RUST'.tar.gx"
  if [ $? -ne 0 ]
  then
    abort "Could not extract the rust tarball."
  fi
  success "Rust tarball extracted successfuly."
else
  success "Rust tarball already extracted."
fi

echo "Checking if rust is already installed on the bela board"
remote "which rustc"
if [ $? -ne 0 ]
then
  remote "cd $RUST && ./install.sh"
  if [ $? -ne 0 ]
  then
    abort "Could not install rust nightly on the bela board."
  fi
  success "Rust installed on the bela board."
else
  success "Rust is already installed."
fi

echo "Compiling an hello world program..."
echo "fn main() { println!(\"Hello from a rust on a bela board !\") }" > hello.rs
copyhome hello.rs
remote "rustc ~/hello.rs"
if [ $? -ne 0 ]
then
  abort "Could not compile a simple rust program on the bela board."
fi
success "Compilation sucessful."

echo "Running the program on the bela board..."
remote "~/hello"
if [ $? -ne 0 ]
then
  abort "Could not run the program on the bela board."
fi
success "Program ran successfuly."

# copy headers from bela
# llvm version
# rust bindgen
