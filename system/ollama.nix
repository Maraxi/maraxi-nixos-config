{ pkgs, ... }: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;

    host = "127.0.0.1";
    port = 11434;

    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "65536";
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
      OLLAMA_NUM_PARALLEL = "1";
      OLLAMA_KEEP_ALIVE = "30m";
    };
  };
}
