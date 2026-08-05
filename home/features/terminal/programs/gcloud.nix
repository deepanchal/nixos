{pkgs, ...}: let
  gcloudPython = pkgs.python3.withPackages (ps:
    with ps; [
      grpcio
      cffi
      cryptography
      pyopenssl
      crcmod
    ]);
in {
  home.packages = [
    pkgs.google-cloud-sdk
  ];

  home.sessionVariables = {
    CLOUDSDK_PYTHON = "${gcloudPython}/bin/python";
    CLOUDSDK_PYTHON_SITEPACKAGES = "1";
  };

  programs.mise.globalConfig.env = {
    CLOUDSDK_PYTHON = "${gcloudPython}/bin/python";
    CLOUDSDK_PYTHON_SITEPACKAGES = "1";
  };
}
