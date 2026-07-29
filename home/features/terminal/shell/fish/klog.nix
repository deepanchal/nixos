{
  programs.fish = {
    shellAbbrs = {
      k = "klog";
      kt = "klog total --no-warn";
      ktt = "klog total --no-warn --today";
      kty = "klog total --no-warn --yesterday";
      ktm = "klog total --no-warn --this-month";
      kr = "klog report --no-warn";
      kp = "klog print --no-warn";
      kg = "klog tags --no-warn";
      ke = "klog edit";
      kin = "klog start";
      kout = "klog stop";
      ktr = "klog track";
    };

    functions = {
      _klog_payperiod_flags = ''
        set -l month (date +%Y-%m)
        set -l day (date +%-d)
        if test $day -le 15
          printf '%s\n' --period=$month --until=$month-15
        else
          printf '%s\n' --period=$month --since=$month-16
        end
      '';

      kpp = ''klog total --no-warn (_klog_payperiod_flags) $argv'';
      kppr = ''klog report --no-warn (_klog_payperiod_flags) $argv'';
    };
  };
}
