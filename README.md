# Ubuntu w/ Docker-in-Docker

Very similar to official Docker "dind" (https://hub.docker.com/_/docker). But with the following included:

  1) OpenSSH Client & Server
  1) Amazon Web Services (AWS) CLI
  1) AWS Elastic Kubernetes Service (EKS) CLI
  1) Helm w/ Tiller _(binaries)_
  1) Python 2 & 3 (w/ pip & pip3)
  1) Homebrew (linuxbrew) _[link](https://docs.brew.sh/Homebrew-on-Linux)_
  1) SDKMAN! _[link](https://sdkman.io/)_
  1) _etc._

# How to use?

## As a Quickie SandBox (Transient/Temporary)

```bash
docker run -it --rm --privileged jpbaking/docker-in-docker
```

The container and volume/s will be deleted soon as you exit (from bash).

## As a Service/Server

This can serve as isolated environment for developers.

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
