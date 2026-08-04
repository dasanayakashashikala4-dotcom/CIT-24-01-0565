Lab 6 - Kubernetes Fundamentals - Answers

Student Name: P.D. Devmini Shashikala Dasanayaka
Student ID: CIT-24-01-0565



Task 1.2 - Component Matching Table

Pod Name: kube-apiserver-minikube
Component: API Server
Part of: Control Plane

Pod Name: etcd-minikube
Component: etcd (Key Value Store)
Part of: Control Plane

Pod Name: kube-scheduler-minikube
Component: Scheduler
Part of: Control Plane

Pod Name: kube-controller-manager-minikube
Component: Controller Manager
Part of: Control Plane

Pod Name: coredns-7d764666f9-sgwp6
Component: CoreDNS (DNS Service)
Part of: Control Plane

Pod Name: kube-proxy-bcxxt
Component: kube-proxy (Network Proxy)
Part of: Worker Node

Pod Name: storage-provisioner
Component: Storage Provisioner
Part of: Worker Node

Components NOT Observed as Pods:

kubelet - Runs as a system service on the node, not in a container
Container Runtime - Runs as a system service (Docker in my case)


Checkpoint Q1: Control Plane vs Worker Node

From what I saw in my cluster, the control plane is like the manager. It has the API Server, etcd, Scheduler, and Controller Manager. These components handle all the decisions and keep track of everything.

The worker node is where the actual work happens. In my Minikube cluster, everything runs on the same node because it's a single-node setup. But in production, they'd be separate. The worker node runs kubelet and kube-proxy to actually run the pods and handle networking.

The main difference is that the control plane tells the worker nodes what to do, and the worker nodes actually do it.



Checkpoint Q2: Pod IP Changed After Recreating

Yes, the IP adress changed. When I first created the pod, it had IP 10.244.0.4. After deleting it and recreating it from the same YAML file, the new pod got IP 10.244.0.5.

This shows that pods are temporary. When you delete a pod , it's gone completely including its IP address. When a new one is created, it gets a fresh IP from the pool. This is why we shouldn't rely on pod IPs directly - they can change at any time.



Checkpoint Q3: Self-Healing and the Control Loop

After I deleted one pod from my deployment , I watched what happened. Kubernetes immediately noticed that only 2 pods were running instead of the 3 I asked for. Within seconds, it created a new pod to replace the one I deleted.

This is the control loop working. The Controller Manager keeps watching the actual state of the cluster and compares it to what I declared (3 replicas). When there's a difference, it reconciles it by creating a new pod.

The best part is this runs automatically 24/7 , even if I'm not watchin

Checkpoint Q4: Independent Scaling

I scaled the frontend from 3 to 5 replicas and then down to 2, and it only affected the frontend pods. The API , cache, and database tiers were completelly unaffected.

This works because each tier is independent. They comunicate through services, not directly with each other's pods. So I can scale one tier without touching the others. This is really useful for handling different traffic patterns.



Checkpoint Q5: Port-Forward vs Service

When I used port forward, I was connecting directly to a specific pod. If that pod died , my connection would break and I'd have to set it up again. The URL also changed if the pod name changed.

With the Service, I got a stable endpoint that I could always use, regardlless of which pods were running. It load balances traffic to healthy pods automatically. Since pods are ephemeral and get new IPs, services are essential for reliable access to applications.



Checkpoint Q6: Docker Compose vs Kubernetes for Updates

From what I observed, doing updates with Docker Compose would be much harder. You'd have to stop all containers, update, and restart, which would cause downtime.

With Kubernetes, I just ran one command to update the image, and it rolled out the new version gradualy. One pod at a time, so users never lost access. When I needed to rollback, another single command instantly reverted to the previous version.

Docker Compose doesn't have built in health checks, rollback, or progresive updates. You'd have to do everything manually, which is risky for production.



Checkpoint Q7: Why Deployment for Frontend/API but StatefulSet for Database

The frontend and API are stateless. All their pods are identical and don't store any important data. If a pod dies, you just spin up a new one and it works. That's why they use Deployments.

The database is different. It stores actual data that I need to keep. With a StatefulSet, the pod gets a stable name (postgres-0) and a persistent volume that survives pod restarts. When I deleted the postgres pod and it came back, it mounted the same PVC and all my data was still there.

If I'd used a Deployment for the database, the data would be lost every time the pod restarted.



Checkpoint Q8: Would Data Survive with a Plain Deployment ?

No, definitelly not. If I had used a Deployment without a PVC, the data would be stored in the pod's container, which gets destroyed when the pod is deleted. When a new pod starts, it would have a fresh empty filesystem.

The StatefulSet with PVC is what saved my data. Even though the pod was deleted, the PVC stayed and preserved everything. When the new pod started, it reconnected to the same PVC and all my data was there.


Checkpoint Q9: Broken Pod Status

The broken pod showed ErrImagePull and then ImagePullBackOff. I used an image tag that didn't exist (nginx:definitely-not-a-real-tag), so Kubernetes couldn't pull it from Docker Hub.

This is similar to the Pending status from the lecture, but specifically for image pull failures. The pod couldn't start because it couldn't get the container image.

From the events , I saw the error message saying the manifest wasn't found. Kubernetes kept retrying with a backoff, but it would never succeed because the tag doesn't exist at all.
