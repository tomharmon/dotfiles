{ pkgs }:
let
  crate =
    {
      pname,
      version,
      hash,
      nativeBuildInputs ? [ ],
      buildInputs ? [ ],
    }:
    pkgs.rustPlatform.buildRustPackage rec {
      inherit pname version nativeBuildInputs buildInputs;
      src = pkgs.fetchCrate { inherit pname version hash; };
      cargoLock.lockFile = "${src}/Cargo.lock";
      doCheck = false;
    };
in
{
  cocomo = crate {
    pname = "cocomo";
    version = "0.11.5";
    hash = "sha256-3jsW7f6hz30ZcbqI2VLHsnxzMmh4CU3Ax7ASv6YAM0I=";
  };

  paperclip = crate {
    pname = "paperclip";
    version = "0.9.7";
    hash = "sha256-QfAIsBZTzq0PWbl/igdpz6lyjIfIao7MBeVEYnjmISY=";
  };

  zeitgrep = crate {
    pname = "zeitgrep";
    version = "0.8.0";
    hash = "sha256-a6B6a4bdEnDOdSHbRKTDnmBsOiLlwsdm9oBDHWieQOc=";
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.openssl ];
  };

  libninja = pkgs.rustPlatform.buildRustPackage rec {
    pname = "libninja";
    version = "0.2.0";
    src = pkgs.fetchFromGitHub {
      owner = "kurtbuilds";
      repo = "libninja";
      rev = "6e9470196fb733115aa49ab00e5eebe2181d738c";
      hash = "sha256-OSpDemdNj3bhj+v5YWS4AgwySUZV9NxCVH6Ap3W3JhY=";
    };
    cargoLock.lockFile = "${src}/Cargo.lock";
    cargoBuildFlags = [ "-p" "libninja" ];
    doCheck = false;
  };

  rusty-script = pkgs.rustPlatform.buildRustPackage rec {
    pname = "rusty-script";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "tomharmon";
      repo = "rusty-script";
      rev = "64ced31a75ef4cc8425dd9d9e3fb9c1c45f913c5";
      hash = "sha256-/cYHYsjf5o3U9MNr9mtYO0teNgiayLUBgom0sXka2Ks=";
    };
    cargoLock.lockFile = "${src}/Cargo.lock";
    cargoBuildFlags = [ "-p" "rusty-script" ];
    doCheck = false;
  };
}
