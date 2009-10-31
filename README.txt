TelescopeSolarisZFS

this project does:

- create a disk image
- checkout OpenSolaris with Mercurial
- finds out which commits have ZFS-relevant changes
- step-by-step checks out these relevant changes and commits them to a git repository.

Howto:

1. install git and mercurial
2. run makeDmgAndCheckout.sh in the Terminal from the project directory (will take approx. 1/2h)
3. Mount the resulting OpenSolaris.sparsebundle by double-clicking in the Finder
4. run telescope.sh (this will take a loooong time)
5. you will now have a telescoped git repository in onnv-gate/usr in the SolarisSource volume which you can clone

