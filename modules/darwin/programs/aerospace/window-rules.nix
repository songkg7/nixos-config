{
  on-window-detected = [
    {
      "if".app-id = "com.kakao.KakaoTalkMac";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "io.rize";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "cc.ffitch.shottr";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.1password.1password";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.heynote.app";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.tinyspeck.slackmacgap";
      check-further-callbacks = true;
      run = [ "move-node-to-workspace 3" ];
    }
    {
      "if".app-id = "ru.keepcoder.Telegram";
      check-further-callbacks = true;
      run = [ "move-node-to-workspace 3" ];
    }
    {
      "if".app-id = "com.jetbrains.intellij";
      check-further-callbacks = true;
      run = [ "move-node-to-workspace 2" ];
    }
    {
      "if".app-id = "com.cron.electron";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.hnc.Discord";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.apple.finder";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.apple.iCal";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.readdle.SparkDesktop-setapp";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.readdle.SparkDesktop.appstore";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.imagestudiopro.ScreenBrush";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "company.thebrowser.Browser";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.apple.Music";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.macpaw.CleanMyMac-setapp";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if" = {
        app-id = "app.zen-browser.zen";
        window-title-regex-substring = "Picture-in-Picture";
      };
      run = [ "layout floating" ];
    }
    {
      "if".app-id = "com.apple.mail";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.spotify.client";
      check-further-callbacks = true;
      run = "layout floating";
    }
    {
      "if".app-id = "com.mitchellh.ghostty";
      run = "layout tiling";
    }
  ];
}
