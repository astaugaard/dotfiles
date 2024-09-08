{
	xsession.windowManager.xmonad = {
		enable = true;
		enableContribAndExtras = true;
		extraPackages = haskellPackages: [
            haskellPackages.dynamicDashboard
		];
		config = ./config.hs;
	};
}
