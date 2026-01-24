const oauthLandingPage = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <link rel="icon" href="https://uplink.kyber.gg/content/images/size/w256h256/2024/03/kyber-logo-web.png" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

  <meta property="og:site_name" content="Kyber">
  <meta property="og:title" content="Welcome to Kyber">
  <meta property="og:image" content>
  <meta property="og:type" content="website">
  <meta property="og:url" content="kyber.gg">
  <title>Auth Success</title>
  <link rel="stylesheet" href="https://s3.kyber.gg/frontend-assets/patreon-css/index.c56e6394.css">
</head>
<body class="overflow-x-hidden">
<div class="container">
  <div class="content">
    <h3 class="yellow-title">
      Auth Success
    </h3>
    <p style="font-size: 17px">
      You successfully authorized Patreon. You can now close this tab and return to the Launcher.
    </p>
  </div>
</div>
</body>

<style>
  .container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
  }

  .content {
    backdrop-filter: blur(20px);
    border-radius: 3px;
    width: 575px;
    height: 200px;
    border: 1px solid #333;
    padding: 30px ;
  }

  .yellow-title {
    color: #fbb10a;
    font-size: 24px;
    text-shadow: 0 0 30px rgba(251, 177, 10, 0.6);
    text-align: left;
    text-transform: uppercase;
  }
</style>

</html>
''';
