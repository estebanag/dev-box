FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# --- System packages ---
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ripgrep \
    htop \
    tree \
    jq \
    build-essential \
    python3-pip \
    python3-venv \
    ca-certificates \
    gnupg \
    gosu \
    unzip \
    locales \
    bash-completion \
    byobu \
  && rm -rf /var/lib/apt/lists/*

# --- Java ---
RUN apt-get update && apt-get install -y \
    maven \
    default-jdk \
  && rm -rf /var/lib/apt/lists/*

# --- Node.js ---
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
  && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*

# --- LaTeX ---
RUN apt-get update && apt-get install -y \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-lang-english \
    texlive-science \
    latexmk \
    texlive-luatex \
    texlive-bibtex-extra \
    biber \
  && rm -rf /var/lib/apt/lists/*

# --- nvim ---
RUN curl -fLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
  && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
  && rm nvim-linux-x86_64.tar.gz

# --- GUI tools ---
RUN apt-get update && apt-get install -y \
    geeqie \
    zathura \
    # dbus is required for working with zathura from nvim
    dbus \
    xauth \
  && rm -rf /var/lib/apt/lists/*

# --- Workspace dir ---
WORKDIR /workspace

# --- .bashrc additions ---
RUN echo 'set -o vi' >> /home/ubuntu/.bashrc \
  && echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> /home/ubuntu/.bashrc \
  && echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/ubuntu/.bashrc \
  && echo 'export PYTHONBREAKPOINT=ipdb.set_trace' >> /home/ubuntu/.bashrc

# --- UV (as ubuntu user) ---
RUN su -c 'curl -LsSf https://astral.sh/uv/install.sh | sh' ubuntu

# --- Byobu truecolor config (as ubuntu user) ---
# This makes sure the colors and display work properly when reattaching.
RUN su -c 'mkdir -p /home/ubuntu/.config/byobu \
  && echo "set -g default-terminal \"tmux-256color\"" >> /home/ubuntu/.config/byobu/.tmux.conf \
  && echo "set -ga terminal-overrides \",*:Tc\"" >> /home/ubuntu/.config/byobu/.tmux.conf' ubuntu

# --- AstroNvim template (as ubuntu user) ---
# Custom lua files are NOT copied here; the entrypoint overlays them at runtime.
RUN su -c 'git clone --depth 1 https://github.com/AstroNvim/template /home/ubuntu/.config/nvim \
  && rm -rf /home/ubuntu/.config/nvim/.git' ubuntu

# --- Entrypoint ---
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sleep", "infinity"]
