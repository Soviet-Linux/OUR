Soviet Linux OUR
================

The Soviet Linux OUR (Our User-made Repository) is the main repository in Soviet Linux. 

Adding Packages
---------------

We welcome all of our users to contribute packages to the OUR. Just make a pull request with the added package files.

Package Format
--------------

We use a format called `.spm`. This is how it works:

```
[type of package]
[dependencies (space sperated)]
[Download Command]
[Command to install in build]
[(name of the file in build ) (where to install the file)|(other file in build ) (where to install the file ) ]
```

An example `.spm` file looks like this:

```
source
bash git make 
git clone https://github.com/jaseg/lolcat
make && make DESTDIR=$BUILD_ROOT/ install
lolcat /bin/lolcat|censor /bin/censor
```


