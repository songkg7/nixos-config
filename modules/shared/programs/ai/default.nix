{
  programs.mcp = {
    enable = true;
    servers = {
      atlassian = {
        command = "uvx";
        args = [ "mcp-atlassian" ];
        env = {
          JIRA_URL = "{env:JIRA_URL}";
          JIRA_USERNAME = "{env:JIRA_USERNAME}";
          JIRA_API_TOKEN = "{env:JIRA_TUI_JIRA_API_TOKEN}";
          CONFLUENCE_URL = "{env:CONFLUENCE_URL}";
          CONFLUENCE_USERNAME = "{env:CONFLUENCE_USERNAME}";
          CONFLUENCE_API_TOKEN = "{env:CONFLUENCE_API_TOKEN}";
          READ_ONLY_MODE = "true";
        };
      };
      exa = {
        disabled = true;
        command = "npx";
        args = [
          "-y"
          "exa-mcp-server"
        ];
        env = {
          EXA_API_KEY = "{env:EXA_API_KEY}";
        };
      };
      mongodb = {
        disabled = true;
        command = "npx";
        args = [
          "-y"
          "mongodb-mcp-server@latest"
          "--readOnly"
        ];
        env = {
          MDB_MCP_CONNECTION_STRING = "{env:MDB_MCP_CONNECTION_STRING_INT}";
        };
      };
      postgres = {
        disabled = true;
        command = "uvx";
        args = [
          "postgres-mcp"
          "--access-mode=restricted"
          "{env:POSTGRES_MCP_DATABASE_URL_INT}"
        ];
      };
      osgrep = {
        command = "osgrep";
        args = [ "mcp" ];
      };
    };
  };

  programs.claude-code = {
    enable = false;
    settings = {
      includeCoAuthoredBy = false;
      # env = {
      #   CLAUDE_CODE_IDE_SKIP_AUTO_INSTALL = "1";
      #   CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
      # };
    };

    # mcpServers = {
    #   github = {
    #     type = "http";
    #     url = "https://api.githubcopilot.com/mcp/";
    #   };
    #   filesystem = {
    #     type = "stdio";
    #     command = "npx";
    #     args = [
    #       "-y"
    #       "@modelcontextprotocol/server-filesystem"
    #       "/tmp"
    #     ];
    #   };
    #   # TODO: Add when available
    #   # serena = {
    #   # };
    # };
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
    enableMcpIntegration = true;
    settings = {
      theme = "lucent-orng";
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
