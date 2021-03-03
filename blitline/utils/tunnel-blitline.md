Without arguments:
```
$ ./tunnel-blitline.sh
Missing required options. See usage (./tunnel-blitline.sh -?)
```
Help text:
```
$ ./tunnel-blitline.sh -?
./tunnel-blitline.sh: illegal option -- ?
Usage: ./tunnel-blitline.sh <-k path-to-key> <-e env-code>
```
With missing options:
```
$ ./tunnel-blitline.sh -k ~/.ssh/warnerbros.nest.non.prod.pem
Missing required options. See usage (./tunnel-blitline.sh -?)
```
With bad environment code:
```
$ ./tunnel-blitline.sh -k ~/.ssh/warnerbros.nest.non.prod.pem -e dev
Fetching endpoint for dev
Failed to find endpoint.
```
With everything done right:
```
$ ./tunnel-blitline.sh -k ~/.ssh/warnerbros.nest.non.prod.pem -e dev-emu
Fetching endpoint for dev-emu
Fetching instance for dev-emu
Tunnelling to dev-emu
ssh -i /home/pmckeen/.ssh/warnerbros.nest.non.prod.pem -L 3000:vpce-0ea6819c5c8fef6c2-czq1mi1p.vpce-svc-0d30799844ac12ad2.us-west-2.vpce.amazonaws.com:80 ubuntu@i-05b02860dfd4b5293
Welcome to Ubuntu 18.04.2 LTS (GNU/Linux 4.15.0-1032-aws x86_64)
...
```
