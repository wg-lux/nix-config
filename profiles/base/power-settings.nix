{...}: {
    powerManagement = {
		enable = true;
		powertop.enable = true;
	};
	
	#TODO - check if this is needed
	services.logind.extraConfig = ''
	# Disable user session suspension
	UserTasksMax=infinity

	# Disable system-wide session suspension
	SystemTasksMax=infinity
	'';
}