
{ 
 system = {
		  activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
	keyboard={
	 enableKeyMapping=true;
	 remapCapsLockToEscape=true;
	};
  };
}
