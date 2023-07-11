# SMALL TOC

![Logo](./logo.svg)

A lightweight table-of-content generator for Markdown

## Table of content

- [About](#about)
    - [Short story](#short-story)
- [Installing](#installing)
- [Uninstalling](#uninstalling)
- [Usage](#usage)
    - [Getting help](#getting-help)

## About

Written in shell script, POSIX-compliant table of content *(TOC for short)* generator.

**NOTE:**
This page's table of content was also made by this script.

### Short story

I needed a TOC generator so I made one myself.  
**THE END**

> It's short, innit? :smirk:

## Installing

For now, the only way is cloning the repository to your local machine.

Get the whole git tree.
```sh
git clone https://github.com/Adamocho/smalltoc.git ~/.local/smalltoc
```

Get the latest code only (git shallow clone) - less disk space.
```sh
git clone --depth 1 https://github.com/Adamocho/smalltoc.git ~/.local/smalltoc
```

Now `cd` inside and install it.

```sh
./smalltoc.sh install
```

> This script may need execute permission.  
> In that case use: `[sudo] chmod +x FILENAME`

## Uninstalling

Simply use `uninstall`

```sh
smalltoc uninstall
```

> NOTE: This command **DOES NOT** remove the files from one's computer. It only deletes this script from `/usr/bin/` directory. If one wishes to remove the files entirely, delete the git repository (with *uninstalling* done first).

## Usage

Usage is very straightforward.
Just give it file(s) to generate TOC for.

```sh
smalltoc FILE_1 FILE_2 FILE_3 [...]
# OR
smalltoc [OPTION]
```

It saves them in the `$HOME/.cache/smalltoc` directory.

Sample output
```text
[...]
Generating TOC for ~/Documents/sample_readme.md
The file is saved in ~/.cache/smalltoc/README.md
```

### Getting help

Use it either without arguments or with `-h` | `--help` flags.
