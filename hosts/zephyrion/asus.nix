{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga503
  ];

  services.asusd = {
    enable = true;
    enableUserService = true;

    asusdConfig.text = ''
      (
        charge_control_end_threshold: 80,
        panel_od: false,
        mini_led_mode: false,
        disable_nvidia_powerd_on_battery: true,
        ac_command: "",
        bat_command: "",
        platform_policy_linked_epp: false,
        platform_policy_on_battery: Quiet,
        platform_policy_on_ac: Performance,
        ppt_pl1_spl: None,
        ppt_pl2_sppt: None,
        ppt_fppt: None,
        ppt_apu_sppt: None,
        ppt_platform_sppt: None,
        nv_dynamic_boost: None,
        nv_temp_target: None,
      )'';

    fanCurvesConfig.text = ''
      (
        balanced: [
            (
                fan: CPU,
                pwm: (2, 22, 45, 68, 91, 153, 153, 153),
                temp: (55, 62, 66, 70, 74, 78, 78, 78),
                enabled: true,
            ),
            (
                fan: GPU,
                pwm: (2, 25, 48, 71, 94, 165, 165, 165),
                temp: (55, 62, 66, 70, 74, 78, 78, 78),
                enabled: true,
            ),
        ],
        performance: [
            (
                fan: CPU,
                pwm: (35, 68, 79, 91, 114, 175, 175, 175),
                temp: (58, 62, 66, 70, 74, 78, 78, 78),
                enabled: true,
            ),
            (
                fan: GPU,
                pwm: (35, 71, 84, 94, 119, 188, 188, 188),
                temp: (58, 62, 66, 70, 74, 78, 78, 78),
                enabled: true,
            ),
        ],
        quiet: [
            (
                fan: CPU,
                pwm: (2, 12, 22, 35, 45, 58, 79, 79),
                temp: (55, 62, 66, 70, 74, 78, 82, 82),
                enabled: true,
            ),
            (
                fan: GPU,
                pwm: (2, 12, 25, 35, 48, 61, 84, 82),
                temp: (55, 62, 66, 70, 74, 78, 82, 82),
                enabled: true,
            ),
        ],
      )'';

    auraConfigs.default1.text = ''
      (
        brightness: Med,
        current_mode: Static,
        builtins: {
            Static: (
                mode: Static,
                zone: None,
                colour1: ( r: 166, g: 218, b: 149,),
                colour2: ( r: 0, g: 0, b: 0,),
                speed: Med,
                direction: Right,
            ),
            Breathe: (
                mode: Breathe,
                zone: None,
                colour1: ( r: 166, g: 218, b: 149,),
                colour2: ( r: 0, g: 0, b: 0,),
                speed: Med,
                direction: Right,
            ),
            Strobe: (
                mode: Strobe,
                zone: None,
                colour1: ( r: 166, g: 0, b: 0,),
                colour2: ( r: 0, g: 0, b: 0,),
                speed: High,
                direction: Right,
            ),
            Rainbow: (
                mode: Rainbow,
                zone: None,
                colour1: ( r: 166, g: 0, b: 0,),
                colour2: ( r: 0, g: 0, b: 0,),
                speed: Med,
                direction: Right,
            ),
            Pulse: (
                mode: Pulse,
                zone: None,
                colour1: ( r: 166, g: 0, b: 0,),
                colour2: ( r: 0, g: 0, b: 0,),
                speed: Med,
                direction: Right,
            ),
        },
        multizone: None,
        multizone_on: false,
        enabled: AuraDevRog2((
            keyboard: (
                zone: Keyboard,
                boot: true,
                awake: true,
                sleep: true,
                shutdown: true,
            ),
            logo: (
                zone: Logo,
                boot: true,
                awake: true,
                sleep: true,
                shutdown: true,
            ),
            lightbar: (
                zone: Lightbar,
                boot: true,
                awake: true,
                sleep: true,
                shutdown: true,
            ),
            lid: (
                zone: Lid,
                boot: true,
                awake: true,
                sleep: true,
                shutdown: true,
            ),
            rear_glow: (
                zone: RearGlow,
                boot: true,
                awake: true,
                sleep: true,
                shutdown: true,
            ),
        )),
      )'';
  };

  services.supergfxd = {
    enable = true;
    # settings = {
    #
    # };
  };

  environment.systemPackages = with pkgs; [
    ryzenadj
  ];
}
