{ config, agl-network-config, ... } @inputs:
let

    hosts = agl-network-config.hosts;

in {
    config.networking.hosts = hosts;
}