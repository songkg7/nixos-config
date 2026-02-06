{
  pkgs,
  ...
}:
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
          READ_ONLY_MODE = "false";
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
    enable = true;
    # settings = {
    #   includeCoAuthoredBy = false;
    # };

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
    enable = !(pkgs.stdenv.isDarwin && pkgs.stdenv.isx86_64);
    enableMcpIntegration = true;
    settings = {
      theme = "lucent-orng";
      # model = "anthropic/claude-sonnet-4-20250514";
      autoupdate = true;
      plugin = [
        "oh-my-opencode"
        "opencode-openai-codex-auth"
        "opencode-antigravity-auth@1.1.2"
      ];
      "$schema" = "https://opencode.ai/config.json";
      provider = {
        google = {
          models = {
            "gemini-3-pro-high" = {
              name = "Gemini 3 Pro High (Antigravity)";
              limit = {
                context = 1048576;
                output = 65535;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
            };
            "gemini-3-flash" = {
              name = "Gemini 3 Flash (Antigravity)";
              limit = {
                context = 1048576;
                output = 65536;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
            };
            "gemini-2.5-flash" = {
              name = "Gemini 2.5 Flash (Antigravity)";
              limit = {
                context = 1048576;
                output = 65536;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [ "text" ];
              };
            };
          };
        };
        openai = {
          options = {
            reasoningEffort = "medium";
            reasoningSummary = "auto";
            textVerbosity = "medium";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
          models = {
            "gpt-5.2" = {
              name = "GPT 5.2 Medium (OAuth)";
              limit = {
                context = 272000;
                output = 128000;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                ];
                output = [ "text" ];
              };
              options = {
                reasoningEffort = "medium";
                reasoningSummary = "auto";
                textVerbosity = "medium";
                include = [ "reasoning.encrypted_content" ];
                store = false;
              };
            };
            "gpt-5.2-medium" = {
              name = "GPT 5.2 Medium (OAuth)";
              limit = {
                context = 272000;
                output = 128000;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                ];
                output = [ "text" ];
              };
              options = {
                reasoningEffort = "medium";
                reasoningSummary = "auto";
                textVerbosity = "medium";
                include = [ "reasoning.encrypted_content" ];
                store = false;
              };
            };
          };
        };
      };
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
    # ".config/opencode/opencode.json" = {
    #   source = ./opencode/opencode.json;
    # };
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
