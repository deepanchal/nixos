# Fish port of the oh-my-zsh `docker-compose` plugin.
# Source: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/docker-compose/docker-compose.plugin.zsh
#
# omz prefers the legacy `docker-compose` v1 binary if installed, otherwise
# falls back to the v2 `docker compose` CLI plugin. NixOS uses v2.
{
  programs.fish.shellAbbrs = {
    dco = "docker compose";
    dcb = "docker compose build";
    dce = "docker compose exec";
    dcps = "docker compose ps";
    dcrestart = "docker compose restart";
    dcrm = "docker compose rm";
    dcr = "docker compose run";
    dcstop = "docker compose stop";
    dcup = "docker compose up";
    dcupb = "docker compose up --build";
    dcupd = "docker compose up -d";
    dcupdb = "docker compose up -d --build";
    dcdn = "docker compose down";
    dcl = "docker compose logs";
    dclf = "docker compose logs -f";
    dclF = "docker compose logs -f --tail 0";
    dcpull = "docker compose pull";
    dcstart = "docker compose start";
    dck = "docker compose kill";
  };
}
