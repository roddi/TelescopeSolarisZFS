# TelescopeSolarisZFS

This project extracts the relevant parts of OpenSolaris useful for
porting ZFS.

# HOWTO

## Prerequisites

You should have [git][git], [mercurial][hg] and the [mercurial convert extension][hgconvert] before proceeding. If you use mac ports read the Mac Ports Caveats section

## First-time Initialization

First, make sure you've got the hg fast-export submodules:

    git submodule init
    git submodule update

in ~/.hgrc add:
    
    [extensions]
    hgext.convert=

## Cloning OpenSolaris

Get a local clone of OpenSolaris using the `clone-repo` command.
`clone-repo` optionally takes a location of the source in case you
already have a local copy you wish to use.

The duration of this step will vary based on your bandwidth.  Budget
for however long it takes you to pull down about 350MB of data.

## Converting the Repo

Converting the repository is a two step process.  First, we build a
new mercurial repository from the important parts of the old one, and
then convert *that* repository to a git repo.

The reason we do this in two steps is because mercurial has a repo
rewriting tool to pull out the parts we want, which also makes the git
conversion faster.

However, it's just one step for you, the end user:

    ./telescope.sh

This should leave you with a repository called `zfs-converted-git`
that has all of the stuff you need and nothing you don't.

This step takes about an hour on my macbook pro.


## Mac Ports Caveat

If you installed Mercurial with Mac Ports you will have to change the following:

in fast-export/hg-fast-export.py the first line to:
    
    #!/usr/bin/env /opt/local/bin/python


[git]: http://git-scm.com/
[hg]: http://www.selenic.com/mercurial/
[hgconvert]: http://mercurial.selenic.com/wiki/ConvertExtension

