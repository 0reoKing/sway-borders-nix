{ lib, stdenv, fetchFromGitHub, substituteAll, swaybg
, meson, ninja, pkg-config, wayland, scdoc
, libxkbcommon, pcre, json_c, dbus, libevdev
, pango, cairo, libinput, libcap, pam, gdk-pixbuf, librsvg
, wlroots, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "sway-borders";
  version = "1.4";
  src = fetchFromGitHub {
    owner = "fluix-dev";
    repo = "sway-borders";
    rev = version;
    sha256 = "11qf89y3q92g696a6f4d23qb44gqixg6qxq740vwv2jw59ms34ja";
  };






  patches = [
    ./sway-config-no-nix-store-references.patch
    ./load-configuration-from-etc.patch

    (substituteAll {
      src = ./fix-paths.patch; 
      inherit swaybg;
  
    })
  ];


  nativeBuildInputs = [
    meson ninja pkg-config wayland scdoc
  ];

  buildInputs = [
    wayland libxkbcommon pcre json_c dbus libevdev
    pango cairo libinput libcap pam gdk-pixbuf librsvg
    wlroots wayland-protocols

(wlroots.overrideAttrs (_: 
    { 
      version = "11.0.0";
      src = fetchFromGitHub {
      # YOU NEED TO FILL THESE OUT
      owner = "fluix-dev";
      repo = "sway-borders";
      rev = "e9fa9821d7b34dc57b27f5e9e51339cdc8c0dd4b";
      sha256 = "11qf89y3q92g696a6f4d23qb44gqixg6qxq740vwv2jw59ms34ja";
       };
    } 
  )) wayland-protocols 
#  (wlroots.overrideAttrs (_: { version = "11.0.0";  } )) wayland-protocols 

];

  mesonFlags = [
    "-Ddefault-wallpaper=false"
  ];

  meta = with lib; {
    description = "A fork of sway to add new features such as borders.";
    longDescription = ''
   A fork of sway to add new feautres such as borders. 

    '';
    homepage    = "https://github.com/fluix-dev/sway-borders";
    changelog   = "https://github.com/fluix-dev/sway-borders/releases/tag/${version}";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ OreoKing ];
  };
}
