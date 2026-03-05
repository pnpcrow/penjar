---
title: 1. Self-hosting Guide
desc: Customize your Penjar instance today. Learn how to install with Elestio, Docker, or Kubernetes from the technical guide for self-hosting options.
---

# Self-hosting Guide

This guide explains how to get your own Penjar instance, running on a machine you control,
to test it, use it by you or your team, or even customize and extend it any way you like.

For additional context, see the post <a href="https://penjar.app/blog/how-to-self-host-penjar/" target="_blank">How to self-host Penjar: A technical implementation guide</a> on the Penjar blog.

<strong>The experience stays the same, whether you use
Penjar <a href="https://design.penjar.app" target="_blank">in the cloud</a>
or self-hosted.</strong>

<p class="advice">
Docker images are published shortly after the SaaS update:
<a href="https://community.penjar.app/t/why-do-self-hosted-versions-lag-behind-new-releases/9897" target="_blank">Why do self hosted versions lag behind new releases?</a>
</p>

These are the main options to configure your Penjar instance:

1. Deploy with [docker compose][2]
2. Use Kubernetes in its different flavors:
    - Deploy the [official Helm Chart][3]
    - Deploy in [Openshift][4]
    - Deploy in [Rancher][5]
3. Other official options:
    - [Elestio][6]
    - [Truenas][7]

Or you can try [other options][1], offered by Penjar community.

[1]: /technical-guide/getting-started/unofficial-options/
[2]: /technical-guide/getting-started/docker/
[3]: /technical-guide/getting-started/kubernetes/
[4]: /technical-guide/getting-started/kubernetes/#using-openshift%3F
[5]: /technical-guide/getting-started/kubernetes/#using-rancher%3F
[6]: /technical-guide/getting-started/elestio/
[7]: https://apps.truenas.com/catalog/penjar/
