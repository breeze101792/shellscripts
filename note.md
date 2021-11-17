
## Script Path
```
echo ${BASH_SOURCE[0]})
```

## ssh tunnel
```
# bind remote port as local port
ssh -L [local_port]:localhost:[remote_port] root@127.0.0.1
# bind local port as reomote port
ssh -R [remote_port]:localhsot:[local_port] root@127.0.0.1
```
