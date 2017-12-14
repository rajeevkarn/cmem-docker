# eccenca Corporate Memory

To install an **eccenca Corporate Memory** stack on Kubernetes you can use the following templates:

* [00_namespace.yml](00_namespace.yml)
* [01_pvc.yml](01_pvc.yml)
* [01_svc.yml](01_svc.yml)
* [02_cmem-ingress.yml](02_cmem-ingress.yml)
* [03_cmem-k8s.example.com-config.yml](03_cmem-k8s.example.com-config.yml)
* [03_dataintegration-config.yml](03_dataintegration-config.yml)
* [03_datamanger-config.yml](03_datamanger-config.yml)
* [03_dataplatform-config.yml](03_dataplatform-config.yml)
* [04_redis.yml](04_redis.yml)
* [04_stardog.yml](04_stardog.yml)
* [05_dataintegration.yml](05_dataintegration.yml)
* [05_datamanger.yml](05_datamanger.yml)
* [05_dataplatform.yml](05_dataplatform.yml)

## Secrets

To pull the images from the eccenca Docker registry you have to add the credentials as a secret with the comand below.
To get access please use our [contact form](https://www.eccenca.com/en/company-contact.html) to get in contact.

```bash
kubectl create secret docker-registry eccenca-registry-credentials --docker-server=https://docker-registry.eccenca.com --docker-username=USERNAME --docker-password=PASSWORD --docker-email=example@eccenca.com
```
