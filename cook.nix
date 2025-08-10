# https://github.com/obsidiansystems/obelisk/tree/master/lib/asset
{ obelisk ? import ../obelisk {
    system = builtins.currentSystem;
    iosSdkVersion = "10.2";
  }
}:
with obelisk;
mkAssets ./static