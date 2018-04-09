Poky Container
========================
This repo is to create an image that is able to run bitbake/poky. The main
difference between it and https://github.com/crops/yocto-dockerfiles is that
it has helpers to create users and groups within the container. This is so that
the output generated in the container will be readable by the user on the
host.

The instructions will be slightly different depending on whether Linux, Windows or Mac is used. There are setup instructions for using **Windows/Mac** at https://github.com/crops/docker-win-mac-docs/wiki. When referring to **Windows/Mac** in the rest of the document, it is assumed the instructions at https://github.com/crops/docker-win-mac-docs/wiki were followed.

Running the container
---------------------
Here a very simple but usable scenario for using the container is described.
It is by no means the *only* way to run the container, but is a great starting
point.

* **Create a workdir or volume**
  * **Linux**

    The workdir you create will be used for the output created while using the container.
    For example a user could create a directory using the command
  
    ```
    mkdir -p /home/myuser/mystuff
    ```

    *It is important that you are the owner of the directory.* The owner of the
    directory is what determines the user id used inside the container. If you
    are not the owner of the directory, you may not have access to the files the
    container creates.

    For the rest of the Linux instructions we'll assume the workdir chosen was
    `/home/myuser/mystuff`.
    
  * **Windows/Mac**

    On Windows or Mac a workdir isn't needed. Instead the volume called *myvolume* will be used. This volume should have been created when following the instructions at https://github.com/crops/docker-win-mac-docs/wiki.


* **The docker command**
  * **Linux**

    Assuming you used the *workdir* from above, the command
    to run a container for the first time would be:

    ```
    docker run --rm -it -v /home/myuser/mystuff:/workdir crops/poky --workdir=/workdir
    ```
    
  * **Windows/Mac**
  
    ```
    docker run --rm -it -v myvolume:/workdir crops/poky --workdir=/workdir
    ```

  Let's discuss the options:
  * **_--workdir=/workdir_**: This causes the container to start in the directory
    specified. This can be any directory in the container. The container will also use the uid and gid
    of the workdir as the uid and gid of the user in the container.

  This should put you at a prompt similar to:
  ```
  pokyuser@3bbac563cacd:/workdir$
  ```
  At this point you should be able to follow the same instructions as described
  in https://www.yoctoproject.org/docs/current/yocto-project-qs/yocto-project-qs.html#releases.

Troubleshooting
---------------

### runqemu - ERROR - TUN control device /dev/net/tun is unavailable; you may need to enable TUN (e.g. sudo modprobe tun)

Add the `slirp` argument to your `runqemu` call to use usermode networking instead of TUN. Example:

    runqemu qemux86 slirp

### runqemu - ERROR - Failed to run qemu: Could not initialize SDL(No available video device) - exiting

Add the `nographic` argument to your `runqemu` call to avoid using SDL. The text output will go to your console. Example:

    runqemu qemux86 nographic

### Accessing core-image-sato GUI via VNC

Since this image has a graphical interface, when SDL is unavailable an alternative to accessing its GUI is via a VNC client. Informing the argument `publicvnc` to `runqemu` will make QEMU setup a VNC server at port 5900.

    runqemu qemux86 slirp publicvnc

But to get to the container's internal port 5900, you must map it to an available host port, for example 20000. Add the `-p` option when starting your container:

    docker run --rm -it -v myvolume:/workdir -p 20000:5900 crops/poky --workdir=/workdir

After running `runqemu`, point your VNC client to `127.0.0.1:20000`.

> Mac users: You must download a third party VNC client. The builtin client available in Finder (Command-K) does not connect to the local host.

### Access running QEMU image via SSH

If your image has an active SSH server, before connecting to it you must map container's port 22 to an available host port, such as 2222. Note that when using the `slirp` argument to `runqemu`, an internal redirect from 2222 to 22 is already in place. In this case you must map the container's 2222 port, not 22. Example:

    docker run --rm -it -v myvolume:/workdir -p 2222:2222 crops/poky --workdir=/workdir
