{
  description = "UnveilingPartner's PythonEDA realm";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    pythoneda-artifact-event-changes = {
      url = "github:pythoneda-artifact-event/changes/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
      inputs.pythoneda-artifact-shared-changes.follows =
        "pythoneda-artifact-shared-changes";
    };
    pythoneda-artifact-event-git-tagging = {
      url = "github:pythoneda-artifact-event/git-tagging/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
    pythoneda-artifact-shared-changes = {
      url = "github:pythoneda-artifact-shared/changes/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
    pythoneda-base = {
      url = "github:pythoneda/base/0.0.1a16";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        pname = "pythoneda-artifact-event-changes";
        description = "UnveilingPartner's PythonEDA realm";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/pythoneda-realm/unveilingpartner";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./nix/shared.nix;
        pythonpackage = "pythonedarealmunveilingpartner";
        pythoneda-realm-unveilingpartner-for = { python
          , pythoneda-artifact-event-changes
          , pythoneda-artifact-event-git-tagging
          , pythoneda-artifact-shared-changes, pythoneda-base, version }:
          let
            pname = "pythoneda-realm-unveilingpartner";
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            src = ./.;
            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip pkgs.jq poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              pythoneda-artifact-event-changes
              pythoneda-artifact-event-git-tagging
              pythoneda-artifact-shared-changes
              pythoneda-base
              unidiff
            ];

            checkInputs = with python.pkgs; [ pytest ];

            pythonImportsCheck = [ pythonpackage ];

            preBuild = ''
              python -m venv .env
              source .env/bin/activate
              pip install ${pythoneda-base}/dist/pythoneda_base-${pythoneda-base.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-event-changes}/dist/pythoneda_artifact_event_changes-${pythoneda-artifact-event-changes.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-event-git-tagging}/dist/pythoneda_artifact_event_git_tagging-${pythoneda-artifact-event-git-tagging.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-shared-changes}/dist/pythoneda_artifact_shared_changes-${pythoneda-artifact-shared-changes.version}-py3-none-any.whl
              rm -rf .env
            '';

            postInstall = ''
              mkdir $out/dist
              cp dist/${wheelName} $out/dist
              jq ".url = \"$out/dist/${wheelName}\"" $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json > temp.json && mv temp.json $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json
            '';

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
        pythoneda-realm-unveilingpartner-0_0_1a3-for = { python
          , pythoneda-artifact-event-changes, pythoneda-artifact-shared-changes
          , pythoneda-artifact-event-git-tagging, pythoneda-base }:
          pythoneda-realm-unveilingpartner-for {
            inherit python pythoneda-artifact-event-changes
              pythoneda-artifact-event-git-tagging
              pythoneda-artifact-shared-changes pythoneda-base;
            version = "0.0.1a3";
          };
      in rec {
        defaultPackage = packages.default;
        packages = rec {
          default = pythoneda-realm-unveilingpartner-latest;
          pythoneda-realm-unveilingpartner-0_0_1a3-python39 =
            pythoneda-realm-unveilingpartner-0_0_1a3-for {
              python = pkgs.python39;
              pythoneda-artifact-event-changes =
                pythoneda-artifact-event-changes.packages.${system}.pythoneda-artifact-event-changes-latest-python39;
              pythoneda-artifact-event-git-tagging =
                pythoneda-artifact-event-git-tagging.packages.${system}.pythoneda-artifact-event-git-tagging-latest-python39;
              pythoneda-artifact-shared-changes =
                pythoneda-artifact-shared-changes.packages.${system}.pythoneda-artifact-shared-changes-latest-python39;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python39;
            };
          pythoneda-realm-unveilingpartner-0_0_1a3-python310 =
            pythoneda-realm-unveilingpartner-0_0_1a3-for {
              python = pkgs.python310;
              pythoneda-artifact-event-changes =
                pythoneda-artifact-event-changes.packages.${system}.pythoneda-artifact-event-changes-latest-python310;
              pythoneda-artifact-event-git-tagging =
                pythoneda-artifact-event-git-tagging.packages.${system}.pythoneda-artifact-event-git-tagging-latest-python310;
              pythoneda-artifact-shared-changes =
                pythoneda-artifact-shared-changes.packages.${system}.pythoneda-artifact-shared-changes-latest-python310;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python310;
            };
          pythoneda-realm-unveilingpartner-latest-python39 =
            pythoneda-realm-unveilingpartner-0_0_1a3-python39;
          pythoneda-realm-unveilingpartner-latest-python310 =
            pythoneda-realm-unveilingpartner-0_0_1a3-python310;
          pythoneda-realm-unveilingpartner-latest =
            pythoneda-realm-unveilingpartner-latest-python310;
        };
        devShells = rec {
          default = pythoneda-realm-unveilingpartner-latest;
          pythoneda-realm-unveilingpartner-0_0_1a3-python39 =
            shared.devShell-for {
              package =
                packages.pythoneda-realm-unveilingpartner-0_0_1a3-python39;
              python = pkgs.python39;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python39;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-realm-unveilingpartner-0_0_1a3-python310 =
            shared.devShell-for {
              package =
                packages.pythoneda-realm-unveilingpartner-0_0_1a3-python310;
              python = pkgs.python310;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python310;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-realm-unveilingpartner-latest =
            pythoneda-realm-unveilingpartner-latest-python310;
          pythoneda-realm-unveilingpartner-latest-python39 =
            pythoneda-realm-unveilingpartner-0_0_1a3-python39;
          pythoneda-realm-unveilingpartner-latest-python310 =
            pythoneda-realm-unveilingpartner-0_0_1a3-python310;

        };
      });
}
