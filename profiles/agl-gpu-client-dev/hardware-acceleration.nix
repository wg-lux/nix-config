{pkgs, ... }:

{
    services.auto-cpufreq.enable = true;
    services.auto-cpufreq.settings = {

        battery = {
            governor = "powersave";
            turbo = "never";
        };
        charger = {
            governor = "performance";
            turbo = "always"; # or "auto" or "never"
            energy_performance_preference = "power";
            scaling_min_freq = 200000; # 800MHz
            scaling_max_freq = 4500000; # 4GHz

        };
    };
}