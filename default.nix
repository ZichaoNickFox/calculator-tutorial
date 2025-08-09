{ obelisk ? import ../obelisk {
    system = builtins.currentSystem;
    iosSdkVersion = "10.2";
    # You must accept the Android Software Development Kit License Agreement at
    # https://developer.android.com/studio/terms in order to build Android apps.
    # Uncomment and set this to `true` to indicate your acceptance:
    # config.android_sdk.accept_license = false;
  }
}:
with obelisk;
project ./. ({ pkgs, hackGet, ... }:
with pkgs.haskell.lib; {
  android.applicationId = "systems.obsidian.obelisk.examples.minimal";
  android.displayName = "Obelisk Minimal Example";
  ios.bundleIdentifier = "systems.obsidian.obelisk.examples.minimal";
  ios.bundleName = "Obelisk Minimal Example";
  __closureCompilerOptimizationLevel = null;
  packages = {
    mmark = hackGet ./dep/mmark;
    modern-uri = hackGet ./dep/modern-uri;
  };
  overrides = self: super: {
    temporary = dontCheck super.temporary;
    email-validate = dontCheck super.email-validate;
    mmark = if (self.ghc.isGhcjs or false) then dontHaddock super.mmark else super.mmark;
    modern-uri = doJailbreak super.modern-uri;
    frontend = overrideCabal super.frontend (drv: {
      buildTools = (drv.buildTools or []) ++ [ self.buildHaskellPackages.markdown-unlit ];
    });
  };
  shellToolOverrides = _: _: {
    ob = command;
  };
})
