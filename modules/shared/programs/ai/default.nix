{
  programs.claude-code = {
    enable = false;
    settings = {
      includeCoAuthoredBy = false;
      # env = {
      #   CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL = "1";
      #   CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
      # };
    };

    mcpServers = {
      github = {
        type = "http";
        url = "https://api.githubcopilot.com/mcp/";
      };
      filesystem = {
        type = "stdio";
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-filesystem"
          "/tmp"
        ];
      };
      # TODO: Add when available
      # serena = {
      # };
    };
  };

  programs.gemini-cli = {
    enable = true;

    # https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/configuration.md
    settings = {
      general = {
        checkpointing.enabled = true;
      };
      privacy = {
        usageStatisticsEnabled = false;
      };
      security = {
        auth.selectedType = "oauth-personal";
      };
    };
  };

  # opencode
  programs.opencode = {
    enable = true;
    settings = {
      theme = "cyberdream";
      # model = "anthropic/claude-sonnet-4-20250514";
      autoupdate = true;
    };
    # agents = {
    #   code-reviewer = ./opencode/code-reviewer-agent.md;
    #   documentation = ./opencode/documentation-agent.md;
    # };
    commands = {
      commit = ./opencode/commit-command.md;
    };
  };

  home.file = {
    ".config/opencode/opencode.json" = {
      source = ./opencode/opencode.json;
    };
    ".config/opencode/oh-my-opencode.json" = {
      source = ./opencode/oh-my-opencode.json;
    };
  };

  # codex
  programs.codex = {
    enable = true;
    settings = {
    };
  };
}
