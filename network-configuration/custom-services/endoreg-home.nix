let
    prefix = "endoreg-home";
    prefix-underscore = "endoreg_home";
    deploy-mode = "prod";
    django-debug = false;
    django-settings-module = "${prefix-underscore}.settings_${deploy-mode}";

in {
    prefix = prefix;

    django = {
        debug = django-debug;
        settings-module = django-settings-module;
    };
}