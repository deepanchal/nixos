# Fish port of the oh-my-zsh `docker` plugin.
# Source: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/docker/docker.plugin.zsh
{
  programs.fish.shellAbbrs = {
    # build
    dbl = "docker build";
    dib = "docker image build";

    # container
    dcin = "docker container inspect";
    dcls = "docker container ls";
    dclsa = "docker container ls -a";
    dcprune = "docker container prune";
    dlo = "docker container logs";
    dpo = "docker container port";
    dr = "docker container run";
    drit = "docker container run -it";
    drm = "docker container rm";
    "drm!" = "docker container rm -f";
    dst = "docker container start";
    drs = "docker container restart";
    dstp = "docker container stop";
    dxc = "docker container exec";
    dxcit = "docker container exec -it";

    # image
    dii = "docker image inspect";
    dils = "docker image ls";
    dipu = "docker image push";
    dipru = "docker image prune -a";
    dirm = "docker image rm";
    dit = "docker image tag";

    # network
    dnc = "docker network create";
    dncn = "docker network connect";
    dndcn = "docker network disconnect";
    dni = "docker network inspect";
    dnls = "docker network ls";
    dnprune = "docker network prune";
    dnrm = "docker network rm";

    # ps
    dps = "docker ps";
    dpsa = "docker ps -a";

    # pull
    dpu = "docker pull";

    # system / stats / top
    dsprune = "docker system prune";
    dsta = "docker stop (docker ps -q)";
    dsts = "docker stats";
    dtop = "docker top";

    # volume
    dvi = "docker volume inspect";
    dvls = "docker volume ls";
    dvprune = "docker volume prune";
  };
}
