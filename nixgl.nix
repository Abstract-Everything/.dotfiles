{ nixgl, ... }:

{
  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "mesa";
  nixGL.installScripts = [ "mesa" ];
}
