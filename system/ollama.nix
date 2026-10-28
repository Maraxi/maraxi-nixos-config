{ pkgs, ... }: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;

    host = "127.0.0.1";
    port = 11434;

    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "16384";
    };
  };
}
