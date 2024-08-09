# Running my minikube

At this point i have a [vagrant image](../../vagrant/vagrant_minikube/Vagrantfile) of minikube.

```bash
cd # go where the vagrantfile is
vagrant up
vagrant ssh
```

## issue
For now i have to do `vagrant up` twice and i have no clue why.

## pros
As minikube is intended as a teaching tool and as my host is already full of useless packages the vagrant image saves me the trouble of a local installation of the minikube service.

## cons
### accessing dashboard
I had trouble accessing my dashboard.
Normally you access your dashboard by running `minikube dashboard` and pasting the givent URL in your brother, but my VM does not have a graphic interface.
So i have to create a kubectl proxy :

```bash
minikube dashboard # note the route and live
kubectl proxy --address='0.0.0.0' --disable-filter=true # anybody can access the api
```

My route is : `http/{IP}:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/workloads?namespace=default`, it is accessible from the host.

I am pretty sure it won't change on another app but i don't really know.


#### about the funky command
The command :
```bash
kubectl proxy --address='0.0.0.0' --disable-filter=true
```
I to consider as a work in progress, I have to find a way to limit the addresses able to access the dashboard.
I have clues but i did not test anything.