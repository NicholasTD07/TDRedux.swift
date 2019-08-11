with (import <nixpkgs> {});

let
  version = "1.0.0";
  name = "TDRedux.swift-v"+version;
  gems = bundlerEnv {
    name = name;
    inherit ruby;
    gemdir = ./.;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
  xcode-version = "10.3";
  xcode-base-dir = "/Applications/Xcode.app";
in stdenv.mkDerivation {
  name = name;
  buildInputs = [
    fish
    which

    # ruby
    ruby
    gems
    bundler
    bundix
  ];

  shellHook = ''
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8

    export PATH=$out/bin:$PATH
    export LD=$CC

    rm -rf $out/bin
    mkdir -p $out/bin

    cd $out/bin

    ln -s /usr/bin/xcode-select
    ln -s /usr/bin/security
    ln -s /usr/bin/codesign
    ln -s /usr/bin/xcrun
    ln -s /usr/bin/plutil
    ln -s /usr/bin/clang
    ln -s /usr/bin/lipo
    ln -s /usr/bin/file
    ln -s /usr/bin/rev
    ln -s "${xcode-base-dir}"
    ln -s "${xcode-base-dir}/Contents/Developer/usr/bin/xcodebuild"
    ln -s "${xcode-base-dir}/Contents/Developer/Applications/Simulator.app/Contents/MacOS/Simulator"
    ln -s "${xcode-base-dir}/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs"

    cd -

    # Check if we have the xcodebuild version that we want
    if [ -z "$($out/bin/xcodebuild -version | grep -x 'Xcode ${xcode-version}')" ]
    then
        echo "We require xcodebuild version: ${xcode-version}"
        echo
        echo "Have you installed Xcode yet?"
        echo
        exit 1
    fi
  '';
}
