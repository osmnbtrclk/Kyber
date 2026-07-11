# patch-submodules.ps1

$launch_path = "ThirdParty/Maxima/maxima-lib/src/core/launch.rs"
if (Test-Path $launch_path) {
    $content = Get-Content -Raw -Path $launch_path

    # Normalize newlines to match regex regardless of CRLF/LF
    $content = $content -replace "`r`n", "`n"

    # Replace license check in LaunchMode::Online
    $target1 = '(?s)LaunchMode::Online\(_\) =\> \{.*?let auth = LicenseAuth::AccessToken\(maxima\.access_token\(\)\.await\?\);.*?let offer = offer\.as_ref\(\)\.unwrap\(\);.*?if needs_license_update\(&content_id\)\.await\? \{'
    $replacement1 = 'LaunchMode::Online(_) => {
            let auth = LicenseAuth::AccessToken(maxima.access_token().await?);

            let offer = offer.as_ref().unwrap();
            if !maxima.dummy_local_user() && needs_license_update(&content_id).await? {'

    $content = $content -replace $target1, $replacement1

    # Replace short_token retrieval
    $target2 = '(?s)LaunchMode::Online\(ref offer_id\) =\> \{.*?let short_token = request_opaque_ooa_token\(&access_token\)\.await\?;'
    $replacement2 = 'LaunchMode::Online(ref offer_id) => {
            let short_token = if maxima.dummy_local_user() {
                "dummy_short_token".to_string()
            } else {
                request_opaque_ooa_token(&access_token).await?
            };'

    $content = $content -replace $target2, $replacement2

    # Replace EA library lookup with dummy user bypass
    $target4 = '(?s)let \(content_id, online_offline, offer, access_token\) =\s+if let LaunchMode::Online\(ref offer_id\) = mode \{\s+let access_token = &maxima\.access_token\(\)\.await\?;\s+let offer = match maxima\.mut_library\(\)\.game_by_base_offer\(offer_id\)\.await\? \{\s+Some\(offer\) => offer,\s+None => return Err\(LaunchError::NoOfferFound\(offer_id\.clone\(\)\)\),\s+\};\s+if !offer\.is_installed\(\)\.await \{\s+return Err\(LaunchError::NotInstalled\(offer\.offer_id\(\)\.clone\(\)\)\);\s+\}\s+let content_id = offer\.offer\(\)\.content_id\(\)\.to_owned\(\);\s+\(\s+content_id,\s+false,\s+Some\(offer\.clone\(\)\),\s+access_token\.to_owned\(\),\s+\)\s+\} else if let LaunchMode::OnlineOffline\(ref content_id, _, _\) = mode \{\s+\(content_id\.to_owned\(\), true, None, String::new\(\)\)\s+\} else \{\s+return Err\(LaunchError::Offline\);\s+\};'
    $replacement4 = 'let (content_id, online_offline, offer, access_token) =
        if let LaunchMode::Online(ref offer_id) = mode {
            let access_token = &maxima.access_token().await?;

            if maxima.dummy_local_user() {
                // Dummy user: skip library lookup, use placeholder values
                (
                    offer_id.clone(),
                    false,
                    None,
                    access_token.to_owned(),
                )
            } else {
                let offer = match maxima.mut_library().game_by_base_offer(offer_id).await? {
                    Some(offer) => offer,
                    None => return Err(LaunchError::NoOfferFound(offer_id.clone())),
                };

                if !offer.is_installed().await {
                    return Err(LaunchError::NotInstalled(offer.offer_id().clone()));
                }

                let content_id = offer.offer().content_id().to_owned();

                (
                    content_id,
                    false,
                    Some(offer.clone()),
                    access_token.to_owned(),
                )
            }
        } else if let LaunchMode::OnlineOffline(ref content_id, _, _) = mode {
            (content_id.to_owned(), true, None, String::new())
        } else {
            return Err(LaunchError::Offline);
        };'

    $content = $content -replace $target4, $replacement4

    $target5 = '(?s)match offer \{\s+Some\(ref offer\) => offer\.execute_path\(false\)\.await\?\.clone\(\),\s+None => return Err\(LaunchError::NoOfferFound\("Unknown"\.to_string\(\)\)\),\s+\}'
    $replacement5 = 'match offer {
            Some(ref offer) => offer.execute_path(false).await?.clone(),
            None => {
                let mut found_path = None;
                #[cfg(windows)]
                {
                    let hklm = winreg::RegKey::predef(winreg::enums::HKEY_LOCAL_MACHINE);
                    if let Ok(key) = hklm.open_subkey("SOFTWARE\\EA Games\\STAR WARS Battlefront II") {
                        if let Ok(install_dir) = key.get_value::<String, _>("Install Dir") {
                            let p = std::path::PathBuf::from(install_dir).join("starwarsbattlefrontii.exe");
                            if p.exists() {
                                found_path = Some(p);
                            }
                        }
                    }
                }
                if let Some(p) = found_path {
                    p
                } else {
                    return Err(LaunchError::NoOfferFound("Unknown".to_string()));
                }
            }
        }'

    $content = $content -replace $target5, $replacement5

    Set-Content -Path $launch_path -Value $content -NoNewline
    Write-Host "Patched launch.rs successfully!"
}

$mod_path = "ThirdParty/Maxima/maxima-lib/src/core/mod.rs"
if (Test-Path $mod_path) {
    $content = Get-Content -Raw -Path $mod_path
    $content = $content -replace "`r`n", "`n"

    $target3 = '(?s)pub async fn access_token\(&mut self\) -> Result<String, TokenError> \{.*?let mut auth_storage = self\.auth_storage\.lock\(\)\.await;.*?match auth_storage\.access_token\(\)\.await\? \{'
    $replacement3 = 'pub async fn access_token(&mut self) -> Result<String, TokenError> {
        if self.dummy_local_user.is_some() {
            return Ok("dummy_token".to_string());
        }
        let mut auth_storage = self.auth_storage.lock().await;
        match auth_storage.access_token().await? {'

    $content = $content -replace $target3, $replacement3

    Set-Content -Path $mod_path -Value $content -NoNewline
    Write-Host "Patched mod.rs successfully!"
}
