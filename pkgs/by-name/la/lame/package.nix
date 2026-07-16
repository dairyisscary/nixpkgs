{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libmpg123,
  nasmSupport ? true,
  nasm, # Assembly optimizations
  cpmlSupport ? true, # Compaq's fast math library
  #, efenceSupport ? false, libefence # Use ElectricFence for malloc debugging
  sndfileFileIOSupport ? false,
  libsndfile, # Use libsndfile, instead of lame's internal routines
  analyzerHooksSupport ? true, # Use analyzer hooks
  decoderSupport ? true, # mpg123 decoder
  frontendSupport ? true, # Build the lame executable
  #, mp3xSupport ? false, gtk1 # Build GTK frame analyzer
  mp3rtpSupport ? false, # Build mp3rtp
  debugSupport ? false, # Debugging (disables optimizations)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lame";
  version = "4.0";

  src = fetchurl {
    url = "mirror://sourceforge/lame/lame-${finalAttrs.version}.tar.gz";
    hash = "sha256-PfUSTVrTqYMS/9e6aps2Iw5Pij5m084PQl4zbDLSFus=";
  };

  outputs = [
    "out"
    "lib"
    "doc"
  ]; # a small single header
  outputMan = "out";

  nativeBuildInputs =
    [ pkg-config ]
    ++ lib.optional nasmSupport nasm;

  buildInputs =
    [ libmpg123 ]
    #++ optional efenceSupport libefence
    #++ optional mp3xSupport gtk1
    ++ lib.optional sndfileFileIOSupport libsndfile;

  configureFlags = [
    (lib.enableFeature nasmSupport "nasm")
    (lib.enableFeature cpmlSupport "cpml")
    #(enableFeature efenceSupport "efence")
    (if sndfileFileIOSupport then "--with-fileio=sndfile" else "--with-fileio=lame")
    (lib.enableFeature analyzerHooksSupport "analyzer-hooks")
    (lib.enableFeature decoderSupport "decoder")
    (lib.enableFeature frontendSupport "frontend")
    (lib.enableFeature frontendSupport "dynamic-frontends")
    #(enableFeature mp3xSupport "mp3x")
    (lib.enableFeature mp3rtpSupport "mp3rtp")
    (lib.optionalString debugSupport "--enable-debug=alot")
  ];

  meta = {
    description = "High quality MPEG Audio Layer III (MP3) encoder";
    homepage = "http://lame.sourceforge.net";
    license = lib.licenses.lgpl2;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "lame";
  };
})
