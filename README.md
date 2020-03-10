# http-shield

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/stewartpark/http-shield?style=flat-square)
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/stewartpark/http-shield?style=flat-square)

☸️ http-shield is a Kubernetes sidecar container that protects a concurrent, compute-heavy service from a burst of requests.

There's a `docker-compose.yml` file for demo purposes, if you'd like to try it out quickly.

```
# Demo app waits for 1 second before it returns a response.
$ docker-compose up -d

# 10 concurrent requests to an endpoint that only allows 1 concurrent connection
$ ab -n 10 -c 10 http://localhost:8080/api/heavy1
...
Requests per second:    1.00 [#/sec] (mean)
...

# 10 concurrent requests to an unprotected endpoint
$ ab -n 10 -c 10 http://localhost:8080/
...
Requests per second:    4.99 [#/sec] (mean)
...
```


## How to use

You can use this as a Kubernetes sidecar container to your service like this:

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  ...
spec:
  ...
  template:
    ...
    spec:
      containers:
        - name: http-shield
          image: stewartpark/http-shield:latest
          ports: [{ containerPort: 8080 }]
          env:
            - name: SERVER_PORT
              value: '3000'  # Your application's port
            - name: ENDPOINTS_0
              value: '1:/api/heavy1,/api/heavy2' # These APIs will only allow one concurrent connections (if /api/heavy1 has one, /api/heavy2 waits)
            - name: ENDPOINTS_1
              value: '10:/api/hi' # You can add more than one rule. /api/hi will have the maximum concurrency of 10.
            # Rest of the endpoints will be unprotected and will have unlimited concurrency.
        - name: your-app
          ...
```

And let your Service resource point to `8080`, instead of your application port.
