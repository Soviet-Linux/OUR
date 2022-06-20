# <p align="center">OUR - the main repository for Soviet Linux.</p>


<p align="center">The Soviet Linux OUR (Our User-made Repository) is the main repository in Soviet Linux.</p>

Adding Packages
---------------

All of our users are welcome to contribute packages to the OUR. Simply submit a pull request with the new package files.

Package Format
--------------

Follow this example to create a package:
```
{
    "name" : "<package name>",
    "type" : "<src,bin>",
    "version" : "<version>",
    "dependencies" : ["<a dependencie>","<other dependencie>"],
    "info" : 
    {
        "build" : "<build command>",
        "test" : "<test command>",
        "install" : "<nstall command>",
        "special" : "<special command>"
    },
    "locations" : ["<location>","<other location>"]
}
```
If its a source package leave the location blank

for more info see the [docs](https://docs.sovietlinux.ml/repo)
