{
  programs.aerospace = {
    enable = true;

    # Startup configuration
    userSettings = {
      after-login-command = [];
      after-startup-command = [];
      start-at-login = true;

      # Focus and mouse behavior
      on-focus-changed = ["move-mouse window-lazy-center"];

      # Normalizations
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # Layout configuration
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      # Key mapping
      key-mapping.preset = "qwerty";

      # Gaps configuration
      gaps = {
        inner = {
          horizontal = 10;
          vertical = 10;
        };
        outer = {
          left = 0;
          bottom = 0;
          top = 0;
          right = 0;
        };
      };

      # Execution environment
      exec = {
        inherit-env-vars = true;
        env-vars = {
          PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:\${PATH}";
        };
      };

      # Main mode bindings
      mode.main.binding = {
        # Layout commands
        "alt-slash" = "layout tiles horizontal vertical";
        "alt-comma" = "layout accordion horizontal vertical";

        # Focus commands
        "alt-h" = "focus --boundaries all-monitors-outer-frame --boundaries-action stop left";
        "alt-j" = "focus --boundaries all-monitors-outer-frame --boundaries-action stop down";
        "alt-k" = "focus --boundaries all-monitors-outer-frame --boundaries-action stop up";
        "alt-l" = "focus --boundaries all-monitors-outer-frame --boundaries-action stop right";
        "alt-s" = "focus-monitor --wrap-around next";

        # Move commands
        "alt-shift-h" = "move left";
        "alt-shift-j" = "move down";
        "alt-shift-k" = "move up";
        "alt-shift-l" = "move right";
        "alt-shift-s" = ["move-node-to-monitor --wrap-around next" "focus-monitor --wrap-around next"];

        # Window management
        "alt-shift-m" = "fullscreen";
        "alt-shift-t" = "layout floating tiling";

        # Resize commands
        "alt-shift-minus" = "resize smart -50";
        "alt-shift-equal" = "resize smart +50";

        # Workspace navigation
        "alt-1" = "workspace 1";
        "alt-2" = "workspace 2";
        "alt-3" = "workspace 3";
        "alt-4" = "workspace 4";
        "alt-5" = "workspace 5";
        "alt-6" = "workspace 6";
        "alt-7" = "workspace 7";
        "alt-8" = "workspace 8";
        "alt-9" = "workspace 9";

        # Move node to workspace
        "alt-shift-1" = "move-node-to-workspace 1";
        "alt-shift-2" = "move-node-to-workspace 2";
        "alt-shift-3" = "move-node-to-workspace 3";
        "alt-shift-4" = "move-node-to-workspace 4";
        "alt-shift-5" = "move-node-to-workspace 5";
        "alt-shift-6" = "move-node-to-workspace 6";
        "alt-shift-7" = "move-node-to-workspace 7";
        "alt-shift-8" = "move-node-to-workspace 8";
        "alt-shift-9" = "move-node-to-workspace 9";

        # Other commands
        "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";
        "alt-shift-c" = "reload-config";
        "alt-shift-semicolon" = "mode service";
      };

      # Service mode bindings
      mode.service.binding = {
        "esc" = ["reload-config" "mode main"];
        "r" = ["flatten-workspace-tree" "mode main"];
        "f" = ["layout floating tiling" "mode main"];

        # Join commands
        "alt-shift-h" = ["join-with left" "mode main"];
        "alt-shift-j" = ["join-with down" "mode main"];
        "alt-shift-k" = ["join-with up" "mode main"];
        "alt-shift-l" = ["join-with right" "mode main"];
      };

      # Window detection rules
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
          run = ["move-node-to-workspace 3"];
        }
        {
          "if".app-id = "ru.keepcoder.Telegram";
          check-further-callbacks = true;
          run = ["move-node-to-workspace 3"];
        }
        {
          "if".app-id = "com.jetbrains.intellij";
          check-further-callbacks = true;
          run = ["move-node-to-workspace 2"];
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
          run = ["layout floating"];
        }
        {
          "if".app-id = "com.apple.mail";
          check-further-callbacks = true;
          run = "layout floating";
        }
      ];
    };
  };
}
