{...}: {
    powerManagement.enable = true;

	
	services.logind.extraConfig = ''
	# Disable user session suspension
	UserTasksMax=infinity

	# Disable system-wide session suspension
	SystemTasksMax=infinity
	'';
}