_: {
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
}
