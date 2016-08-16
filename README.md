Poky Container
========================
This repo is to create an image that is able to run bitbake/poky. The main
difference between it and https://github.com/crops/yocto-dockerfiles is that
it has helpers to create users and groups within the container. This is so that
the output generated in the container will be readable by the user on the
host.

Running the container
---------------------
Here a very simple but usable scenario for using the container is described.
It is by no means the *only* way to run the container, but is a great starting
point.

* **Create a workdir and clone poky**

  First we'll create a directory that will be used for output from the build
  and as the location of poky.

  ```
  mkdir /home/myuser/workdir
  ```

  For the rest of the instructions we'll assume the workdir chosen was
  `/home/myuser/workdir`.

* **The docker command**

  Assuming you used the *workdir* from above, the command
  to run a container for the first time would be:

  ```
  docker run --rm -it -v /home/myuser/hostworkdir:/workdir crops/poky \
  --workdir=/workdir
  ```

  Let's discuss some of the options:
  * **_-v /home/myuser/workdir:/workdir_**: The default location of the workdir
    inside of the container is /workdir. So this part of the command says to
    use */home/myuser/workdir* as */workdir* inside the container.
  * **_--workdir=/workdir_**: This causes the container to start in the workdir
    specified. In this case it corresponds to */home/myuser/hostworkdir* due to
    the previous *-v* argument. The container will also use the uid and gid
    of the workdir as the uid and gid of the user in the container.

  This should put you at a prompt similar to:
  ```
  pokyuser@3bbac563cacd:/workdir$
  ```
  At this point you should be able to follow the same instructions as described
  in https://www.yoctoproject.org/docs/2.1/yocto-project-qs/yocto-project-qs.html#releases.
