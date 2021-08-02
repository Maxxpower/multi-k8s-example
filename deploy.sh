#build of images
docker build -t fimperioli/multi-client:latest -t fimperioli/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t fimperioli/multi-server:latest -t fimperioli/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t fimperioli/multi-worker:latest -t fimperioli/multi-worker:$SHA -f ./worker/Dockerfile ./worker
#push of the images also with unique tags
docker push fimperioli/multi-client:latest
docker push fimperioli/multi-client:$SHA
docker push fimperioli/multi-server:latest
docker push fimperioli/multi-server:$SHA
docker push fimperioli/multi-worker:latest
docker push fimperioli/multi-worker:$SHA
#apply all the k8s configs
kubectl apply -f k8s
#imperative command to set the latest image, 
#we need to generate unique tags for each image the re-apply the deployments f.i.
kubectl set image deployments/server-deployment server=fimperioli/multi-server:$SHA
kubectl set image deployments/client-deployment client=fimperioli/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=fimperioli/multi-worker:$SHA