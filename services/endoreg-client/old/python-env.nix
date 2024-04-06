# my-python-env.nix
let
  nixpkgs = import <nixpkgs> {}; # Import the Nix Packages collection

  # Define a custom Python environment
  pythonCudaEnvironment = nixpkgs.python3.withPackages (ps: with ps; [
    pandas
    numpy
    poetry-core
    pytesseract
    venvShellHook
    numpy
    torch
    gunicorn
    celery
    torchvision-bin
    torchaudio-bin
]);
in
pythonCudaEnvironment