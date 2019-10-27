# Ubuntu w/ Docker-in-Docker

Very similar to official Docker "dind" (https://hub.docker.com/_/docker). But with the following included:

* OpenSSH Client & Server
* Amazon Web Services (AWS) CLI
* AWS Elastic Kubernetes Service (EKS) CLI
* Helm w/ Tiller _(binaries)_
* Python 2 & 3 (w/ pip & pip3)
* Homebrew (linuxbrew) _[link](https://docs.brew.sh/Homebrew-on-Linux)_
* SDKMAN! _[link](https://sdkman.io/)_

And many more! :D

# How to use?

## As a Quickie SandBox (Transient/Temporary)

```bash
docker run -it --rm --privileged jpbaking/docker-in-docker
```

The container and volume/s will be deleted soon as you exit (from bash).

## As a Service/Server

This can serve as isolated environment for developers.

[![VideoDemo](https://i.imgur.com/cM0SJrt.png)](https://www.youtube.com/watch?v=wPr0K4Zw7k4)

Watch the demonstration: [https://www.youtube.com/watch?v=wPr0K4Zw7k4](https://www.youtube.com/watch?v=wPr0K4Zw7k4)

### First, docker run

Run the container with `--detach` and `--privileged`.

```bash
docker run --name the-dind --publish 22222:22 \
    --detach --privileged jpbaking/docker-in-docker
```

Name the container however you want to, and set the published SSH port to your preference

### Second, get into the shell

#### Option #1: bash --login

```bash
docker exec -it the-dind bash --login
```

**[IMPORTANT]** The `--login` is necessary for bash profiles to be loaded, so environment for CLI tools would be set (to work)!

#### Option #2: ssh

```bash
ssh -p 22222 ubuntu@127.0.0.1
# password is "ubuntu" without the quotes :P
```

You may even login to it remotely! Just replace localhost (127.0.0.1) with your docker host's IP/s.

# Volumes/Persistence

```bash
docker run --name the-dind --publish 22222:22 \
    --volume ${HOME}/.docker-in-docker:/var/lib/docker \
    --detach --privileged jpbaking/docker-in-docker
```

Just be sure to mount `/var/lib/docker` to something.

# License

Copyright 2019 Joseph Baking (josephbaking.ph@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
