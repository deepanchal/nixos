{
  pkgs,
  lib,
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "aml-flash-tool";
  version = "0-unstable-2026-10-14";

  src = pkgs.fetchFromGitHub {
    owner = "khadas";
    repo = "utils";
    rev = "a3604ed6d6863d1946d26d0ac8e765aef6f17430";
    hash = "sha256-um+tFhqibrwiPLeSg+APwjmyDu9nrwnvWHWbRTQpqwY=";
  };

  sourceRoot = "source/aml-flash-tool";

  nativeBuildInputs = [pkgs.autoPatchelfHook];

  buildInputs = [
    pkgs.systemdLibs
    pkgs.libusb-compat-0_1
  ];

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/libexec/aml-flash-tool tools/adnl/adnl tools/adnl/adnl_burn_pkg tools/linux-x86/update
    install -Dm755 -t $out/libexec/aml-flash-tool/usb_flow tools/adnl/usb_flow/*
    mkdir -p $out/lib/udev/rules.d
    cat > $out/lib/udev/rules.d/70-aml-flash-tool.rules <<'RULES'
    SUBSYSTEM=="usb", ATTR{idVendor}=="1b8e", ATTR{idProduct}=="c003", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="1b8e", ATTR{idProduct}=="c004", TAG+="uaccess"
    RULES

    mkdir -p $out/bin
    for tool in adnl adnl_burn_pkg update; do
      ln -s $out/libexec/aml-flash-tool/$tool $out/bin/$tool
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/khadas/utils/tree/master/aml-flash-tool";
    description = "Amlogic USB burning tools (adnl, adnl_burn_pkg, update) from Khadas";
    license = licenses.unfree;
    sourceProvenance = [sourceTypes.binaryNativeCode];
    mainProgram = "adnl_burn_pkg";
    platforms = ["x86_64-linux"];
  };
}
