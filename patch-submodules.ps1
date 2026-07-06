# patch-submodules.ps1

$launch_path = "ThirdParty/Maxima/maxima-lib/src/core/launch.rs"
if (Test-Path $launch_path) {
    $content = Get-Content -Raw -Path $launch_path

    # Normalize newlines to match regex regardless of CRLF/LF
    $content = $content -replace "`r`n", "`n"

    # Replace license check in LaunchMode::Online
    $target1 = '(?s)LaunchMode::Online\(_\) => \{.*?let auth = LicenseAuth::AccessToken\(maxima\.access_token\(\)\.await\?\);.*?let offer = offer\.as_ref\(\)\.unwrap\(\);.*?if needs_license_update\(&content_id\)\.await\? \{'
    $replacement1 = 'LaunchMode::Online(_) => {
            let auth = LicenseAuth::AccessToken(maxima.access_token().await?);

            let offer = offer.as_ref().unwrap();
            if !maxima.dummy_local_user() && needs_license_update(&content_id).await? {'

    $content = $content -replace $target1, $replacement1

    # Replace short_token retrieval
    $target2 = '(?s)LaunchMode::Online\(ref offer_id\) => \{.*?let short_token = request_opaque_ooa_token\(&access_token\)\.await\?;'
    $replacement2 = 'LaunchMode::Online(ref offer_id) => {
            let short_token = if maxima.dummy_local_user() {
                "dummy_short_token".to_string()
            } else {
                request_opaque_ooa_token(&access_token).await?
            };'

    $content = $content -replace $target2, $replacement2

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
