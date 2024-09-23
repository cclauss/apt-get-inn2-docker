```
docker build -t inn .
docker run --rm -t -p119:119 -p563:563 inn
```
To use this in a GitHub Action please add:
```yaml
    services:
      inn-service:
        image: cclauss/inn
        ports:
          - 119:119
          - 563:563
```
