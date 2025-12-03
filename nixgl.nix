{ nixgl, ... }:

{
  targets.genericLinux.nixGL = {
    vulkan.enable = true;
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    offloadWrapper = "mesa";
    installScripts = [ "mesa" ];
  };
}
